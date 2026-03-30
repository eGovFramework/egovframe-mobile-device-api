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

    public int insertFileReaderWriterInfo(FileReaderWriterAPIVO vo) throws Exception {
        return (Integer) fileReaderWriterAPIDAO.insertFileReaderWriterInfo(vo);
    }

    public int updateFileReaderWriterInfo(FileReaderWriterAPIVO vo) throws Exception {
        return (Integer) fileReaderWriterAPIDAO.updateFileReaderWriterInfo(vo);
    }

    public int deleteFileReaderWriterInfo(FileReaderWriterAPIVO vo) throws Exception {
        return (Integer) fileReaderWriterAPIDAO.deleteFileReaderWriterInfo(vo);
    }

    public FileReaderWriterAPIVO selectFileReaderWriterInfo(FileReaderWriterAPIVO vo) throws Exception {
        return (FileReaderWriterAPIVO) fileReaderWriterAPIDAO.selectFileReaderWriterInfo(vo);
    }

    public List<?> selectFileReaderWriterInfoList(FileReaderWriterAPIVO searchVO) throws Exception {
        return fileReaderWriterAPIDAO.selectFileReaderWriterInfoList(searchVO);
    }

    public int selectFileReaderWriterInfoListTotCnt(FileReaderWriterAPIVO searchVO) throws Exception {
        return (Integer) fileReaderWriterAPIDAO.selectFileReaderWriterInfoListTotCnt(searchVO);
    }
}
