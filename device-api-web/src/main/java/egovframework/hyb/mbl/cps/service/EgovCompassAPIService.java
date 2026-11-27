package egovframework.hyb.mbl.cps.service;

import java.util.List;

/**
 * 통합 Compass API Service Interface
 */
public interface EgovCompassAPIService {

    int insertCompassInfo(CompassAPIVO vo);

    int updateCompassInfo(CompassAPIVO vo);

    int deleteCompassInfo(CompassAPIVO vo);

    CompassAPIVO selectCompassInfo(CompassAPIVO vo);

    List<CompassAPIVO> selectCompassInfoList(CompassAPIVO searchVO);

    int selectCompassInfoListTotCnt(CompassAPIVO searchVO);
}
