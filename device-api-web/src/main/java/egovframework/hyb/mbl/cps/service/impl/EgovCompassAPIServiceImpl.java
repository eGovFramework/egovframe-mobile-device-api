package egovframework.hyb.mbl.cps.service.impl;

import java.util.List;

import org.egovframe.rte.fdl.cmmn.EgovAbstractServiceImpl;
import org.springframework.stereotype.Service;

import egovframework.hyb.mbl.cps.service.CompassAPIVO;
import egovframework.hyb.mbl.cps.service.EgovCompassAPIService;
import jakarta.annotation.Resource;

/**
 * 통합 Compass API ServiceImpl
 */
@Service("EgovCompassAPIService")
public class EgovCompassAPIServiceImpl extends EgovAbstractServiceImpl implements EgovCompassAPIService {

    @Resource(name="CompassAPIDAO")
    private CompassAPIDAO compassAPIDAO;

    public int insertCompassInfo(CompassAPIVO vo) {
        return compassAPIDAO.insertCompassInfo(vo);
    }

    public int updateCompassInfo(CompassAPIVO vo) {
        return compassAPIDAO.updateCompassInfo(vo);
    }

    public int deleteCompassInfo(CompassAPIVO vo) {
        return compassAPIDAO.deleteCompassInfo(vo);
    }

    public CompassAPIVO selectCompassInfo(CompassAPIVO vo) {
        return compassAPIDAO.selectCompassInfo(vo);
    }

    public List<CompassAPIVO> selectCompassInfoList(CompassAPIVO searchVO) {
        return compassAPIDAO.selectCompassInfoList(searchVO);
    }

    public int selectCompassInfoListTotCnt(CompassAPIVO searchVO) {
        return compassAPIDAO.selectCompassInfoListTotCnt(searchVO);
    }
}
