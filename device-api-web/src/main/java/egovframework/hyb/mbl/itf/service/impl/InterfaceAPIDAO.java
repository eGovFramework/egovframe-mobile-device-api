package egovframework.hyb.mbl.itf.service.impl;

import org.egovframe.rte.psl.dataaccess.mapper.EgovMapper;

import java.util.List;


import egovframework.hyb.mbl.itf.service.InterfaceAPIVO;

/**
 * 통합 Interface API DAO
 */
@EgovMapper("InterfaceAPIDAO")
public interface InterfaceAPIDAO {

    public int insertInterfaceInfo(InterfaceAPIVO vo);


    public int updateInterfaceInfo(InterfaceAPIVO vo);


    public int deleteInterfaceInfo(InterfaceAPIVO vo);


    public InterfaceAPIVO selectInterfaceInfo(InterfaceAPIVO vo);


    public List<InterfaceAPIVO> selectInterfaceInfoList(InterfaceAPIVO searchVO);


    public int selectInterfaceInfoListTotCnt(InterfaceAPIVO searchVO);

}
