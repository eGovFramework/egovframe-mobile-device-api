package egovframework.hyb.mbl.dvc.service;

import java.util.List;

/**
 * 통합 Device API Service Interface
 */
public interface EgovDeviceAPIService {

    int insertDeviceInfo(DeviceAPIVO vo) throws Exception;

    int deleteDeviceInfo(DeviceAPIVO vo) throws Exception;

    DeviceAPIVO selectDeviceInfo(DeviceAPIVO vo) throws Exception;

    List<?> selectDeviceInfoList(DeviceAPIVO searchVO) throws Exception;

    int selectDeviceInfoListTotCnt(DeviceAPIVO searchVO) throws Exception;
}
