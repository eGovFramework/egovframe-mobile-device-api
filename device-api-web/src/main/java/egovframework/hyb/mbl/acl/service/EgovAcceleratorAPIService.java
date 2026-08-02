package egovframework.hyb.mbl.acl.service;

import java.util.List;

/**
 * 통합 Accelerator API Service Interface
 */
public interface EgovAcceleratorAPIService {

    List<AcceleratorAPIVO> selectAcceleratorInfoList(AcceleratorAPIVO searchVO);

	int insertAcceleratorInfo(AcceleratorAPIVO vo);

    int deleteAcceleratorInfo(AcceleratorAPIVO vo);

}
