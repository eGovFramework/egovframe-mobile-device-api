package egovframework.hyb.mbl.fms.service.impl;

import java.util.List;

import org.egovframe.rte.fdl.cmmn.EgovAbstractServiceImpl;
import org.springframework.stereotype.Service;

import egovframework.hyb.mbl.fms.service.EgovFaceMeshAPIService;
import egovframework.hyb.mbl.fms.service.FaceMeshAPIVO;
import jakarta.annotation.Resource;

@Service("EgovFaceMeshAPIService")
public class EgovFaceMeshAPIServiceImpl extends EgovAbstractServiceImpl
		implements EgovFaceMeshAPIService {

	@Resource(name = "FaceMeshAPIDAO")
	private FaceMeshAPIDAO faceMeshAPIDAO;

	@Override
	public int insertFaceMeshInfo(FaceMeshAPIVO vo) {
		return faceMeshAPIDAO.insertFaceMeshInfo(vo);
	}

	@Override
	public List<FaceMeshAPIVO> selectFaceMeshInfoList(FaceMeshAPIVO searchVO) {
		return faceMeshAPIDAO.selectFaceMeshInfoList(searchVO);
	}

	@Override
	public int deleteFaceMeshInfo(FaceMeshAPIVO vo) {
		return faceMeshAPIDAO.deleteFaceMeshInfo(vo);
	}
}
