package egovframework.hyb.mbl.itf.service.impl;

import java.util.List;

import org.egovframe.rte.fdl.cmmn.EgovAbstractServiceImpl;
import org.springframework.stereotype.Service;

import egovframework.hyb.mbl.itf.service.EgovInterfaceAPIService;
import egovframework.hyb.mbl.itf.service.InterfaceAPIVO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

/**
 * 통합 Interface API ServiceImpl.
 * 비밀번호는 앱에서 1차 해시(SHA-256+userId, Base64)한 값을 그대로 DB에 저장·비교한다.
 */
@Service
@RequiredArgsConstructor
@Slf4j
public class EgovInterfaceAPIServiceImpl extends EgovAbstractServiceImpl implements EgovInterfaceAPIService {

    private final InterfaceAPIDAO interfaceAPIDAO;

    public int insertInterfaceInfo(InterfaceAPIVO vo) {
        return interfaceAPIDAO.insertInterfaceInfo(vo);
    }

    public int updateInterfaceInfo(InterfaceAPIVO vo) {
        return interfaceAPIDAO.updateInterfaceInfo(vo);
    }

    public int deleteInterfaceInfo(InterfaceAPIVO vo) {
        return interfaceAPIDAO.deleteInterfaceInfo(vo);
    }

    public InterfaceAPIVO selectInterfaceInfo(InterfaceAPIVO vo) {
        return interfaceAPIDAO.selectInterfaceInfo(vo);
    }

    public List<InterfaceAPIVO> selectInterfaceInfoList(InterfaceAPIVO searchVO) {
        log.debug("userId={}", searchVO.getUserId());
        return interfaceAPIDAO.selectInterfaceInfoList(searchVO);
    }

    public int selectInterfaceInfoListTotCnt(InterfaceAPIVO searchVO) {
        return interfaceAPIDAO.selectInterfaceInfoListTotCnt(searchVO);
    }
}
