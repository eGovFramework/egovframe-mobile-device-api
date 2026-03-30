package egovframework.hyb.mbl.gps.service.impl;

import java.util.List;

import org.egovframe.rte.fdl.cmmn.EgovAbstractServiceImpl;
import org.springframework.stereotype.Service;

import egovframework.hyb.mbl.gps.service.EgovGPSAPIService;
import egovframework.hyb.mbl.gps.service.GPSAPIVO;
import jakarta.annotation.Resource;

/**
 * 통합 GPS API ServiceImpl
 */
@Service("EgovGPSAPIService")
public class EgovGPSAPIServiceImpl extends EgovAbstractServiceImpl implements EgovGPSAPIService {

    @Resource(name="GPSAPIDAO")
    private GPSAPIDAO gpsAPIDAO;

    public int insertGPSInfo(GPSAPIVO vo) throws Exception {
        return (Integer) gpsAPIDAO.insertGPSInfo(vo);
    }

    public int deleteGPSInfo(GPSAPIVO vo) throws Exception {
        return (Integer) gpsAPIDAO.deleteGPSInfo(vo);
    }

    public List<?> selectGPSInfoList(GPSAPIVO searchVO) throws Exception {
        return gpsAPIDAO.selectGPSInfoList(searchVO);
    }

    public int selectGPSInfoListTotCnt(GPSAPIVO searchVO) throws Exception {
        return (Integer) gpsAPIDAO.selectGPSInfoListTotCnt(searchVO);
    }
}
