package egovframework.hyb.add.ctt.service;

import java.util.List;

import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;

/**  
 * @Class Name : ContactsAndroidAPIVOList.java
 * @Description : ContactsAndroidAPIVOList Class
 * @Modification Information  
 * @
 * @  수정일                 수정자                 수정내용
 * @ ---------   ---------   -------------------------------
 * @ 2012. 8. 13.  나신일                   최초생성
 * 
 * @author 디바이스 API 실행환경 개발팀
 * @since 2012. 8. 13
 * @version 1.0
 * @see
 * 
 */
@XmlRootElement
public class ContactsAndroidAPIVOList {

    private List<ContactsAndroidAPIVO> contactsInfoList;

    public List<ContactsAndroidAPIVO> getContactsInfoList() {
        return contactsInfoList;
    }

    /**
     * @param 파라미터
     *            contactsInfoList 변수 contactsInfoList 설정한다.
     */
    @XmlElement
    public void setContactsInfoList(
            final List<ContactsAndroidAPIVO> contactsInfoList) {
        this.contactsInfoList = contactsInfoList;
    }

}