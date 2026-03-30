package egovframework.hyb.mbl.frw.service.impl;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.EgovAbstractMapper;
import org.springframework.stereotype.Repository;

import egovframework.hyb.mbl.frw.service.FileReaderWriterAPIVO;

/**
 * 통합 FileReaderWriter API DAO
 */
@Repository("FileReaderWriterAPIDAO")
public class FileReaderWriterAPIDAO extends EgovAbstractMapper {

    public int insertFileReaderWriterInfo(FileReaderWriterAPIVO vo) throws Exception {
        return (Integer) insert("fileReaderWriterAPIDAO.insertFileReaderWriterInfo", vo);
    }

    public int updateFileReaderWriterInfo(FileReaderWriterAPIVO vo) throws Exception {
        return (Integer) update("fileReaderWriterAPIDAO.updateFileReaderWriterInfo", vo);
    }

    public int deleteFileReaderWriterInfo(FileReaderWriterAPIVO vo) throws Exception {
        return (Integer) delete("fileReaderWriterAPIDAO.deleteFileReaderWriterInfo", vo);
    }

    public FileReaderWriterAPIVO selectFileReaderWriterInfo(FileReaderWriterAPIVO vo) throws Exception {
        return (FileReaderWriterAPIVO) selectOne("fileReaderWriterAPIDAO.selectFileReaderWriterInfo", vo);
    }

    public List<?> selectFileReaderWriterInfoList(FileReaderWriterAPIVO searchVO) throws Exception {
        return selectList("fileReaderWriterAPIDAO.selectFileReaderWriterInfoList", searchVO);
    }

    public int selectFileReaderWriterInfoListTotCnt(FileReaderWriterAPIVO searchVO) throws Exception {
        return (Integer) selectOne("fileReaderWriterAPIDAO.selectFileReaderWriterInfoListTotCnt", searchVO);
    }
    
}
