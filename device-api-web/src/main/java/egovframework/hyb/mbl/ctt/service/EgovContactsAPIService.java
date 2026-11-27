package egovframework.hyb.mbl.ctt.service;

import java.util.List;

/**
 * 통합 Contacts API Service Interface
 */
public interface EgovContactsAPIService {

    int insertContactsInfo(ContactsAPIVO vo);

    int updateContactsInfo(ContactsAPIVO vo);

    int deleteContactsInfo(ContactsAPIVO vo);

    ContactsAPIVO selectContactsInfo(ContactsAPIVO vo);

    List<ContactsAPIVO> selectContactsInfoList(ContactsAPIVO searchVO);

    int selectContactsInfoListTotCnt(ContactsAPIVO searchVO);
}
