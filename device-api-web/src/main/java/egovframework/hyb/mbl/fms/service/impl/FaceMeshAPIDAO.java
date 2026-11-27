package egovframework.hyb.mbl.fms.service.impl;

import org.egovframe.rte.psl.dataaccess.mapper.EgovMapper;

import java.util.List;


import egovframework.hyb.mbl.fms.service.FaceMeshAPIVO;

@EgovMapper("FaceMeshAPIDAO")
public interface FaceMeshAPIDAO {

    public int insertFaceMeshInfo(FaceMeshAPIVO vo);


    public List<FaceMeshAPIVO> selectFaceMeshInfoList(FaceMeshAPIVO searchVO);


    public int deleteFaceMeshInfo(FaceMeshAPIVO vo);

}
