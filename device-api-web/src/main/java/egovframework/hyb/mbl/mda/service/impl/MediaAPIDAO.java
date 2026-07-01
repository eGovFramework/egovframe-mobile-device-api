package egovframework.hyb.mbl.mda.service.impl;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.EgovAbstractMapper;
import org.springframework.stereotype.Repository;

import egovframework.hyb.mbl.mda.service.MediaAPIVO;

/**
 * 통합 Media API DAO
 */
@Repository("MediaAPIDAO")
public class MediaAPIDAO extends EgovAbstractMapper {

    public int insertMediaInfo(MediaAPIVO vo) {
        return (Integer) insert("mediaAPIDAO.insertMediaInfo", vo);
    }

    public int updateMediaInfo(MediaAPIVO vo) {
        return (Integer) update("mediaAPIDAO.updateMediaInfo", vo);
    }

    public int deleteMediaInfo(MediaAPIVO vo) {
        return (Integer) delete("mediaAPIDAO.deleteMediaInfo", vo);
    }

    public MediaAPIVO selectMediaInfo(MediaAPIVO vo) {
        return (MediaAPIVO) selectOne("mediaAPIDAO.selectMediaInfo", vo);
    }

    public List<?> selectMediaInfoList(MediaAPIVO searchVO) {
        return selectList("mediaAPIDAO.selectMediaInfoList", searchVO);
    }

    public int selectMediaInfoListTotCnt(MediaAPIVO searchVO) {
        return (Integer) selectOne("mediaAPIDAO.selectMediaInfoListTotCnt", searchVO);
    }
}
