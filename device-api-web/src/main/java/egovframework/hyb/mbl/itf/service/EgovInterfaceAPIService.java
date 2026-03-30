package egovframework.hyb.mbl.itf.service;

import java.util.List;

/**
 * 통합 Interface API Service Interface
 */
public interface EgovInterfaceAPIService {

    int insertInterfaceInfo(InterfaceAPIVO vo) throws Exception;

    int updateInterfaceInfo(InterfaceAPIVO vo) throws Exception;

    int deleteInterfaceInfo(InterfaceAPIVO vo) throws Exception;

    InterfaceAPIVO selectInterfaceInfo(InterfaceAPIVO vo) throws Exception;

    List<?> selectInterfaceInfoList(InterfaceAPIVO searchVO) throws Exception;

    int selectInterfaceInfoListTotCnt(InterfaceAPIVO searchVO) throws Exception;
}
