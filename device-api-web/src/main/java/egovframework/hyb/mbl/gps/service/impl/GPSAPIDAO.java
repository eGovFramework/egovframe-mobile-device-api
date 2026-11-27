package egovframework.hyb.mbl.gps.service.impl;

import org.egovframe.rte.psl.dataaccess.mapper.EgovMapper;

import java.util.List;


import egovframework.hyb.mbl.gps.service.GPSAPIVO;

/**
 * 통합 GPS API DAO
 */
@EgovMapper("GPSAPIDAO")
public interface GPSAPIDAO {

    public int insertGPSInfo(GPSAPIVO vo);


    public int deleteGPSInfo(GPSAPIVO vo);


    public List<GPSAPIVO> selectGPSInfoList(GPSAPIVO searchVO);


    public int selectGPSInfoListTotCnt(GPSAPIVO searchVO);

}
