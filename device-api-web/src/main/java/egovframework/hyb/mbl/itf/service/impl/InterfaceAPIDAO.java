package egovframework.hyb.mbl.itf.service.impl;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.EgovAbstractMapper;
import org.springframework.stereotype.Repository;

import egovframework.hyb.mbl.itf.service.InterfaceAPIVO;

/**
 * 통합 Interface API DAO
 */
@Repository("InterfaceAPIDAO")
public class InterfaceAPIDAO extends EgovAbstractMapper {

    public int insertInterfaceInfo(InterfaceAPIVO vo) {
        return (Integer) insert("interfaceAPIDAO.insertInterfaceInfo", vo);
    }

    public int updateInterfaceInfo(InterfaceAPIVO vo) {
        return (Integer) update("interfaceAPIDAO.updateInterfaceInfo", vo);
    }

    public int deleteInterfaceInfo(InterfaceAPIVO vo) {
        return (Integer) delete("interfaceAPIDAO.deleteInterfaceInfo", vo);
    }

    public InterfaceAPIVO selectInterfaceInfo(InterfaceAPIVO vo) {
        return (InterfaceAPIVO) selectOne("interfaceAPIDAO.selectInterfaceInfo", vo);
    }

    public List<?> selectInterfaceInfoList(InterfaceAPIVO searchVO) {
        return selectList("interfaceAPIDAO.selectInterfaceInfoList", searchVO);
    }

    public int selectInterfaceInfoListTotCnt(InterfaceAPIVO searchVO) {
        return (Integer) selectOne("interfaceAPIDAO.selectInterfaceInfoListTotCnt", searchVO);
    }
}
