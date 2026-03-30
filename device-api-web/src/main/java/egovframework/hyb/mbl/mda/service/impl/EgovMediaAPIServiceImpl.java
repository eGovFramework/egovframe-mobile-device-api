package egovframework.hyb.mbl.mda.service.impl;

import java.util.List;

import org.egovframe.rte.fdl.cmmn.EgovAbstractServiceImpl;
import org.springframework.stereotype.Service;

import egovframework.hyb.mbl.mda.service.EgovMediaAPIService;
import egovframework.hyb.mbl.mda.service.MediaAPIVO;
import jakarta.annotation.Resource;

/**
 * 통합 Media API ServiceImpl
 */
@Service("EgovMediaAPIService")
public class EgovMediaAPIServiceImpl extends EgovAbstractServiceImpl implements EgovMediaAPIService {

    @Resource(name="MediaAPIDAO")
    private MediaAPIDAO mediaAPIDAO;

    public int insertMediaInfo(MediaAPIVO vo) throws Exception {
        return (Integer) mediaAPIDAO.insertMediaInfo(vo);
    }

    public int updateMediaInfo(MediaAPIVO vo) throws Exception {
        return (Integer) mediaAPIDAO.updateMediaInfo(vo);
    }

    public int deleteMediaInfo(MediaAPIVO vo) throws Exception {
        return (Integer) mediaAPIDAO.deleteMediaInfo(vo);
    }

    public MediaAPIVO selectMediaInfo(MediaAPIVO vo) throws Exception {
        return (MediaAPIVO) mediaAPIDAO.selectMediaInfo(vo);
    }

    public List<?> selectMediaInfoList(MediaAPIVO searchVO) throws Exception {
        return mediaAPIDAO.selectMediaInfoList(searchVO);
    }

    public int selectMediaInfoListTotCnt(MediaAPIVO searchVO) throws Exception {
        return (Integer) mediaAPIDAO.selectMediaInfoListTotCnt(searchVO);
    }
}
