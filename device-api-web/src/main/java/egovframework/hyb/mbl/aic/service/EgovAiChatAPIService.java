package egovframework.hyb.mbl.aic.service;

import java.util.List;
import java.util.Map;

import org.springframework.web.multipart.MultipartFile;

public interface EgovAiChatAPIService {

	int insertAiChatInfo(AiChatAPIVO vo);

	int deleteAiChatInfo(AiChatAPIVO vo);

	List<AiChatAPIVO> selectAiChatInfoList(AiChatAPIVO searchVO);

	AiChatAPIVO askAiChatInfo(AiChatAPIVO vo) throws Exception;

	AiChatAPIVO askAiChatInfoStream(AiChatAPIVO vo, java.util.function.Consumer<String> tokenConsumer)
			throws Exception;

	Map<String, Object> uploadAiRagDocuments(List<MultipartFile> files) throws Exception;

	Map<String, Object> reindexAiRagDocuments() throws Exception;

	Map<String, Object> selectAiRagDocumentStatus() throws Exception;

	boolean isAiRagConnected();
}
