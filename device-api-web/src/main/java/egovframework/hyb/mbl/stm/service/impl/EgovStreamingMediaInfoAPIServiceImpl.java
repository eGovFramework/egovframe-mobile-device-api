package egovframework.hyb.mbl.stm.service.impl;

import java.util.List;

import org.egovframe.rte.fdl.cmmn.EgovAbstractServiceImpl;
import org.springframework.stereotype.Service;

import egovframework.hyb.mbl.stm.service.EgovStreamingMediaInfoAPIService;
import egovframework.hyb.mbl.stm.service.StreamingMediaAPIVO;
import jakarta.annotation.Resource;

@Service("EgovStreamingMediaInfoAPIService")
public class EgovStreamingMediaInfoAPIServiceImpl extends EgovAbstractServiceImpl
        implements EgovStreamingMediaInfoAPIService {

    @Resource(name = "StreamingMediaInfoAPIDAO")
    private StreamingMediaInfoAPIDAO streamingMediaInfoAPIDAO;

    public int insertStreamingMediaInfo(StreamingMediaAPIVO vo) {
        return streamingMediaInfoAPIDAO.insertStreamingMediaInfo(vo);
    }

    public List<StreamingMediaAPIVO> selectStreamingMediaInfoList(StreamingMediaAPIVO searchVO) {
        return streamingMediaInfoAPIDAO.selectStreamingMediaInfoList(searchVO);
    }

    public int deleteStreamingMediaInfo(StreamingMediaAPIVO vo) {
        return streamingMediaInfoAPIDAO.deleteStreamingMediaInfo(vo);
    }
}
