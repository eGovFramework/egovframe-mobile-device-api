package egovframework.hyb.mbl.dvc.service;

import java.util.List;

/**
 * 통합 Device API Service Interface
 */
public interface EgovDeviceAPIService {

    int insertDeviceInfo(DeviceAPIVO vo);

    int deleteDeviceInfo(DeviceAPIVO vo);

    DeviceAPIVO selectDeviceInfo(DeviceAPIVO vo);

    List<DeviceAPIVO> selectDeviceInfoList(DeviceAPIVO searchVO);

    int selectDeviceInfoListTotCnt(DeviceAPIVO searchVO);
}
