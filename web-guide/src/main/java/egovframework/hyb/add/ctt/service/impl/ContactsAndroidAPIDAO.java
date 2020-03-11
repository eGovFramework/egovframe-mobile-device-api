/**
 * 
 */
package egovframework.hyb.add.ctt.service.impl;

import java.util.List;

import egovframework.com.cmm.mapper.EgovComAbstractDAO;
import egovframework.hyb.add.ctt.service.ContactsAndroidAPIVO;

import org.springframework.stereotype.Repository;

/**  
 * @Class Name : ContactsAndroidAPIDAO.java
 * @Description : ContactsAndroidAPIDAO
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
@Repository("contactsAndroidAPIDAO")
public class ContactsAndroidAPIDAO extends EgovComAbstractDAO {

    /**
     * 연락처 정보를 입력한다.
     * 
     * @param vo
     *            - 연락처 정보가 담긴 ContactsAndroidAPIVO
     * @exception Exception
     */
    public void insertContactsInfo(ContactsAndroidAPIVO vo) throws Exception {
        insert("contactsAndroidAPIDAO.insertContactInfo", vo);
    }

    /**
     * 연락처 정보를 업데이트 한다.
     * 
     * @param vo
     *            - 연락처 정보가 담긴 ContactsAndroidAPIVO
     * @exception Exception
     */
    public void updateContactsInfo(ContactsAndroidAPIVO vo) throws Exception {
        insert("contactsAndroidAPIDAO.updateContactInfo", vo);
    }

    /**
     * 연락처 정보리스트를 조회한다.
     * 
     * @param vo
     *            - 연락처 정보가 담긴 ContactsAndroidAPIVO
     * @exception Exception
     */
    public List<?> selectFileInfoList(ContactsAndroidAPIVO vo) throws Exception {
        return selectList("contactsAndroidAPIDAO.selectContactInfoList", vo);
    }

    /**
     * 연락처 정보를 조회한다.
     * 
     * @param vo
     *            - 연락처 정보가 담긴 ContactsAndroidAPIVO
     * @exception Exception
     */
    public ContactsAndroidAPIVO selectContactsInfo(ContactsAndroidAPIVO vo)
            throws Exception {
        return (ContactsAndroidAPIVO) selectOne(
                "contactsAndroidAPIDAO.selectContactInfo", vo);
    }

    /**
     * 연락처 정보를 삭제한다.
     * 
     * @param vo
     *            - 연락처 정보가 담긴 ContactsAndroidAPIVO
     * @exception Exception
     */
    public int deleteContactsInfo(ContactsAndroidAPIVO vo) throws Exception {
        return delete("contactsAndroidAPIDAO.deleteContactInfo", vo);
    }

    /**
     * 연락처 정보를 삭제한다.
     * 
     * @param vo
     *            - 연락처 정보가 담긴 ContactsAndroidAPIVO
     * @exception Exception
     */
    public int selectContactsTotCnt(ContactsAndroidAPIVO vo) throws Exception {
        return (Integer) selectOne(
                "contactsAndroidAPIDAO.selectContactInfoListTotCnt", vo);
    }
}
