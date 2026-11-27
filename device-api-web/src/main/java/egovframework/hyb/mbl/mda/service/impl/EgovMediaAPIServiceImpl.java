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

    public int insertMediaInfo(MediaAPIVO vo) {
        return mediaAPIDAO.insertMediaInfo(vo);
    }

    public int updateMediaInfo(MediaAPIVO vo) {
        return mediaAPIDAO.updateMediaInfo(vo);
    }

    public int deleteMediaInfo(MediaAPIVO vo) {
        return mediaAPIDAO.deleteMediaInfo(vo);
    }

    public MediaAPIVO selectMediaInfo(MediaAPIVO vo) {
        return mediaAPIDAO.selectMediaInfo(vo);
    }

    public List<MediaAPIVO> selectMediaInfoList(MediaAPIVO searchVO) {
        return mediaAPIDAO.selectMediaInfoList(searchVO);
    }

    public int selectMediaInfoListTotCnt(MediaAPIVO searchVO) {
        return mediaAPIDAO.selectMediaInfoListTotCnt(searchVO);
    }

    public MediaAPIVO selectMediaInfoDetail(MediaAPIVO vo) {
        return mediaAPIDAO.selectMediaInfoDetail(vo);
    }

    public int updateMediaInfoRevivCo(MediaAPIVO vo) {
        return mediaAPIDAO.updateMediaInfoRevivCo(vo);
    }

    public int selectMediaFileSnBySn(MediaAPIVO vo) {
        Integer fileSn = mediaAPIDAO.selectMediaFileSnBySn(vo);
        return fileSn == null ? 0 : fileSn;
    }
}
