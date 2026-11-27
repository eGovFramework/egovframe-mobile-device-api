package egovframework.hyb.mbl.aic.web;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

import org.springframework.context.support.MessageSourceAccessor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.method.annotation.SseEmitter;

import com.fasterxml.jackson.databind.ObjectMapper;

import egovframework.hyb.mbl.aic.service.AiChatAPIVO;
import egovframework.hyb.mbl.aic.service.EgovAiChatAPIService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.annotation.PreDestroy;
import jakarta.annotation.Resource;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.DeleteMapping;

@Controller
@Tag(name = "17. AI Chat Guide Program Service", description = "AI 채팅 API 및 RAG 문서 관리 (egovframe-ai-rag 중계)")
public class EgovAiChatAPIController {

	private static final long SSE_TIMEOUT_MS = 600_000L;

	private static final Logger LOGGER = LoggerFactory.getLogger(EgovAiChatAPIController.class);

	private final ObjectMapper objectMapper = new ObjectMapper();
	/** SSE 중계 스레드 상한. 초과 요청은 큐에서 대기한다. */
	private static final int SSE_MAX_THREADS = 16;

	private final ExecutorService sseExecutor = Executors.newFixedThreadPool(SSE_MAX_THREADS, runnable -> {
		Thread thread = new Thread(runnable, "ai-chat-sse");
		thread.setDaemon(true);
		return thread;
	});

	@Resource(name = "EgovAiChatAPIService")
	private EgovAiChatAPIService egovAiChatAPIService;

	@Resource
	private MessageSourceAccessor messageSourceAccessor;

	@PreDestroy
	void shutdownSseExecutor() {
		sseExecutor.shutdownNow();
	}

	private String msg(String code) {
		return messageSourceAccessor.getMessage(code);
	}

	private boolean isBlank(String value) {
		return value == null || value.trim().isEmpty();
	}

	private ResponseEntity<Map<String, Object>> uuidRequiredResponse() {
		Map<String, Object> response = new HashMap<>();
		response.put("resultState", "FAIL");
		response.put("resultMessage", "uuid is required");
		return ResponseEntity.badRequest().body(response);
	}

	@Operation(summary = "AI 서버 연결 확인", description = "egovframe-ai-rag(LLM) 서버에 연결되는지 확인합니다.")
	@GetMapping("/aic/selectAiRagConnection.do")
	public ResponseEntity<Map<String, Object>> selectAiRagConnection() {
		Map<String, Object> response = new HashMap<>();
		response.put("resultState", "OK");
		response.put("connected", egovAiChatAPIService.isAiRagConnected());
		return ResponseEntity.ok(response);
	}

	@Operation(summary = "AI 채팅 목록 조회", description = "저장된 질문-답변 목록을 조회합니다.")
	@GetMapping("/aic/selectAiChatInfoList.do")
	public ResponseEntity<Map<String, Object>> selectAiChatInfoList(AiChatAPIVO searchVO)
			throws Exception {
		if (isBlank(searchVO.getUuid())) {
			return uuidRequiredResponse();
		}

		Map<String, Object> response = new HashMap<>();
		List<AiChatAPIVO> aiChatInfoList = egovAiChatAPIService.selectAiChatInfoList(searchVO);
		List<Map<String, Object>> mapped = new ArrayList<>();
		for (Object item : aiChatInfoList) {
			if (item instanceof AiChatAPIVO vo) {
				mapped.add(vo.toClientMap());
			} else if (item instanceof Map<?, ?> rawMap) {
				Map<String, Object> copy = new LinkedHashMap<>();
				for (Map.Entry<?, ?> entry : rawMap.entrySet()) {
					if (entry.getKey() != null) {
						copy.put(String.valueOf(entry.getKey()), entry.getValue());
					}
				}
				mapped.add(copy);
			}
		}
		response.put("aiChatInfoList", mapped);
		response.put("resultState", "OK");
		return ResponseEntity.ok(response);
	}

	@Operation(summary = "AI 채팅 등록", description = "질문-답변을 웹 DB에 등록합니다.")
	@PostMapping("/aic/insertAiChatInfo.do")
	public ResponseEntity<Map<String, Object>> insertAiChatInfo(AiChatAPIVO vo) throws Exception {
		if (isBlank(vo.getUuid())) {
			return uuidRequiredResponse();
		}

		Map<String, Object> response = new HashMap<>();
		int cnt = egovAiChatAPIService.insertAiChatInfo(vo);
		if (cnt > 0) {
			response.put("resultState", "OK");
			response.put("sn", vo.getSn());
			response.put("resultMessage", "insert success");
		} else {
			response.put("resultState", "FAIL");
			response.put("resultMessage", "insert fail");
		}
		return ResponseEntity.ok(response);
	}

	@Operation(summary = "AI 질의", description = "egovframe-ai-rag에 질의한 뒤 웹 DB에 저장하고 답변을 반환합니다.")
	@PostMapping("/aic/askAiChatInfo.do")
	public ResponseEntity<Map<String, Object>> askAiChatInfo(AiChatAPIVO vo) throws Exception {
		if (isBlank(vo.getUuid())) {
			return uuidRequiredResponse();
		}
		if (isBlank(vo.getQuestion())) {
			Map<String, Object> response = new HashMap<>();
			response.put("resultState", "FAIL");
			response.put("resultMessage", "question is required");
			return ResponseEntity.badRequest().body(response);
		}

		Map<String, Object> response = new HashMap<>();
		try {
			AiChatAPIVO saved = egovAiChatAPIService.askAiChatInfo(vo);
			response.put("resultState", "OK");
			response.put("resultMessage", "ask success");
			response.put("aiChatInfo", saved.toClientMap());
		} catch (Exception e) {
			LOGGER.error("AI 질의 실패", e);
			response.put("resultState", "FAIL");
			response.put("resultMessage", "질의에 실패했습니다");
		}
		return ResponseEntity.ok(response);
	}

	@Operation(summary = "AI 질의(SSE)", description = "egovframe-ai-rag 스트림을 중계하고, 생성이 끝나면 웹 DB에 저장합니다.")
	@RequestMapping(value = "/aic/askAiChatInfoStream.do", method = { RequestMethod.GET, RequestMethod.POST },
			produces = MediaType.TEXT_EVENT_STREAM_VALUE)
	public SseEmitter askAiChatInfoStream(AiChatAPIVO vo) {
		SseEmitter emitter = new SseEmitter(SSE_TIMEOUT_MS);
		sseExecutor.execute(() -> {
			try {
				if (isBlank(vo.getUuid())) {
					sendSse(emitter, Map.of("type", "error", "resultState", "FAIL", "resultMessage", "uuid is required"));
					emitter.complete();
					return;
				}
				if (isBlank(vo.getQuestion())) {
					sendSse(emitter, Map.of("type", "error", "resultState", "FAIL", "resultMessage", "question is required"));
					emitter.complete();
					return;
				}

				AiChatAPIVO saved = egovAiChatAPIService.askAiChatInfoStream(vo, token -> {
					Map<String, Object> payload = new LinkedHashMap<>();
					payload.put("type", "token");
					payload.put("token", token);
					sendSse(emitter, payload);
				});

				Map<String, Object> done = new LinkedHashMap<>();
				done.put("type", "done");
				done.put("resultState", "OK");
				done.put("resultMessage", "ask success");
				done.put("aiChatInfo", saved.toClientMap());
				sendSse(emitter, done);
				emitter.complete();
			} catch (Exception e) {
				LOGGER.error("AI 질의 스트림 실패", e);
				try {
					sendSse(emitter, Map.of("type", "error", "resultState", "FAIL", "resultMessage", "질의에 실패했습니다"));
					emitter.complete();
				} catch (Exception ignored) {
					emitter.completeWithError(e);
				}
			}
		});
		return emitter;
	}

	private void sendSse(SseEmitter emitter, Map<String, ?> payload) {
		try {
			emitter.send(SseEmitter.event().data(objectMapper.writeValueAsString(payload)));
		} catch (Exception e) {
			throw new IllegalStateException("sse send fail", e);
		}
	}

	@Operation(summary = "RAG 문서 업로드", description = "공통 RAG 문서를 ai-rag.fileStorePath에 저장한 뒤 재인덱싱을 요청합니다. 앱이 아닌 운영/Swagger용입니다.")
	@PostMapping(value = "/aic/uploadAiRagDocument.do", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
	public ResponseEntity<Map<String, Object>> uploadAiRagDocument(
			@Parameter(description = "업로드할 문서 파일") @RequestParam("files") MultipartFile[] files)
			throws Exception {
		Map<String, Object> response = new LinkedHashMap<>();
		try {
			List<MultipartFile> fileList = new ArrayList<>();
			if (files != null) {
				for (MultipartFile file : files) {
					if (file != null && !file.isEmpty()) {
						fileList.add(file);
					}
				}
			}
			if (fileList.isEmpty()) {
				response.put("resultState", "FAIL");
				response.put("resultMessage", msg("aic.msg.uploadEmpty"));
				return ResponseEntity.ok(response);
			}
			Map<String, Object> uploaded = egovAiChatAPIService.uploadAiRagDocuments(fileList);
			response.put("resultState", "OK");
			response.put("resultMessage", msg("aic.msg.uploadSuccess"));
			response.putAll(uploaded);
		} catch (IllegalArgumentException | SecurityException e) {
			// 확장자·크기 등 입력 검증 메시지만 그대로 돌려준다.
			response.put("resultState", "FAIL");
			response.put("resultMessage", e.getMessage());
		} catch (Exception e) {
			LOGGER.error("RAG 문서 업로드 실패", e);
			response.put("resultState", "FAIL");
			response.put("resultMessage", msg("aic.msg.uploadFail"));
		}
		return ResponseEntity.ok(response);
	}

	@Operation(summary = "RAG 문서 재인덱싱", description = "ai-rag.fileStorePath 문서를 다시 임베딩합니다. 앱이 아닌 운영/Swagger용입니다.")
	@PostMapping("/aic/reindexAiRagDocument.do")
	public ResponseEntity<Map<String, Object>> reindexAiRagDocument() throws Exception {
		Map<String, Object> response = new LinkedHashMap<>();
		try {
			Map<String, Object> reindexed = egovAiChatAPIService.reindexAiRagDocuments();
			response.put("resultState", "OK");
			response.put("resultMessage", msg("aic.msg.reindexSuccess"));
			response.putAll(reindexed);
		} catch (Exception e) {
			LOGGER.error("RAG 재인덱싱 실패", e);
			response.put("resultState", "FAIL");
			response.put("resultMessage", msg("aic.msg.reindexFail"));
		}
		return ResponseEntity.ok(response);
	}

	@Operation(summary = "RAG 문서 상태 조회", description = "저장 폴더 파일 목록과 ai-rag 인덱싱 진행 상태를 조회합니다. 앱이 아닌 운영/Swagger용입니다.")
	@GetMapping("/aic/selectAiRagDocumentStatus.do")
	public ResponseEntity<Map<String, Object>> selectAiRagDocumentStatus() throws Exception {
		Map<String, Object> response = new LinkedHashMap<>();
		try {
			Map<String, Object> status = egovAiChatAPIService.selectAiRagDocumentStatus();
			response.put("resultState", "OK");
			response.putAll(status);
		} catch (Exception e) {
			LOGGER.error("RAG 상태 조회 실패", e);
			response.put("resultState", "FAIL");
			response.put("resultMessage", msg("aic.msg.statusFail"));
		}
		return ResponseEntity.ok(response);
	}

	@Operation(summary = "AI 채팅 삭제", description = "저장된 질문-답변을 삭제합니다.")
	@DeleteMapping("/aic/deleteAiChatInfo.do")
	public ResponseEntity<Map<String, Object>> deleteAiChatInfo(AiChatAPIVO vo) throws Exception {
		if (isBlank(vo.getUuid())) {
			return uuidRequiredResponse();
		}

		Map<String, Object> response = new HashMap<>();
		int cnt = egovAiChatAPIService.deleteAiChatInfo(vo);
		if (cnt > 0) {
			response.put("resultState", "OK");
			response.put("resultMessage", "delete success");
		} else {
			response.put("resultState", "FAIL");
			response.put("resultMessage", "delete fail");
		}
		return ResponseEntity.ok(response);
	}
}
