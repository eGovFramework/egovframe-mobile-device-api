/**
 * 
 */
package egovframework.hyb.add.ctt.service.impl;

import java.util.List;

import egovframework.hyb.add.ctt.service.ContactsAndroidAPIVO;
import egovframework.hyb.add.ctt.service.EgovContactsAndroidAPIService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

/**  
 * @Class Name : EgovContactsAndroidAPIServiceImpl.java
 * @Description : EgovContactsAndroidAPIServiceImpl
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
@Service("egovContactsAndroidAPIService")
public class EgovContactsAndroidAPIServiceImpl extends EgovAbstractServiceImpl implements
        EgovContactsAndroidAPIService {

    /** ContactsAndroidAPIDAO */
    @Resource(name = "contactsAndroidAPIDAO")
    private transient ContactsAndroidAPIDAO contactsAPIDAO;

    /**
     * 연락처 정보를 입력한다.
     * 
     * @param contactVo
     *            - 연락처 정보가 담긴 ContactsAndroidAPIVO
     * @exception Exception
     */
    public void insertContactsInfo(final ContactsAndroidAPIVO contactVo)
            throws Exception {
        contactsAPIDAO.insertContactsInfo(contactVo);
    }

    /**
     * 연락처 정보를 수정한다.
     * 
     * @param contactVo
     *            - 연락처 정보가 담긴 ContactsAndroidAPIVO
     * @exception Exception
     */
    public void updateContactsInfo(final ContactsAndroidAPIVO contactVo)
            throws Exception {
        contactsAPIDAO.updateContactsInfo(contactVo);
    }

    /**
     * 연락처 정보리스트를 조회한다.
     * 
     * @param contactVo
     *            - 연락처 정보가 담긴 ContactsAndroidAPIVO
     * @exception Exception
     */
    public List<?> selectContactsInfoList(final ContactsAndroidAPIVO contactVo)
            throws Exception {
        return contactsAPIDAO.selectFileInfoList(contactVo);
    }

    /**
     * 연락처 정보를 조회한다.
     * 
     * @param contactVo
     *            - 연락처 정보가 담긴 ContactsAndroidAPIVO
     * @exception Exception
     */
    public ContactsAndroidAPIVO selectContactsInfo(
            final ContactsAndroidAPIVO contactVo) throws Exception {
		String name = contactVo.getName();
    	String telNoCompare = contactVo.getTelNo();
    	if (!"".equals(name) || name != null) {
    		name = name.trim();
    		contactVo.setName(name);
    	}
    	if (!"".equals(telNoCompare) || telNoCompare != null) {
			telNoCompare = telNoCompare.replaceAll("-", "");
			contactVo.setTelNoCompare(telNoCompare);
		}
        return contactsAPIDAO.selectContactsInfo(contactVo);
    }

    /**
     * 연락처 정보를 삭제한다.
     * 
     * @param contactVo
     *            - 연락처 정보가 담긴 ContactsAndroidAPIVO
     * @exception Exception
     */
    public int deleteContactsInfo(final ContactsAndroidAPIVO contactVo)
            throws Exception {
        return contactsAPIDAO.deleteContactsInfo(contactVo);
    }

    /**
     * 백업된 연락처 총 갯수를 조회한다.
     * 
     * @param contactVo
     *            - 연락처 정보가 담긴 ContactsAndroidAPIVO
     * @exception Exception
     */
    public int selectContactsCount(final ContactsAndroidAPIVO contactVo)
            throws Exception {
        return contactsAPIDAO.selectContactsTotCnt(contactVo);
    }

}
