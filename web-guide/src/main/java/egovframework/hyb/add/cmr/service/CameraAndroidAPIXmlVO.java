package egovframework.hyb.add.cmr.service;

import java.util.List;

import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;

/**  
 * @Class Name : CameraAndroidAPIListVO.java
 * @Description : CameraAndroidAPIListVO Class
 * @Modification Information  
 * @
 * @  수정일            수정자        수정내용
 * @ ---------        ---------    -------------------------------
 * @ 2012. 7. 24.        이율경        최초생성
 * 
 * @author 디바이스 API 실행환경 팀
 * @since 2012. 7. 24.
 * @version 1.0
 * @see
 * 
 */
@XmlRootElement
public class CameraAndroidAPIXmlVO {

    /** 삭제 여부 */
    private String deleteCheck;
    
    /** 서버 Context */
    private String serverContext;
    
    /** 다운로드 Context */
    private String downloadContext;
    
    /** 이미지 정보 */
    private CameraAndroidAPIVO cameraAndroidAPIVO;
    
    /** 목록 정보 */
    private List<CameraAndroidAPIFileVO> cameraAndroidAPIVOList;
    
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
     * @return cameraAndroidAPIVO을 반환한다.
     */
    public CameraAndroidAPIVO getCameraAndroidAPIVO() {
        return cameraAndroidAPIVO;
    }

    /**
     * @param 파라미터 cameraAndroidAPIVO을 cameraAndroidAPIVO에 설정한다.
     */
    @XmlElement
    public void setCameraAndroidAPIVO(CameraAndroidAPIVO cameraAndroidAPIVO) {
        this.cameraAndroidAPIVO = cameraAndroidAPIVO;
    }

    /**
     * @return cameraAndroidAPIVOList을 반환한다.
     */
    public List<CameraAndroidAPIFileVO> getCameraAndroidAPIVOList() {
        return cameraAndroidAPIVOList;
    }

    /**
     * @param 파라미터 cameraAndroidAPIVOList을 cameraAndroidAPIVOList에 설정한다.
     */
    @XmlElement
    public void setCameraAndroidAPIVOList(
            List<CameraAndroidAPIFileVO> cameraAndroidAPIVOList) {
        this.cameraAndroidAPIVOList = cameraAndroidAPIVOList;
    }
    
    
}
