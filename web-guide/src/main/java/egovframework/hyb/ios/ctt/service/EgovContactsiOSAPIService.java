/**
 * 
 */
package egovframework.hyb.ios.ctt.service;

import java.util.List;

/**  
 * @Class Name : EgovContactsiOSAPIService.java
 * @Description : EgovContactsiOSAPIService
 * @
 * @  수정일                 수정자                 수정내용
 * @ ---------   ---------   -------------------------------
 * @ 2012. 8. 13.  나신일                   최초생성
 * @ 2012. 8. 23.  이해성                   커스터마이징
 * 
 * @author 디바이스 API 실행환경 개발팀
 * @since 2012. 8. 13
 * @version 1.0
 * @see
 * 
 *  Copyright (C) by MOPAS All right reserved.
 */
public interface EgovContactsiOSAPIService {
	
	/**
	 * 연락처  정보를 입력한다.
	 * @param vo - 연락처 정보가 담긴 ContactsiOSAPIVO 
	 * @exception Exception
	 */	
	public void insertContactsInfo(ContactsiOSAPIVO vo) throws Exception;
	
	/**
	 * 연락처  정보를 수정한다.
	 * @param vo - 연락처 정보가 담긴 ContactsiOSAPIVO 
	 * @exception Exception
	 */
	public void updateContactsInfo(ContactsiOSAPIVO vo) throws Exception;
	
	/**
	 * 연락처 정보 리스트를 조회한다.
	 * @param vo - 연락처 정보가 담긴 ContactsiOSAPIVO 
	 * @exception Exception
	 */
	public List<?> selectContactsInfoList(ContactsiOSAPIVO vo) throws Exception;
	
	/**
	 * 연락처 정보를 조회한다.
	 * @param vo - 연락처 정보가 담긴 ContactsiOSAPIVO 
	 * @exception Exception
	 */
	public ContactsiOSAPIVO selectContactsInfo(ContactsiOSAPIVO vo) throws Exception;
	
	/**
	 * 연락처 정보를 삭제한다.
	 * @param vo - 연락처 정보가 담긴 ContactsiOSAPIVO 
	 * @exception Exception
	 */
	public int deleteContactsInfo(ContactsiOSAPIVO vo) throws Exception;
	
	
	/**
	 * 연락처 디테일 정보를 삭제한다.
	 * @param vo - 연락처 정보가 담긴 ContactsiOSAPIVO 
	 * @exception Exception
	 */
	public int selectContactsCount(ContactsiOSAPIVO vo) throws Exception;
}
