package egovframework.hyb.mbl.aic.client;

import java.net.URI;
import java.net.URLEncoder;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.nio.charset.StandardCharsets;
import java.time.Duration;
import java.util.UUID;
import java.util.function.Consumer;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

/**
 * egovframe-ai-rag REST 클라이언트.
 * Flutter는 MCP/RAG를 직접 호출하지 않고 이 클라이언트를 통해 질의한다.
 * JSON(/ai/rag)과 SSE(/ai/rag/stream)를 모두 지원한다.
 */
@Component
public class EgovAiRagClient {

	private static final Logger LOGGER = LoggerFactory.getLogger(EgovAiRagClient.class);

	private final HttpClient httpClient = HttpClient.newBuilder()
			.connectTimeout(Duration.ofSeconds(10))
			.build();

	private final ObjectMapper objectMapper = new ObjectMapper();

	private static final long DEFAULT_MODEL_CACHE_MS = 5 * 60 * 1000L;

	@Value("${Globals.AiRag.Url:http://127.0.0.1:8080}")
	private String aiRagBaseUrl;

	@Value("${Globals.AiRag.Model:}")
	private String configuredModelNm;

	private final Object defaultModelLock = new Object();
	private volatile String cachedDefaultModel = "";
	private volatile long cachedDefaultModelAt;

	/**
	 * egovframe-ai-rag 프로세스가 HTTP로 응답하는지만 확인한다.
	 * 연결 실패는 예외로 올리지 않고 false를 반환한다.
	 */
	public boolean isReachable() {
		try {
			HttpRequest request = HttpRequest.newBuilder()
					.uri(URI.create(trimSlash(aiRagBaseUrl) + "/api/ollama/models"))
					.timeout(Duration.ofSeconds(3))
					.header("Accept", "application/json")
					.GET()
					.build();
			HttpResponse<Void> response = httpClient.send(request, HttpResponse.BodyHandlers.discarding());
			return response.statusCode() >= 200 && response.statusCode() < 500;
		} catch (Exception e) {
			LOGGER.info("ai-rag unreachable: {}", e.getMessage());
			return false;
		}
	}

	/**
	 * 앱이 모델명을 안 보내면 ai-rag 기본 모델({@code /api/ollama/models})을 쓰고,
	 * 그것도 없으면 {@code Globals.AiRag.Model} 을 쓴다.
	 */
	public String resolveModelNm(String requested) {
		if (requested != null && !requested.isBlank()) {
			return requested.trim();
		}
		String fromRag = peekCachedDefaultModel();
		if (!fromRag.isBlank()) {
			return fromRag;
		}
		fromRag = fetchDefaultModel();
		if (!fromRag.isBlank()) {
			return fromRag;
		}
		return configuredModelNm == null ? "" : configuredModelNm.trim();
	}

	public AiRagReply ask(String question, String chatMode, String modelNm, String sessionId) throws Exception {
		return ask(question, chatMode, modelNm, sessionId, null);
	}

	public AiRagReply ask(String question, String chatMode, String modelNm, String sessionId,
			Consumer<String> sessionIdConsumer) throws Exception {
		String resolvedSessionId = (sessionId == null || sessionId.isBlank())
				? createOrFallbackSessionId()
				: sessionId.trim();
		if (sessionIdConsumer != null) {
			sessionIdConsumer.accept(resolvedSessionId);
		}

		String mode = (chatMode == null || chatMode.isBlank()) ? "rag" : chatMode.trim().toLowerCase();
		String path = "simple".equals(mode) ? "/ai/simple" : "/ai/rag";

		String uri = buildChatUri(path, question, resolvedSessionId, modelNm);

		HttpRequest request = HttpRequest.newBuilder()
				.uri(URI.create(uri))
				.timeout(Duration.ofSeconds(600))
				.header("Accept", "application/json, text/plain")
				.GET()
				.build();

		// 질문 원문이 로그에 남지 않도록 경로만 기록한다.
		LOGGER.info("ai-rag request: {}", path);
		HttpResponse<String> response = httpClient.send(request, HttpResponse.BodyHandlers.ofString(StandardCharsets.UTF_8));
		if (response.statusCode() < 200 || response.statusCode() >= 300) {
			throw new IllegalStateException("ai-rag HTTP " + response.statusCode());
		}

		AiRagReply reply = extractReply(response.body());
		if (reply.getAnswer() == null || reply.getAnswer().isBlank()) {
			throw new IllegalStateException("ai-rag empty answer");
		}
		return reply;
	}

	/**
	 * ai-rag SSE를 한 토큰씩 읽어 콜백으로 넘긴다. 본문을 끝까지 모아 두지 않는다.
	 */
	public AiRagReply stream(String question, String chatMode, String modelNm, String sessionId,
			Consumer<String> sessionIdConsumer, Consumer<String> tokenConsumer) throws Exception {
		String resolvedSessionId = (sessionId == null || sessionId.isBlank())
				? createOrFallbackSessionId()
				: sessionId.trim();
		if (sessionIdConsumer != null) {
			sessionIdConsumer.accept(resolvedSessionId);
		}

		String mode = (chatMode == null || chatMode.isBlank()) ? "rag" : chatMode.trim().toLowerCase();
		String path = "simple".equals(mode) ? "/ai/simple/stream" : "/ai/rag/stream";
		String uri = buildChatUri(path, question, resolvedSessionId, modelNm);

		HttpRequest request = HttpRequest.newBuilder()
				.uri(URI.create(uri))
				.timeout(Duration.ofSeconds(600))
				.header("Accept", "text/event-stream")
				.GET()
				.build();

		LOGGER.info("ai-rag stream: {}", path);
		HttpResponse<java.io.InputStream> response = httpClient.send(request,
				HttpResponse.BodyHandlers.ofInputStream());
		if (response.statusCode() < 200 || response.statusCode() >= 300) {
			throw new IllegalStateException("ai-rag HTTP " + response.statusCode());
		}

		StringBuilder rawAll = new StringBuilder();
		ThinkStreamGate gate = new ThinkStreamGate(isReasoningModel(modelNm));
		try (java.io.BufferedReader reader = new java.io.BufferedReader(
				new java.io.InputStreamReader(response.body(), StandardCharsets.UTF_8))) {
			StringBuilder data = new StringBuilder();
			String line;
			while ((line = reader.readLine()) != null) {
				if (line.isEmpty()) {
					String token = readSseToken(data.toString());
					data.setLength(0);
					if (token != null && !token.isEmpty()) {
						rawAll.append(token);
					}
					forwardVisible(gate, tokenConsumer, token);
					continue;
				}
				if (line.startsWith("data:")) {
					String payload = line.substring(5);
					if (payload.startsWith(" ")) {
						payload = payload.substring(1);
					}
					if (data.length() > 0) {
						data.append('\n');
					}
					data.append(payload);
				}
			}
			String token = readSseToken(data.toString());
			if (token != null && !token.isEmpty()) {
				rawAll.append(token);
			}
			forwardVisible(gate, tokenConsumer, token);
			forwardVisible(gate, tokenConsumer, null, gate.finish());
		}

		String raw = rawAll.toString();
		if (raw.isBlank()) {
			throw new IllegalStateException("ai-rag empty answer");
		}
		return extractReply("{\"answer\":" + objectMapper.writeValueAsString(raw) + "}");
	}

	private void forwardVisible(ThinkStreamGate gate, Consumer<String> tokenConsumer, String token) {
		forwardVisible(gate, tokenConsumer, token, null);
	}

	private void forwardVisible(ThinkStreamGate gate, Consumer<String> tokenConsumer, String token, String finished) {
		String out = finished != null ? finished : gate.push(token);
		if (out == null || out.isEmpty()) {
			return;
		}
		if (tokenConsumer != null) {
			tokenConsumer.accept(out);
		}
	}

	private boolean isReasoningModel(String modelNm) {
		if (modelNm == null || modelNm.isBlank()) {
			return true;
		}
		String n = modelNm.toLowerCase();
		return n.contains("qwen3") || n.contains("qwq") || n.contains("deepseek-r1") || n.contains("r1-");
	}

	private String buildChatUri(String path, String question, String sessionId, String modelNm) {
		StringBuilder uri = new StringBuilder(trimSlash(aiRagBaseUrl))
				.append(path)
				.append("?message=")
				.append(URLEncoder.encode(question, StandardCharsets.UTF_8))
				.append("&sessionId=")
				.append(URLEncoder.encode(sessionId, StandardCharsets.UTF_8));
		if (modelNm != null && !modelNm.isBlank()) {
			uri.append("&model=").append(URLEncoder.encode(modelNm.trim(), StandardCharsets.UTF_8));
		}
		return uri.toString();
	}

	private String readSseToken(String data) {
		if (data == null || data.isBlank()) {
			return null;
		}
		try {
			JsonNode node = objectMapper.readTree(data);
			if (node != null && node.hasNonNull("token")) {
				return node.get("token").asText();
			}
			if (node != null && node.isTextual()) {
				return node.asText();
			}
			if (node != null && node.isObject()) {
				return null;
			}
		} catch (Exception ignored) {
			return data;
		}
		return data;
	}

	private String peekCachedDefaultModel() {
		if (cachedDefaultModel == null || cachedDefaultModel.isBlank()) {
			return "";
		}
		if (System.currentTimeMillis() - cachedDefaultModelAt > DEFAULT_MODEL_CACHE_MS) {
			return "";
		}
		return cachedDefaultModel;
	}

	private String fetchDefaultModel() {
		synchronized (defaultModelLock) {
			String cached = peekCachedDefaultModel();
			if (!cached.isBlank()) {
				return cached;
			}
			try {
				HttpRequest request = HttpRequest.newBuilder()
						.uri(URI.create(trimSlash(aiRagBaseUrl) + "/api/ollama/models"))
						.timeout(Duration.ofSeconds(5))
						.header("Accept", "application/json")
						.GET()
						.build();
				HttpResponse<String> response = httpClient.send(request,
						HttpResponse.BodyHandlers.ofString(StandardCharsets.UTF_8));
				if (response.statusCode() >= 200 && response.statusCode() < 300) {
					JsonNode node = objectMapper.readTree(response.body());
					if (node != null && node.hasNonNull("defaultModel")) {
						String name = node.get("defaultModel").asText("").trim();
						if (!name.isBlank()) {
							cachedDefaultModel = name;
							cachedDefaultModelAt = System.currentTimeMillis();
							return name;
						}
					}
				}
			} catch (Exception e) {
				LOGGER.warn("ai-rag default model lookup failed: {}", e.getMessage());
			}
			return "";
		}
	}

	public String reindexDocuments() throws Exception {
		HttpRequest request = HttpRequest.newBuilder()
				.uri(URI.create(trimSlash(aiRagBaseUrl) + "/api/documents/reindex"))
				.timeout(Duration.ofSeconds(30))
				.header("Accept", "text/plain, application/json")
				.POST(HttpRequest.BodyPublishers.noBody())
				.build();
		LOGGER.info("ai-rag reindex: {}", request.uri());
		HttpResponse<String> response = httpClient.send(request,
				HttpResponse.BodyHandlers.ofString(StandardCharsets.UTF_8));
		if (response.statusCode() < 200 || response.statusCode() >= 300) {
			throw new IllegalStateException("ai-rag HTTP " + response.statusCode());
		}
		String body = response.body();
		return body == null || body.isBlank() ? "문서 재인덱싱이 처리되었습니다." : body.trim();
	}

	public JsonNode documentStatus() throws Exception {
		HttpRequest request = HttpRequest.newBuilder()
				.uri(URI.create(trimSlash(aiRagBaseUrl) + "/api/documents/status"))
				.timeout(Duration.ofSeconds(10))
				.header("Accept", "application/json")
				.GET()
				.build();
		HttpResponse<String> response = httpClient.send(request,
				HttpResponse.BodyHandlers.ofString(StandardCharsets.UTF_8));
		if (response.statusCode() < 200 || response.statusCode() >= 300) {
			throw new IllegalStateException("ai-rag HTTP " + response.statusCode());
		}
		JsonNode node = objectMapper.readTree(response.body());
		return node == null || node.isNull() ? objectMapper.createObjectNode() : node;
	}

	private String createOrFallbackSessionId() {
		try {
			HttpRequest request = HttpRequest.newBuilder()
					.uri(URI.create(trimSlash(aiRagBaseUrl) + "/api/chat/sessions"))
					.timeout(Duration.ofSeconds(10))
					.header("Accept", "application/json")
					.POST(HttpRequest.BodyPublishers.noBody())
					.build();
			HttpResponse<String> response = httpClient.send(request,
					HttpResponse.BodyHandlers.ofString(StandardCharsets.UTF_8));
			if (response.statusCode() >= 200 && response.statusCode() < 300) {
				JsonNode node = objectMapper.readTree(response.body());
				if (node != null) {
					if (node.hasNonNull("sessionId")) {
						return node.get("sessionId").asText();
					}
					if (node.hasNonNull("id")) {
						return node.get("id").asText();
					}
				}
			}
		} catch (Exception e) {
			LOGGER.warn("ai-rag session create failed, fallback uuid: {}", e.getMessage());
		}
		return UUID.randomUUID().toString();
	}

	private AiRagReply extractReply(String body) {
		String answer = stripThink(readBody(body));
		return new AiRagReply(peelEnglishPreamble(answer));
	}

	/**
	 * 태그 없이 답 앞에 붙는 영어 혼잣말("Let me try to write the answer in Korean")을
	 * 버리고, 한글 본문만 답변으로 남긴다.
	 */
	private String peelEnglishPreamble(String answer) {
		if (answer == null || answer.isBlank()) {
			return "";
		}
		java.util.regex.Matcher hangul = java.util.regex.Pattern.compile("[가-힣]").matcher(answer);
		if (!hangul.find()) {
			return answer.strip();
		}
		int hangulAt = hangul.start();
		String prefix = answer.substring(0, hangulAt).strip();
		if (!looksLikeReasoningPreamble(prefix)) {
			return answer.strip();
		}
		return answer.substring(hangulAt).strip();
	}

	private boolean looksLikeReasoningPreamble(String prefix) {
		if (prefix == null || prefix.isBlank()) {
			return false;
		}
		java.util.regex.Pattern phrase = java.util.regex.Pattern.compile(
				"(?i)let me (try|write|answer|explain)|write the answer in korean|answer in korean"
						+ "|the user (asked|wants|is asking)|i (should|need to|will|am going to)"
						+ "|okay[,.]|wait[,.]|the question is");
		if (phrase.matcher(prefix).find()) {
			return true;
		}
		long letters = prefix.chars().filter(Character::isLetter).count();
		if (letters < 12) {
			return false;
		}
		return prefix.length() >= 20 || prefix.contains("\n") || prefix.contains(". ");
	}

	private String readBody(String body) {
		if (body == null || body.isBlank()) {
			return "";
		}

		try {
			JsonNode node = objectMapper.readTree(body);
			if (node == null || node.isMissingNode() || node.isNull()) {
				return body.trim();
			}
			if (node.isTextual()) {
				return node.asText();
			}
			if (node.hasNonNull("answer")) {
				return node.get("answer").asText();
			}
			if (node.hasNonNull("token")) {
				return node.get("token").asText();
			}
			if (node.hasNonNull("content")) {
				return node.get("content").asText();
			}
			if (node.has("result") && node.get("result").has("output")) {
				JsonNode outputNode = node.get("result").get("output");
				if (outputNode != null && outputNode.isTextual()) {
					return outputNode.asText();
				}
			}
			return body.trim();
		} catch (Exception ignored) {
			return body.trim();
		}
	}

	private String stripThink(String text) {
		if (text == null || text.isBlank()) {
			return "";
		}
		String cleaned = text.replaceAll("(?is)<thinking>.*?</thinking>", "");
		cleaned = cleaned.replaceAll("(?is)<think>.*?</think>", "");
		int thinkingEnd = indexOfIgnoreCase(cleaned, "</thinking>");
		int thinkEnd = indexOfIgnoreCase(cleaned, "</think>");
		int end = minIndex(thinkEnd, thinkingEnd);
		if (end >= 0) {
			int tagLen = thinkingEnd == end ? "</thinking>".length() : "</think>".length();
			cleaned = cleaned.substring(end + tagLen);
		}
		cleaned = cleaned.replaceAll("(?is)<thinking>.*", "");
		cleaned = cleaned.replaceAll("(?is)<think>.*", "");
		return cleaned.strip();
	}

	private static int indexOfIgnoreCase(String haystack, String needle) {
		return haystack.toLowerCase().indexOf(needle);
	}

	private static int minIndex(int left, int right) {
		if (left < 0) {
			return right;
		}
		if (right < 0) {
			return left;
		}
		return Math.min(left, right);
	}

	private String trimSlash(String url) {
		if (url == null) {
			return "";
		}
		return url.endsWith("/") ? url.substring(0, url.length() - 1) : url;
	}

	public static final class AiRagReply {
		private final String answer;

		public AiRagReply(String answer) {
			this.answer = answer == null ? "" : answer;
		}

		public String getAnswer() {
			return answer;
		}
	}

	/**
	 * qwen3는 {@code <think>} 없이 추론을 쓰다가 {@code </think>} 로 닫는 경우가 많다.
	 * 닫히기 전까지는 Flutter로 토큰을 넘기지 않는다.
	 */
	private static final class ThinkStreamGate {
		private final StringBuilder pending = new StringBuilder();
		private final boolean holdUntilThinkClosed;
		private boolean inThink;
		private boolean released;

		private ThinkStreamGate(boolean holdUntilThinkClosed) {
			this.holdUntilThinkClosed = holdUntilThinkClosed;
			this.released = !holdUntilThinkClosed;
		}

		private String push(String token) {
			if (token == null || token.isEmpty()) {
				return "";
			}
			pending.append(token);
			return drain();
		}

		private String finish() {
			if (inThink) {
				pending.setLength(0);
				return "";
			}
			String rest = pending.toString();
			pending.setLength(0);
			if (holdUntilThinkClosed && !released) {
				return "";
			}
			return rest;
		}

		private String drain() {
			StringBuilder visible = new StringBuilder();
			while (pending.length() > 0) {
				String buffer = pending.toString();
				if (!inThink) {
					int thinkAt = indexOfIgnoreCase(buffer, "<think>");
					int thinkingAt = indexOfIgnoreCase(buffer, "<thinking>");
					int start = minIndex(thinkAt, thinkingAt);
					int thinkEnd = indexOfIgnoreCase(buffer, "</think>");
					int thinkingEnd = indexOfIgnoreCase(buffer, "</thinking>");
					int end = minIndex(thinkEnd, thinkingEnd);

					if (end >= 0 && (start < 0 || end < start)) {
						int tagLen = thinkingEnd == end ? "</thinking>".length() : "</think>".length();
						pending.delete(0, end + tagLen);
						released = true;
						continue;
					}
					if (start < 0) {
						if (holdUntilThinkClosed && !released) {
							break;
						}
						visible.append(buffer);
						pending.setLength(0);
						break;
					}
					if (released || !holdUntilThinkClosed) {
						visible.append(buffer, 0, start);
					}
					inThink = true;
					int tagLen = thinkingAt == start ? "<thinking>".length() : "<think>".length();
					pending.delete(0, start + tagLen);
				} else {
					int thinkEnd = indexOfIgnoreCase(buffer, "</think>");
					int thinkingEnd = indexOfIgnoreCase(buffer, "</thinking>");
					int end = minIndex(thinkEnd, thinkingEnd);
					if (end < 0) {
						String lower = buffer.toLowerCase();
						int lt = lower.lastIndexOf('<');
						if (lt < 0) {
							pending.setLength(0);
						} else {
							String tail = lower.substring(lt);
							if ("<".equals(tail) || "</think>".startsWith(tail) || "</thinking>".startsWith(tail)) {
								pending.delete(0, lt);
							} else {
								pending.setLength(0);
							}
						}
						break;
					}
					int tagLen = thinkingEnd == end ? "</thinking>".length() : "</think>".length();
					pending.delete(0, end + tagLen);
					inThink = false;
					released = true;
				}
			}
			return visible.toString();
		}
	}
}
