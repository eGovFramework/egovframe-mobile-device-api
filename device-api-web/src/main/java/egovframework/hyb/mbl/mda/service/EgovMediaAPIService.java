package egovframework.hyb.mbl.mda.service;

import java.util.List;

/**
 * 통합 Media API Service Interface
 */
public interface EgovMediaAPIService {

    int insertMediaInfo(MediaAPIVO vo);

    int updateMediaInfo(MediaAPIVO vo);

    int deleteMediaInfo(MediaAPIVO vo);

    MediaAPIVO selectMediaInfo(MediaAPIVO vo);

    List<MediaAPIVO> selectMediaInfoList(MediaAPIVO searchVO);

    int selectMediaInfoListTotCnt(MediaAPIVO searchVO);
}
