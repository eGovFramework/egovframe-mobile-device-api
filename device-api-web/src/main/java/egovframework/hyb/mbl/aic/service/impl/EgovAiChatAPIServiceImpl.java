package egovframework.hyb.mbl.aic.service.impl;

import java.time.ZoneId;
import java.time.ZonedDateTime;
import java.time.format.DateTimeFormatter;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import org.egovframe.rte.fdl.cmmn.EgovAbstractServiceImpl;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.fasterxml.jackson.databind.JsonNode;

import egovframework.hyb.mbl.aic.client.EgovAiRagClient;
import egovframework.hyb.mbl.aic.service.AiChatAPIVO;
import egovframework.hyb.mbl.aic.service.EgovAiChatAPIService;
import egovframework.hyb.mbl.aic.service.EgovAiRagDocumentStore;
import jakarta.annotation.Resource;

@Service("EgovAiChatAPIService")
public class EgovAiChatAPIServiceImpl extends EgovAbstractServiceImpl implements EgovAiChatAPIService {

	private static final DateTimeFormatter TIMESTAMP_FORMAT = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
	private static final ZoneId KST = ZoneId.of("Asia/Seoul");

	@Resource(name = "AiChatAPIDAO")
	private AiChatAPIDAO aiChatAPIDAO;

	@Resource
	private EgovAiRagClient egovAiRagClient;

	@Resource
	private EgovAiRagDocumentStore egovAiRagDocumentStore;

	@Override
	public int insertAiChatInfo(AiChatAPIVO vo) {
		normalize(vo);
		return aiChatAPIDAO.insertAiChatInfo(vo);
	}

	@Override
	public int deleteAiChatInfo(AiChatAPIVO vo) {
		return aiChatAPIDAO.deleteAiChatInfo(vo);
	}

	@Override
	public List<AiChatAPIVO> selectAiChatInfoList(AiChatAPIVO searchVO) {
		return aiChatAPIDAO.selectAiChatInfoList(searchVO);
	}

	@Override
	public AiChatAPIVO askAiChatInfo(AiChatAPIVO vo) throws Exception {
		normalize(vo);
		if (vo.getQuestion() == null || vo.getQuestion().isBlank()) {
			throw new IllegalArgumentException("question is required");
		}

		String modelNm = resolveModelNm(vo);
		EgovAiRagClient.AiRagReply reply = egovAiRagClient.ask(
				vo.getQuestion(),
				vo.getChatMode(),
				modelNm,
				vo.getSessionId(),
				vo::setSessionId);
		vo.setAnswer(reply.getAnswer());
		vo.setAnswerTimestamp(nowTimestamp());
		aiChatAPIDAO.insertAiChatInfo(vo);
		return vo;
	}

	@Override
	public AiChatAPIVO askAiChatInfoStream(AiChatAPIVO vo, java.util.function.Consumer<String> tokenConsumer)
			throws Exception {
		normalize(vo);
		if (vo.getQuestion() == null || vo.getQuestion().isBlank()) {
			throw new IllegalArgumentException("question is required");
		}

		String modelNm = resolveModelNm(vo);
		EgovAiRagClient.AiRagReply reply = egovAiRagClient.stream(
				vo.getQuestion(),
				vo.getChatMode(),
				modelNm,
				vo.getSessionId(),
				vo::setSessionId,
				tokenConsumer);
		vo.setAnswer(reply.getAnswer());
		vo.setAnswerTimestamp(nowTimestamp());
		aiChatAPIDAO.insertAiChatInfo(vo);
		return vo;
	}

	private void normalize(AiChatAPIVO vo) {
		if (vo.getUseYn() == null || vo.getUseYn().isBlank()) {
			vo.setUseYn("Y");
		}
		if (vo.getChatMode() == null || vo.getChatMode().isBlank()) {
			vo.setChatMode("rag");
		}
		if (vo.getQuestionTimestamp() == null || vo.getQuestionTimestamp().isBlank()) {
			vo.setQuestionTimestamp(nowTimestamp());
		}
	}

	private String resolveModelNm(AiChatAPIVO vo) {
		String modelNm = egovAiRagClient.resolveModelNm(vo.getModelNm());
		vo.setModelNm(modelNm);
		return modelNm;
	}

	@Override
	public Map<String, Object> uploadAiRagDocuments(List<MultipartFile> files) throws Exception {
		List<Map<String, Object>> saved = egovAiRagDocumentStore.save(files);
		Map<String, Object> response = new LinkedHashMap<>();
		response.put("storedPath", egovAiRagDocumentStore.resolvedStorePath());
		response.put("files", saved);
		response.put("reindexMessage", egovAiRagClient.reindexDocuments());
		return response;
	}

	@Override
	public Map<String, Object> reindexAiRagDocuments() throws Exception {
		Map<String, Object> response = new LinkedHashMap<>();
		response.put("storedPath", egovAiRagDocumentStore.resolvedStorePath());
		response.put("reindexMessage", egovAiRagClient.reindexDocuments());
		return response;
	}

	@Override
	public boolean isAiRagConnected() {
		return egovAiRagClient.isReachable();
	}

	@Override
	public Map<String, Object> selectAiRagDocumentStatus() throws Exception {
		Map<String, Object> response = new LinkedHashMap<>();
		response.put("storedPath", egovAiRagDocumentStore.resolvedStorePath());
		response.put("storedFiles", egovAiRagDocumentStore.listStoredFileNames());
		JsonNode status = egovAiRagClient.documentStatus();
		response.put("processing", status.path("processing").asBoolean(false));
		response.put("processedCount", status.path("processedCount").asInt(0));
		response.put("totalCount", status.path("totalCount").asInt(0));
		response.put("changedCount", status.path("changedCount").asInt(0));
		response.put("hasDocuments", status.path("hasDocuments").asBoolean(false));
		return response;
	}

	private String nowTimestamp() {
		return ZonedDateTime.now(KST).format(TIMESTAMP_FORMAT);
	}
}
