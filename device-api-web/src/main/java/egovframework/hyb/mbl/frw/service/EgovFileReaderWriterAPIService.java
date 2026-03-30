package egovframework.hyb.mbl.frw.service;

import java.util.List;


/**
 * 통합 FileReaderWriter API Service Interface
 */
public interface EgovFileReaderWriterAPIService {

    int insertFileReaderWriterInfo(FileReaderWriterAPIVO vo) throws Exception;

    int updateFileReaderWriterInfo(FileReaderWriterAPIVO vo) throws Exception;

    int deleteFileReaderWriterInfo(FileReaderWriterAPIVO vo) throws Exception;

    FileReaderWriterAPIVO selectFileReaderWriterInfo(FileReaderWriterAPIVO vo) throws Exception;

    List<?> selectFileReaderWriterInfoList(FileReaderWriterAPIVO searchVO) throws Exception;

    int selectFileReaderWriterInfoListTotCnt(FileReaderWriterAPIVO searchVO) throws Exception;
    
}
