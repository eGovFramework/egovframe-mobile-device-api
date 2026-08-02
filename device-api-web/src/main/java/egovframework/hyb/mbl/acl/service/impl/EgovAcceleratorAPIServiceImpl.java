package egovframework.hyb.mbl.acl.service.impl;

import java.util.List;

import org.egovframe.rte.fdl.cmmn.EgovAbstractServiceImpl;
import org.springframework.stereotype.Service;

import egovframework.hyb.mbl.acl.service.AcceleratorAPIVO;
import egovframework.hyb.mbl.acl.service.EgovAcceleratorAPIService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

/**
 * 통합 Accelerator API ServiceImpl
 */
@Service
@RequiredArgsConstructor
@Slf4j
public class EgovAcceleratorAPIServiceImpl extends EgovAbstractServiceImpl implements EgovAcceleratorAPIService {

    private final AcceleratorAPIDAO acceleratorAPIDAO;

    public List<AcceleratorAPIVO> selectAcceleratorInfoList(AcceleratorAPIVO searchVO) {
        log.debug("uuid={}", searchVO.getUuid());
        return acceleratorAPIDAO.selectAcceleratorInfoList(searchVO);
    }
    
    public int insertAcceleratorInfo(AcceleratorAPIVO vo) {
        return acceleratorAPIDAO.insertAcceleratorInfo(vo);
    }

    public int deleteAcceleratorInfo(AcceleratorAPIVO vo) {
        return acceleratorAPIDAO.deleteAcceleratorInfo(vo);
    }

}
