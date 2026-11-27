package egovframework.hyb.mbl.acl.service.impl;

import org.egovframe.rte.psl.dataaccess.mapper.EgovMapper;

import java.util.List;


import egovframework.hyb.mbl.acl.service.AcceleratorAPIVO;

/**
 * 통합 Accelerator API DAO
 */
@EgovMapper("AcceleratorAPIDAO")
public interface AcceleratorAPIDAO {

    public List<AcceleratorAPIVO> selectAcceleratorInfoList(AcceleratorAPIVO searchVO);


    public int insertAcceleratorInfo(AcceleratorAPIVO vo);


    public int deleteAcceleratorInfo(AcceleratorAPIVO vo);


}
