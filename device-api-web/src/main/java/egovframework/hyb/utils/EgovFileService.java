package egovframework.hyb.utils;

public interface EgovFileService {
	
	FileVO selectFileDetailInfo(int fileSn);
	int insertFileDetailInfo(FileVO fileVO);
	boolean isFileOwnedByUuid(int fileSn, String uuid);
	boolean isFileRegistered(int fileSn);

}
