package egovframework.hyb.mbl.frw.service;

import java.util.List;


/**
 * 통합 FileReaderWriter API Service Interface
 */
public interface EgovFileReaderWriterAPIService {

    int insertFileReaderWriterInfo(FileReaderWriterAPIVO vo);

    int updateFileReaderWriterInfo(FileReaderWriterAPIVO vo);

    int deleteFileReaderWriterInfo(FileReaderWriterAPIVO vo);

    FileReaderWriterAPIVO selectFileReaderWriterInfo(FileReaderWriterAPIVO vo);

    List<?> selectFileReaderWriterInfoList(FileReaderWriterAPIVO searchVO);

    int selectFileReaderWriterInfoListTotCnt(FileReaderWriterAPIVO searchVO);
    
}
