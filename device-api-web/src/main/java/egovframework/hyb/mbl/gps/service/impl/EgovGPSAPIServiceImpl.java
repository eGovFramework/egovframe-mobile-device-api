package egovframework.hyb.mbl.gps.service.impl;

import java.util.List;

import org.egovframe.rte.fdl.cmmn.EgovAbstractServiceImpl;
import org.springframework.stereotype.Service;

import egovframework.hyb.mbl.gps.service.EgovGPSAPIService;
import egovframework.hyb.mbl.gps.service.GPSAPIVO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

/**
 * 통합 GPS API ServiceImpl
 */
@Service
@RequiredArgsConstructor
@Slf4j
public class EgovGPSAPIServiceImpl extends EgovAbstractServiceImpl implements EgovGPSAPIService {

    private final GPSAPIDAO gpsAPIDAO;

    public int insertGPSInfo(GPSAPIVO vo) {
        return gpsAPIDAO.insertGPSInfo(vo);
    }

    public int deleteGPSInfo(GPSAPIVO vo) {
        return gpsAPIDAO.deleteGPSInfo(vo);
    }

    public List<GPSAPIVO> selectGPSInfoList(GPSAPIVO searchVO) {
        log.debug("uuid={}", searchVO.getUuid());
        return gpsAPIDAO.selectGPSInfoList(searchVO);
    }

    public int selectGPSInfoListTotCnt(GPSAPIVO searchVO) {
        return gpsAPIDAO.selectGPSInfoListTotCnt(searchVO);
    }
}
