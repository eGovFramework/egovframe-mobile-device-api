package egovframework.hyb.mbl.ctt.service.impl;

import org.egovframe.rte.psl.dataaccess.mapper.EgovMapper;

import java.util.List;


import egovframework.hyb.mbl.ctt.service.ContactsAPIVO;

@EgovMapper("ContactsAPIDAO")
public interface ContactsAPIDAO {

    public int insertContactsInfo(ContactsAPIVO vo);


    public int deleteContactsInfo(ContactsAPIVO vo);


    public List<ContactsAPIVO> selectContactsInfoList(ContactsAPIVO searchVO);



}
