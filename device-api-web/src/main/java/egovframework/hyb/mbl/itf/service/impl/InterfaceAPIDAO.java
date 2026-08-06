package egovframework.hyb.mbl.itf.service.impl;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.EgovAbstractMapper;
import org.springframework.stereotype.Repository;

import egovframework.hyb.mbl.itf.service.InterfaceAPIVO;

/**
 * 통합 Interface API DAO
 */
@Repository
public class InterfaceAPIDAO extends EgovAbstractMapper {

    public int insertInterfaceInfo(InterfaceAPIVO vo) {
        return insert("interfaceAPIDAO.insertInterfaceInfo", vo);
    }

    public int updateInterfaceInfo(InterfaceAPIVO vo) {
        return update("interfaceAPIDAO.updateInterfaceInfo", vo);
    }

    public int deleteInterfaceInfo(InterfaceAPIVO vo) {
        return delete("interfaceAPIDAO.deleteInterfaceInfo", vo);
    }

    public InterfaceAPIVO selectInterfaceInfo(InterfaceAPIVO vo) {
        return (InterfaceAPIVO) selectOne("interfaceAPIDAO.selectInterfaceInfo", vo);
    }

    public List<InterfaceAPIVO> selectInterfaceInfoList(InterfaceAPIVO searchVO) {
        return selectList("interfaceAPIDAO.selectInterfaceInfoList", searchVO);
    }

    public int selectInterfaceInfoListTotCnt(InterfaceAPIVO searchVO) {
        return selectOne("interfaceAPIDAO.selectInterfaceInfoListTotCnt", searchVO);
    }
}
