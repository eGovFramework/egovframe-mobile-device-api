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

    public int insertInterfaceInfo(InterfaceAPIVO vo) throws Exception {
        return (Integer) insert("interfaceAPIDAO.insertInterfaceInfo", vo);
    }

    public int updateInterfaceInfo(InterfaceAPIVO vo) throws Exception {
        return (Integer) update("interfaceAPIDAO.updateInterfaceInfo", vo);
    }

    public int deleteInterfaceInfo(InterfaceAPIVO vo) throws Exception {
        return (Integer) delete("interfaceAPIDAO.deleteInterfaceInfo", vo);
    }

    public InterfaceAPIVO selectInterfaceInfo(InterfaceAPIVO vo) throws Exception {
        return (InterfaceAPIVO) selectOne("interfaceAPIDAO.selectInterfaceInfo", vo);
    }

    public List<?> selectInterfaceInfoList(InterfaceAPIVO searchVO) throws Exception {
        return selectList("interfaceAPIDAO.selectInterfaceInfoList", searchVO);
    }

    public int selectInterfaceInfoListTotCnt(InterfaceAPIVO searchVO) throws Exception {
        return (Integer) selectOne("interfaceAPIDAO.selectInterfaceInfoListTotCnt", searchVO);
    }
}
