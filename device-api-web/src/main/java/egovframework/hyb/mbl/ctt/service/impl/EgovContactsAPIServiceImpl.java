package egovframework.hyb.mbl.ctt.service.impl;

import java.util.List;

import org.egovframe.rte.fdl.cmmn.EgovAbstractServiceImpl;
import org.springframework.stereotype.Service;

import egovframework.hyb.mbl.ctt.service.ContactsAPIVO;
import egovframework.hyb.mbl.ctt.service.EgovContactsAPIService;
import jakarta.annotation.Resource;

@Service("EgovContactsAPIService")
public class EgovContactsAPIServiceImpl extends EgovAbstractServiceImpl implements EgovContactsAPIService {

    @Resource(name = "ContactsAPIDAO")
    private ContactsAPIDAO contactsAPIDAO;

    public int insertContactsInfo(ContactsAPIVO vo) {
        return contactsAPIDAO.insertContactsInfo(vo);
    }

    public int updateContactsInfo(ContactsAPIVO vo) {
        return 0;
    }

    public int deleteContactsInfo(ContactsAPIVO vo) {
        return contactsAPIDAO.deleteContactsInfo(vo);
    }

    public ContactsAPIVO selectContactsInfo(ContactsAPIVO vo) {
        return null;
    }

    public List<ContactsAPIVO> selectContactsInfoList(ContactsAPIVO searchVO) {
        return contactsAPIDAO.selectContactsInfoList(searchVO);
    }

    public int selectContactsInfoListTotCnt(ContactsAPIVO searchVO) {
        return contactsAPIDAO.selectContactsInfoList(searchVO).size();
    }
}
