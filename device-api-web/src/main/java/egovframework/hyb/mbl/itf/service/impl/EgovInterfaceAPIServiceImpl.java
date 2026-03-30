package egovframework.hyb.mbl.itf.service.impl;

import java.util.List;

import org.egovframe.rte.fdl.cmmn.EgovAbstractServiceImpl;
import org.springframework.stereotype.Service;

import egovframework.hyb.mbl.itf.service.EgovInterfaceAPIService;
import egovframework.hyb.mbl.itf.service.InterfaceAPIVO;
import jakarta.annotation.Resource;

/**
 * 통합 Interface API ServiceImpl
 */
@Service("EgovInterfaceAPIService")
public class EgovInterfaceAPIServiceImpl extends EgovAbstractServiceImpl implements EgovInterfaceAPIService {

    @Resource(name="InterfaceAPIDAO")
    private InterfaceAPIDAO interfaceAPIDAO;

    public int insertInterfaceInfo(InterfaceAPIVO vo) throws Exception {
        return (Integer) interfaceAPIDAO.insertInterfaceInfo(vo);
    }

    public int updateInterfaceInfo(InterfaceAPIVO vo) throws Exception {
        return (Integer) interfaceAPIDAO.updateInterfaceInfo(vo);
    }

    public int deleteInterfaceInfo(InterfaceAPIVO vo) throws Exception {
        return (Integer) interfaceAPIDAO.deleteInterfaceInfo(vo);
    }

    public InterfaceAPIVO selectInterfaceInfo(InterfaceAPIVO vo) throws Exception {
        return (InterfaceAPIVO) interfaceAPIDAO.selectInterfaceInfo(vo);
    }

    public List<?> selectInterfaceInfoList(InterfaceAPIVO searchVO) throws Exception {
        return interfaceAPIDAO.selectInterfaceInfoList(searchVO);
    }

    public int selectInterfaceInfoListTotCnt(InterfaceAPIVO searchVO) throws Exception {
        return (Integer) interfaceAPIDAO.selectInterfaceInfoListTotCnt(searchVO);
    }
}
