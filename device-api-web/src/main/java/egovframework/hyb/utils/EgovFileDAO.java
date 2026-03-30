package egovframework.hyb.utils;

import org.egovframe.rte.psl.dataaccess.EgovAbstractMapper;
import org.springframework.stereotype.Repository;

@Repository("FileDAO")
public class EgovFileDAO extends EgovAbstractMapper{
	
	public FileVO selectFileDetailInfo(int fileSn) throws Exception{
		return selectOne("fileDAO.selectFileDetailInfo",fileSn);
	}
	
	public int insertFileDetailInfo(FileVO fileVO) throws Exception{
		return (Integer) insert("fileDAO.insertFileDetailInfo", fileVO);
	}

}
