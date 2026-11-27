package egovframework.hyb.mbl.mda.service.impl;

import org.egovframe.rte.psl.dataaccess.mapper.EgovMapper;

import java.util.List;


import egovframework.hyb.mbl.mda.service.MediaAPIVO;

/**
 * 통합 Media API DAO
 */
@EgovMapper("MediaAPIDAO")
public interface MediaAPIDAO {

    public int insertMediaInfo(MediaAPIVO vo);


    public int updateMediaInfo(MediaAPIVO vo);


    public int deleteMediaInfo(MediaAPIVO vo);


    public MediaAPIVO selectMediaInfo(MediaAPIVO vo);


    public List<MediaAPIVO> selectMediaInfoList(MediaAPIVO searchVO);


    public int selectMediaInfoListTotCnt(MediaAPIVO searchVO);


    public MediaAPIVO selectMediaInfoDetail(MediaAPIVO vo);


    public int updateMediaInfoRevivCo(MediaAPIVO vo);


    public Integer selectMediaFileSnBySn(MediaAPIVO vo);

}
