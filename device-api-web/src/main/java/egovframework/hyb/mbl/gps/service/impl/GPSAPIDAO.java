package egovframework.hyb.mbl.gps.service.impl;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.EgovAbstractMapper;
import org.springframework.stereotype.Repository;

import egovframework.hyb.mbl.gps.service.GPSAPIVO;

/**
 * 통합 GPS API DAO
 */
@Repository
public class GPSAPIDAO extends EgovAbstractMapper {

    public int insertGPSInfo(GPSAPIVO vo) {
        return insert("gpsAPIDAO.insertGPSInfo", vo);
    }

    public int deleteGPSInfo(GPSAPIVO vo) {
        return delete("gpsAPIDAO.deleteGPSInfo", vo);
    }

    public List<GPSAPIVO> selectGPSInfoList(GPSAPIVO searchVO) {
        return selectList("gpsAPIDAO.selectGPSInfoList", searchVO);
    }

    public int selectGPSInfoListTotCnt(GPSAPIVO searchVO) {
        return selectOne("gpsAPIDAO.selectGPSInfoListTotCnt", searchVO);
    }
}
