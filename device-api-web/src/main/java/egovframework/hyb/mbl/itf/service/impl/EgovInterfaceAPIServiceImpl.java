package egovframework.hyb.mbl.itf.service.impl;

import java.util.List;

import org.egovframe.rte.fdl.cmmn.EgovAbstractServiceImpl;
import org.springframework.stereotype.Service;

import egovframework.hyb.mbl.itf.service.EgovInterfaceAPIService;
import egovframework.hyb.mbl.itf.service.InterfaceAPIVO;
import jakarta.annotation.Resource;

/**
 * 통합 Interface API ServiceImpl.
 * 비밀번호는 앱에서 1차 해시(SHA-256+userId, Base64)한 값을 그대로 DB에 저장·비교한다.
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
