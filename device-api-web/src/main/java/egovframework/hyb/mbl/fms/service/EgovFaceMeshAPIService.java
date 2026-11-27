package egovframework.hyb.mbl.fms.service;

import java.util.List;

public interface EgovFaceMeshAPIService {

	int insertFaceMeshInfo(FaceMeshAPIVO vo);

	List<FaceMeshAPIVO> selectFaceMeshInfoList(FaceMeshAPIVO searchVO);

	int deleteFaceMeshInfo(FaceMeshAPIVO vo);
}
