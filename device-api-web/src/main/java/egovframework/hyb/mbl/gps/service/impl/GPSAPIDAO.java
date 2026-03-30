package egovframework.hyb.mbl.gps.service.impl;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.EgovAbstractMapper;
import org.springframework.stereotype.Repository;

import egovframework.hyb.mbl.gps.service.GPSAPIVO;

/**
 * 통합 GPS API DAO
 */
@Repository("GPSAPIDAO")
public class GPSAPIDAO extends EgovAbstractMapper {

    public int insertGPSInfo(GPSAPIVO vo) throws Exception {
        return (Integer) insert("gpsAPIDAO.insertGPSInfo", vo);
    }

    public int deleteGPSInfo(GPSAPIVO vo) throws Exception {
        return (Integer) delete("gpsAPIDAO.deleteGPSInfo", vo);
    }

    public List<?> selectGPSInfoList(GPSAPIVO searchVO) throws Exception {
        return selectList("gpsAPIDAO.selectGPSInfoList", searchVO);
    }

    public int selectGPSInfoListTotCnt(GPSAPIVO searchVO) throws Exception {
        return (Integer) selectOne("gpsAPIDAO.selectGPSInfoListTotCnt", searchVO);
    }
}
