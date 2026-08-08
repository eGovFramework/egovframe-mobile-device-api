package egovframework.hyb.mbl.mda.service.impl;

import java.util.List;

import org.egovframe.rte.fdl.cmmn.EgovAbstractServiceImpl;
import org.springframework.stereotype.Service;

import egovframework.hyb.mbl.mda.service.EgovMediaAPIService;
import egovframework.hyb.mbl.mda.service.MediaAPIVO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

/**
 * 통합 Media API ServiceImpl
 */
@Service
@RequiredArgsConstructor
@Slf4j
public class EgovMediaAPIServiceImpl extends EgovAbstractServiceImpl implements EgovMediaAPIService {

    private final MediaAPIDAO mediaAPIDAO;

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
        log.debug("uuid={}", searchVO.getUuid());
        return mediaAPIDAO.selectMediaInfoList(searchVO);
    }

    public int selectMediaInfoListTotCnt(MediaAPIVO searchVO) {
        return mediaAPIDAO.selectMediaInfoListTotCnt(searchVO);
    }
}
