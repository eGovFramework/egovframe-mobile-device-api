package egovframework.hyb.add.gps.service;

import java.util.List;

import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;

/**  
 * @Class Name : GPSAndroidAPIVOList.java
 * @Description : GPSAndroidAPIVOList Class
 * @Modification Information  
 * @
 * @  수정일              수정자                   수정내용
 * @ ---------   ---------   -------------------------------
 * @ 2012.08.27    나신일                   최초생성
 * 
 * @author 디바이스 API 실행환경 개발팀
 * @since 2012. 08.27
 * @version 1.0
 * @see
 * 
 */

@XmlRootElement
public class GPSAndroidAPIVOList {
    private List<GPSAndroidAPIVO> gpsInfoList;

    public List<GPSAndroidAPIVO> getGpsInfoList() {
        return gpsInfoList;
    }

    /**
     * @param 파라미터
     *            gpsInfoList를 변수 gpsInfoList에 설정한다.
     */
    @XmlElement
    public void setGpsInfoList(List<GPSAndroidAPIVO> gpsInfoList) {
        this.gpsInfoList = gpsInfoList;
    }
}
