/**
 * 
 */
package egovframework.hyb.ios.ctt.service.impl;

import java.util.List;

import egovframework.hyb.ios.ctt.service.ContactsiOSAPIVO;
import egovframework.hyb.ios.ctt.service.EgovContactsiOSAPIService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

/**  
 * @Class Name : EgovContactsiOSAPIServiceImpl.java
 * @Description : EgovContactsiOSAPIServiceImpl
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
 */
@Service("egovContactsiOSAPIService")
public class EgovContactsiOSAPIServiceImpl extends EgovAbstractServiceImpl implements
		EgovContactsiOSAPIService {
	
	/** ContactsiOSAPIDAO */
	@Resource(name="contactsiOSAPIDAO")
	private ContactsiOSAPIDAO contactsAPIDAO;

	
	/**
	 * 연락처  정보를 입력한다.
	 * @param vo - 연락처 정보가 담긴 ContactsiOSAPIVO 
	 * @exception Exception
	 */
	public void insertContactsInfo(ContactsiOSAPIVO vo) throws Exception {	
		contactsAPIDAO.insertContactsInfo(vo);
	}
	
	/**
	 * 연락처  정보를 수정한다.
	 * @param vo - 연락처 정보가 담긴 ContactsiOSAPIVO 
	 * @exception Exception
	 */
	public void updateContactsInfo(ContactsiOSAPIVO vo) throws Exception {	
		contactsAPIDAO.updateContactsInfo(vo);
	}

	
	/**
	 * 연락처 정보리스트를 조회한다.
	 * @param vo - 연락처 정보가 담긴 ContactsiOSAPIVO 
	 * @exception Exception
	 */
	public List<?> selectContactsInfoList(ContactsiOSAPIVO vo) throws Exception {
		return contactsAPIDAO.selectFileInfoList(vo);	
	}
	
	/**
	 * 연락처 정보를 조회한다.
	 * @param vo - 연락처 정보가 담긴 ContactsiOSAPIVO 
	 * @exception Exception
	 */
	public ContactsiOSAPIVO selectContactsInfo(ContactsiOSAPIVO vo)throws Exception {
		return contactsAPIDAO.selectContactsInfo(vo);
	}
	
	/**
	 * 연락처 정보를 삭제한다.
	 * @param vo - 연락처 정보가 담긴 ContactsiOSAPIVO 
	 * @exception Exception
	 */
	public int deleteContactsInfo(ContactsiOSAPIVO vo) throws Exception {
		return contactsAPIDAO.deleteContactsInfo(vo);		
	}
	
	
	/**
	 * 백업된 연락처  총 갯수를 조회한다.
	 * @param vo - 연락처 정보가 담긴 ContactsiOSAPIVO 
	 * @exception Exception
	 */
	public int selectContactsCount(ContactsiOSAPIVO vo) throws Exception {
		return contactsAPIDAO.selectContactsTotCnt(vo);		
	}

}
