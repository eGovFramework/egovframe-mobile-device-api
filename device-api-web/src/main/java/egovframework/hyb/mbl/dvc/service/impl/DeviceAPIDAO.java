package egovframework.hyb.mbl.dvc.service.impl;

import org.egovframe.rte.psl.dataaccess.mapper.EgovMapper;

import java.util.List;


import egovframework.hyb.mbl.dvc.service.DeviceAPIVO;

/**
 * 통합 Device API DAO
 */
@EgovMapper("DeviceAPIDAO")
public interface DeviceAPIDAO {

    public int insertDeviceInfo(DeviceAPIVO vo);


    public int deleteDeviceInfo(DeviceAPIVO vo);


    public DeviceAPIVO selectDeviceInfo(DeviceAPIVO vo);


    public List<DeviceAPIVO> selectDeviceInfoList(DeviceAPIVO searchVO);


    public int selectDeviceInfoListTotCnt(DeviceAPIVO searchVO);

}
