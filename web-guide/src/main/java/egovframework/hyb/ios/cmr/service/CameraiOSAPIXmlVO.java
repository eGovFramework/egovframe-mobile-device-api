package egovframework.hyb.ios.cmr.service;

import java.util.List;

import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;

/**  
 * @Class Name : CameraIOSAPIListVO.java
 * @Description : CameraIOSAPIListVO Class
 * @Modification Information  
 * @
 * @  수정일			수정자		수정내용
 * @ ---------		---------	-------------------------------
 * @ 2012. 7. 24.		이율경		최초생성
 * @ 2012. 8. 03.  		이해성       커스터마이징
 * 
 * @author 디바이스 API 실행환경 팀
 * @since 2012. 7. 24.
 * @version 1.0
 * @see
 * 
 */
@XmlRootElement
public class CameraiOSAPIXmlVO {

	/** 성공 여부 */
	private String resultState;
	
	/** 삭제 여부 */
	private String deleteCheck;
	
	/** 서버 Context */
	private String serverContext;
	
	/** 다운로드 Context */
	private String downloadContext;
	
	/** 이미지 정보 */
	private CameraiOSAPIVO cameraiOSAPIVO;
	
	/** 목록 정보 */
	private List<CameraiOSAPIFileVO> cameraiOSAPIVOList;
	
	/**
	 * @return downloadContext을 반환한다.
	 */
	public String getDownloadContext() {
		return downloadContext;
	}

	/**
	 * @param 파라미터 downloadContext을 downloadContext에 설정한다.
	 */
	@XmlElement
	public void setDownloadContext(String downloadContext) {
		this.downloadContext = downloadContext;
	}

	/**
	 * @return deleteCheck을 반환한다.
	 */
	public String getDeleteCheck() {
		return deleteCheck;
	}

	/**
	 * @param 파라미터 deleteCheck을 deleteCheck에 설정한다.
	 */
	@XmlElement
	public void setDeleteCheck(String deleteCheck) {
		this.deleteCheck = deleteCheck;
	}

	/**
	 * @return serverIP을 반환한다.
	 */
	public String getServerContext() {
		return serverContext;
	}

	/**
	 * @param 파라미터 serverIP을 serverIP에 설정한다.
	 */
	@XmlElement
	public void setServerContext(String serverContext) {
		this.serverContext = serverContext;
	}
	
	/**
	 * @return cameraIOSAPIVO을 반환한다.
	 */
	public CameraiOSAPIVO getCameraiOSAPIVO() {
		return cameraiOSAPIVO;
	}

	/**
	 * @param 파라미터 cameraIOSAPIVO을 cameraIOSAPIVO에 설정한다.
	 */
	@XmlElement
	public void setCameraiOSAPIVO(CameraiOSAPIVO cameraiOSAPIVO) {
		this.cameraiOSAPIVO = cameraiOSAPIVO;
	}

	/**
	 * @return cameraIOSAPIVOList을 반환한다.
	 */
	public List<CameraiOSAPIFileVO> getCameraiOSAPIVOList() {
		return cameraiOSAPIVOList;
	}

	/**
	 * @param 파라미터 cameraIOSAPIVOList을 cameraIOSAPIVOList에 설정한다.
	 */
	@XmlElement
	public void setCameraiOSAPIVOList(
			List<CameraiOSAPIFileVO> cameraiOSAPIVOList) {
		this.cameraiOSAPIVOList = cameraiOSAPIVOList;
	}

	public void setResultState(String resultState) {
		this.resultState = resultState;
	}

	public String getResultState() {
		return resultState;
	}
	
	
}
