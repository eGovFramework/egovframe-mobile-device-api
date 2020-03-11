package egovframework.hyb.add.acl.service;

import java.util.List;

import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;

/**  
 * @Class Name : AcceleratorAPIVOList.java
 * @Description : AcceleratorAPIVOList Class
 * @Modification Information  
 * @
 * @  수정일                 수정자                 수정내용
 * @ ---------   ---------   -------------------------------
 * @ 2012.07.23    서형주                  최초생성
 * 
 * @author Device API 실행환경팀
 * @since 2012. 07. 23
 * @version 1.0
 * @see
 * 
 */

@XmlRootElement
public class AcceleratorAndroidAPIVOList {
    
    private List<AcceleratorAndroidAPIVO> acceleratorInfoList;

    public List<AcceleratorAndroidAPIVO> getAcceleratorInfoList() {
        return acceleratorInfoList;
    }

    /**
     * @param 파라미터 acceleratorInfoList를 변수 acceleratorInfoList에 설정한다.
     */
    @XmlElement
    public void setAcceleratorInfoList(List<AcceleratorAndroidAPIVO> acceleratorInfoList) {
        this.acceleratorInfoList = acceleratorInfoList;
    }
    
}