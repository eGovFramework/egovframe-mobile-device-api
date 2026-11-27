package egovframework.hyb.mbl.frw.service.impl;

import java.util.List;

import org.egovframe.rte.fdl.cmmn.EgovAbstractServiceImpl;
import org.springframework.stereotype.Service;

import egovframework.hyb.mbl.frw.service.EgovFileReaderWriterAPIService;
import egovframework.hyb.mbl.frw.service.FileReaderWriterAPIVO;
import jakarta.annotation.Resource;

/**
 * 통합 FileReaderWriter API ServiceImpl
 */
@Service("EgovFileReaderWriterAPIService")
public class EgovFileReaderWriterAPIServiceImpl extends EgovAbstractServiceImpl implements EgovFileReaderWriterAPIService {

    @Resource(name="FileReaderWriterAPIDAO")
    private FileReaderWriterAPIDAO fileReaderWriterAPIDAO;

    public int insertFileReaderWriterInfo(FileReaderWriterAPIVO vo) {
        return fileReaderWriterAPIDAO.insertFileReaderWriterInfo(vo);
    }

    public int updateFileReaderWriterInfo(FileReaderWriterAPIVO vo) {
        return fileReaderWriterAPIDAO.updateFileReaderWriterInfo(vo);
    }

    public int deleteFileReaderWriterInfo(FileReaderWriterAPIVO vo) {
        return fileReaderWriterAPIDAO.deleteFileReaderWriterInfo(vo);
    }

    public FileReaderWriterAPIVO selectFileReaderWriterInfo(FileReaderWriterAPIVO vo) {
        return fileReaderWriterAPIDAO.selectFileReaderWriterInfo(vo);
    }

    public List<FileReaderWriterAPIVO> selectFileReaderWriterInfoList(FileReaderWriterAPIVO searchVO) {
        return fileReaderWriterAPIDAO.selectFileReaderWriterInfoList(searchVO);
    }

    public int selectFileReaderWriterInfoListTotCnt(FileReaderWriterAPIVO searchVO) {
        return fileReaderWriterAPIDAO.selectFileReaderWriterInfoListTotCnt(searchVO);
    }
}
