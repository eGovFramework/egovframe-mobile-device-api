package egovframework.hyb.mbl.gps.service;

import java.util.List;

/**
 * 통합 GPS API Service Interface
 */
public interface EgovGPSAPIService {

    int insertGPSInfo(GPSAPIVO vo);

    int deleteGPSInfo(GPSAPIVO vo);

    List<GPSAPIVO> selectGPSInfoList(GPSAPIVO searchVO);

    int selectGPSInfoListTotCnt(GPSAPIVO searchVO);
}
