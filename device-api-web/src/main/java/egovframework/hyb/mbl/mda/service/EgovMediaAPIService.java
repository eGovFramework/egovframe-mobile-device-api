package egovframework.hyb.mbl.mda.service;

import java.util.List;

/**
 * 통합 Media API Service Interface
 */
public interface EgovMediaAPIService {

    int insertMediaInfo(MediaAPIVO vo) throws Exception;

    int updateMediaInfo(MediaAPIVO vo) throws Exception;

    int deleteMediaInfo(MediaAPIVO vo) throws Exception;

    MediaAPIVO selectMediaInfo(MediaAPIVO vo) throws Exception;

    List<?> selectMediaInfoList(MediaAPIVO searchVO) throws Exception;

    int selectMediaInfoListTotCnt(MediaAPIVO searchVO) throws Exception;
}
