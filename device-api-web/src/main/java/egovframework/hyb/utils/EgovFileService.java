package egovframework.hyb.utils;

public interface EgovFileService {
	
	FileVO selectFileDetailInfo(int fileSn) throws Exception;
	int insertFileDetailInfo(FileVO fileVO) throws Exception;
	boolean isFileOwnedByUuid(int fileSn, String uuid) throws Exception;
	boolean isFileRegistered(int fileSn) throws Exception;

}
