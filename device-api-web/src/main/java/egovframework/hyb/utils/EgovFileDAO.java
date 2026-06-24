package egovframework.hyb.utils;

import org.egovframe.rte.psl.dataaccess.EgovAbstractMapper;
import org.springframework.stereotype.Repository;

@Repository("FileDAO")
public class EgovFileDAO extends EgovAbstractMapper{
	
	public FileVO selectFileDetailInfo(int fileSn) {
		return selectOne("fileDAO.selectFileDetailInfo",fileSn);
	}
	
	public int insertFileDetailInfo(FileVO fileVO) {
		return (Integer) insert("fileDAO.insertFileDetailInfo", fileVO);
	}

}
