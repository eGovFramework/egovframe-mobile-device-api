package egovframework.hyb.mbl.acl.service.impl;

import java.util.List;

import org.egovframe.rte.fdl.cmmn.EgovAbstractServiceImpl;
import org.springframework.stereotype.Service;

import egovframework.hyb.mbl.acl.service.AcceleratorAPIVO;
import egovframework.hyb.mbl.acl.service.EgovAcceleratorAPIService;
import jakarta.annotation.Resource;

/**
 * 통합 Accelerator API ServiceImpl
 */
@Service("EgovAcceleratorAPIService")
public class EgovAcceleratorAPIServiceImpl extends EgovAbstractServiceImpl implements EgovAcceleratorAPIService {

    @Resource(name="AcceleratorAPIDAO")
    private AcceleratorAPIDAO acceleratorAPIDAO;

    public List<?> selectAcceleratorInfoList(AcceleratorAPIVO searchVO) throws Exception {
        return acceleratorAPIDAO.selectAcceleratorInfoList(searchVO);
    }
    
    public int insertAcceleratorInfo(AcceleratorAPIVO vo) throws Exception {
        return (Integer) acceleratorAPIDAO.insertAcceleratorInfo(vo);
    }

    public int deleteAcceleratorInfo(AcceleratorAPIVO vo) throws Exception {
        return (Integer) acceleratorAPIDAO.deleteAcceleratorInfo(vo);
    }

}
