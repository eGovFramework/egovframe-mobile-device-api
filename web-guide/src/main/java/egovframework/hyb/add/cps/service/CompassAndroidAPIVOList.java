package egovframework.hyb.add.cps.service;

import java.util.List;

import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;

/**  
 * @Class Name : CompassAPIVOList.java
 * @Description : CompassAPIVOList Class
 * @Modification Information  
 * @
 * @  수정일                 수정자                 수정내용
 * @ ---------   ---------   -------------------------------
 * @ 2012.07.23    서형주                  최초생성
 * 
 * @author Device API 실행환경팀
 * @since 2012. 07. 30
 * @version 1.0
 * @see
 * 
 */

@XmlRootElement
public class CompassAndroidAPIVOList {
    
    private List<CompassAndroidAPIVO> compassInfoList;

    public List<CompassAndroidAPIVO> getCompassInfoList() {
        return compassInfoList;
    }

    /**
     * @param 파라미터 compassInfoList를 변수 compassInfoList에 설정한다.
     */
    @XmlElement
    public void setCompassInfoList(List<CompassAndroidAPIVO> compassInfoList) {
        this.compassInfoList = compassInfoList;
    }
    
}