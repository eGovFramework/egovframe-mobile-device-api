/**
 * 
 */
package egovframework.hyb.add.ctt.service;

import java.util.List;

/**  
 * @Class Name : EgovContactsAndroidAPIService.java
 * @Description : EgovContactsAndroidAPIService
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
 *  Copyright (C) by MOPAS All right reserved.
 */
public interface EgovContactsAndroidAPIService {

    /**
     * 연락처 정보를 입력한다.
     * 
     * @param contactVo
     *            - 연락처 정보가 담긴 ContactsAndroidAPIVO
     * @exception Exception
     */
    public void insertContactsInfo(ContactsAndroidAPIVO contactVo)
            throws Exception;

    /**
     * 연락처 정보를 수정한다.
     * 
     * @param contactVo
     *            - 연락처 정보가 담긴 ContactsAndroidAPIVO
     * @exception Exception
     */
    public void updateContactsInfo(ContactsAndroidAPIVO contactVo)
            throws Exception;

    /**
     * 연락처 정보 리스트를 조회한다.
     * 
     * @param contactVo
     *            - 연락처 정보가 담긴 ContactsAndroidAPIVO
     * @exception Exception
     */
    public List<?> selectContactsInfoList(ContactsAndroidAPIVO contactVo)
            throws Exception;

    /**
     * 연락처 정보를 조회한다.
     * 
     * @param contactVo
     *            - 연락처 정보가 담긴 ContactsAndroidAPIVO
     * @exception Exception
     */
    public ContactsAndroidAPIVO selectContactsInfo(
            ContactsAndroidAPIVO contactVo) throws Exception;

    /**
     * 연락처 정보를 삭제한다.
     * 
     * @param contactVo
     *            - 연락처 정보가 담긴 ContactsAndroidAPIVO
     * @exception Exception
     */
    public int deleteContactsInfo(ContactsAndroidAPIVO contactVo)
            throws Exception;

    /**
     * 연락처 디테일 정보를 삭제한다.
     * 
     * @param contactVo
     *            - 연락처 정보가 담긴 ContactsAndroidAPIVO
     * @exception Exception
     */
    public int selectContactsCount(ContactsAndroidAPIVO contactVo)
            throws Exception;
}
