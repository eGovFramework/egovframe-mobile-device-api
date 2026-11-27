package egovframework.hyb.mbl.stm.service;

import java.util.List;

public interface EgovStreamingMediaInfoAPIService {

    int insertStreamingMediaInfo(StreamingMediaAPIVO vo);

    List<StreamingMediaAPIVO> selectStreamingMediaInfoList(StreamingMediaAPIVO searchVO);

    int deleteStreamingMediaInfo(StreamingMediaAPIVO vo);
}
