package egovframework.hyb.mbl.cps.service.impl;

import org.egovframe.rte.psl.dataaccess.mapper.EgovMapper;

import java.util.List;


import egovframework.hyb.mbl.cps.service.CompassAPIVO;

/**
 * 통합 Compass API DAO
 */
@EgovMapper("CompassAPIDAO")
public interface CompassAPIDAO {

    public int insertCompassInfo(CompassAPIVO vo);


    public int updateCompassInfo(CompassAPIVO vo);


    public int deleteCompassInfo(CompassAPIVO vo);


    public CompassAPIVO selectCompassInfo(CompassAPIVO vo);


    public List<CompassAPIVO> selectCompassInfoList(CompassAPIVO searchVO);


    public int selectCompassInfoListTotCnt(CompassAPIVO searchVO);

}
