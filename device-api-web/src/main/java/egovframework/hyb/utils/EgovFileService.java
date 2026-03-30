package egovframework.hyb.utils;

public interface EgovFileService {
	
	FileVO selectFileDetailInfo(int fileSn) throws Exception;
	int insertFileDetailInfo(FileVO fileVO) throws Exception;

}
