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

	public int countFileOwnershipByUuid(int fileSn, String uuid) throws Exception {
		java.util.Map<String, Object> params = new java.util.HashMap<>();
		params.put("fileSn", fileSn);
		params.put("uuid", uuid);
		Integer count = selectOne("fileDAO.countFileOwnershipByUuid", params);
		return count != null ? count : 0;
	}

	public int countFileRegistration(int fileSn) {
		Integer count = selectOne("fileDAO.countFileRegistration", fileSn);
		return count != null ? count : 0;
	}

}
