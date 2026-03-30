package egovframework.hyb.mbl.acl.service;

import java.util.List;

/**
 * 통합 Accelerator API Service Interface
 */
public interface EgovAcceleratorAPIService {

    List<?> selectAcceleratorInfoList(AcceleratorAPIVO searchVO) throws Exception;

	int insertAcceleratorInfo(AcceleratorAPIVO vo) throws Exception;

    int deleteAcceleratorInfo(AcceleratorAPIVO vo) throws Exception;

}
