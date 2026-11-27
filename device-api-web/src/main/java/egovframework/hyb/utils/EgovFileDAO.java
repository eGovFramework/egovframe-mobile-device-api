package egovframework.hyb.utils;

import org.apache.ibatis.annotations.Param;
import org.egovframe.rte.psl.dataaccess.mapper.EgovMapper;

@EgovMapper("FileDAO")
public interface EgovFileDAO {

	FileVO selectFileDetailInfo(@Param("fileSn") int fileSn);

	int insertFileDetailInfo(FileVO fileVO);

	Integer countFileOwnershipByUuid(@Param("fileSn") int fileSn, @Param("uuid") String uuid);

	Integer countFileRegistration(@Param("fileSn") int fileSn);

}
