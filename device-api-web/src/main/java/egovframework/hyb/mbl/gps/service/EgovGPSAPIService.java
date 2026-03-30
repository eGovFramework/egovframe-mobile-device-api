package egovframework.hyb.mbl.gps.service;

import java.util.List;

/**
 * 통합 GPS API Service Interface
 */
public interface EgovGPSAPIService {

    int insertGPSInfo(GPSAPIVO vo) throws Exception;

    int deleteGPSInfo(GPSAPIVO vo) throws Exception;

    List<?> selectGPSInfoList(GPSAPIVO searchVO) throws Exception;

    int selectGPSInfoListTotCnt(GPSAPIVO searchVO) throws Exception;
}
