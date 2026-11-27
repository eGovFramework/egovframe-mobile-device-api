package egovframework.hyb.mbl.aic.service;

import java.io.Serializable;
import java.util.LinkedHashMap;
import java.util.Map;

import com.fasterxml.jackson.annotation.JsonProperty;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Getter;
import lombok.Setter;

@Schema(description = "AI 채팅 API VO")
@Getter
@Setter
public class AiChatAPIVO implements Serializable {

	private static final long serialVersionUID = 1L;

	@Schema(description = "일련번호")
	private int sn;

	@Schema(description = "기기UUID")
	private String uuid;

	@Schema(description = "사용자질문")
	private String question;

	@Schema(description = "AI답변")
	private String answer;

	@Schema(description = "채팅모드(rag/simple)")
	private String chatMode;

	@Schema(description = "LLM모델명")
	private String modelNm;

	@Schema(description = "AI세션ID")
	private String sessionId;

	@Schema(description = "사용여부")
	private String useYn;

	@Schema(description = "질문시각")
	@JsonProperty("questionTimestamp")
	private String questionTimestamp;

	@Schema(description = "AI답변완료시각")
	@JsonProperty("answerTimestamp")
	private String answerTimestamp;

	public Map<String, Object> toClientMap() {
		Map<String, Object> map = new LinkedHashMap<>();
		map.put("sn", sn);
		map.put("uuid", nvl(uuid));
		map.put("question", nvl(question));
		map.put("answer", nvl(answer));
		map.put("chatMode", nvl(chatMode));
		map.put("modelNm", nvl(modelNm));
		map.put("sessionId", nvl(sessionId));
		map.put("useYn", nvl(useYn));
		map.put("questionTimestamp", nvl(questionTimestamp));
		map.put("answerTimestamp", nvl(answerTimestamp));
		return map;
	}

	private static String nvl(String value) {
		return value == null ? "" : value;
	}
}
