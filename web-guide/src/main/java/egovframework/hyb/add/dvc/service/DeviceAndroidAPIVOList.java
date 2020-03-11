package egovframework.hyb.add.dvc.service;

import java.util.List;

import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;

/**  
 * @Class Name : DeviceAPIVOList.java
 * @Description : DeviceAPIVOList Class
 * @Modification Information  
 * @
 * @  수정일                수정자                 수정내용
 * @ ---------   ---------   -------------------------------
 * @ 2012.07.23    서형주                 최초생성
 * 
 * @author Device API 실행환경팀
 * @since 2012. 07. 23
 * @version 1.0
 * @see
 * 
 */

@XmlRootElement
public class DeviceAndroidAPIVOList {
    
    private List<DeviceAndroidAPIVO> deviceInfoList;

    public List<DeviceAndroidAPIVO> getDeviceInfoList() {
        return deviceInfoList;
    }

    /**
     * @param 파라미터 deviceInfoList를 변수 deviceInfoList에 설정한다.
     */
    @XmlElement
    public void setDeviceInfoList(List<DeviceAndroidAPIVO> deviceInfoList) {
        this.deviceInfoList = deviceInfoList;
    }
    
}