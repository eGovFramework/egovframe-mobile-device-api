package egovframework.hyb.mbl.stm.service.impl;

import org.egovframe.rte.psl.dataaccess.mapper.EgovMapper;

import java.util.List;


import egovframework.hyb.mbl.stm.service.StreamingMediaAPIVO;

@EgovMapper("StreamingMediaInfoAPIDAO")
public interface StreamingMediaInfoAPIDAO {

    public int insertStreamingMediaInfo(StreamingMediaAPIVO vo);


    public List<StreamingMediaAPIVO> selectStreamingMediaInfoList(StreamingMediaAPIVO searchVO);


    public int deleteStreamingMediaInfo(StreamingMediaAPIVO vo);

}
