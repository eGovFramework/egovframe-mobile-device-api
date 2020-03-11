package egovframework.hyb.add.pki.service;

/**  
 * @Class Name : PKIAndroidAPIVOList.java
 * @Description : PKIAndroidAPIVOList Class
 * @Modification Information  
 * @
 * @  수정일                 수정자                 수정내용
 * @ ---------   ---------   -------------------------------
 * @ 2012.07.23    나신일                  최초생성
 * 
 * @author 모바일 디바이스 API 팀
 * @since 2012. 07. 23
 * @version 1.0
 * @see
 * 
 *  Copyright (C) by MOPAS All right reserved.
 */

import java.util.List;

import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;

@XmlRootElement
public class PKIAndroidAPIVOList {

    private List<PKIAndroidAPIVO> pkiInfoList;

    public List<PKIAndroidAPIVO> getPKIInfoList() {
        return pkiInfoList;
    }

    @XmlElement
    public void setPKIInfoList(List<PKIAndroidAPIVO> pkiInfoList) {
        this.pkiInfoList = pkiInfoList;
    }
}
