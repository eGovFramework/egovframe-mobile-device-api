package egovframework.hyb.mbl.itf.service;

import java.util.List;

/**
 * 통합 Interface API Service Interface
 */
public interface EgovInterfaceAPIService {

    int insertInterfaceInfo(InterfaceAPIVO vo);

    int updateInterfaceInfo(InterfaceAPIVO vo);

    int deleteInterfaceInfo(InterfaceAPIVO vo);

    InterfaceAPIVO selectInterfaceInfo(InterfaceAPIVO vo);

    List<InterfaceAPIVO> selectInterfaceInfoList(InterfaceAPIVO searchVO);

    int selectInterfaceInfoListTotCnt(InterfaceAPIVO searchVO);
}
