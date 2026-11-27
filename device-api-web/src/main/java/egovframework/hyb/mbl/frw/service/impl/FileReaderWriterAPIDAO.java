package egovframework.hyb.mbl.frw.service.impl;

import org.egovframe.rte.psl.dataaccess.mapper.EgovMapper;

import java.util.List;


import egovframework.hyb.mbl.frw.service.FileReaderWriterAPIVO;

/**
 * 통합 FileReaderWriter API DAO
 */
@EgovMapper("FileReaderWriterAPIDAO")
public interface FileReaderWriterAPIDAO {

    public int insertFileReaderWriterInfo(FileReaderWriterAPIVO vo);


    public int updateFileReaderWriterInfo(FileReaderWriterAPIVO vo);


    public int deleteFileReaderWriterInfo(FileReaderWriterAPIVO vo);


    public FileReaderWriterAPIVO selectFileReaderWriterInfo(FileReaderWriterAPIVO vo);


    public List<FileReaderWriterAPIVO> selectFileReaderWriterInfoList(FileReaderWriterAPIVO searchVO);


    public int selectFileReaderWriterInfoListTotCnt(FileReaderWriterAPIVO searchVO);

    
}
