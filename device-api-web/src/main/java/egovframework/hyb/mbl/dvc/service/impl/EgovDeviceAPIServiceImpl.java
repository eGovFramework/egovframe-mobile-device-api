package egovframework.hyb.mbl.dvc.service.impl;

import java.util.List;

import org.egovframe.rte.fdl.cmmn.EgovAbstractServiceImpl;
import org.springframework.stereotype.Service;

import egovframework.hyb.mbl.dvc.service.DeviceAPIVO;
import egovframework.hyb.mbl.dvc.service.EgovDeviceAPIService;
import jakarta.annotation.Resource;

/**
 * 통합 Device API ServiceImpl
 */
@Service("EgovDeviceAPIService")
public class EgovDeviceAPIServiceImpl extends EgovAbstractServiceImpl implements EgovDeviceAPIService {

    @Resource(name="DeviceAPIDAO")
    private DeviceAPIDAO deviceAPIDAO;

    public int insertDeviceInfo(DeviceAPIVO vo) {
        return deviceAPIDAO.insertDeviceInfo(vo);
    }

    public int deleteDeviceInfo(DeviceAPIVO vo) {
        return deviceAPIDAO.deleteDeviceInfo(vo);
    }

    public DeviceAPIVO selectDeviceInfo(DeviceAPIVO vo) {
        return deviceAPIDAO.selectDeviceInfo(vo);
    }

    public List<DeviceAPIVO> selectDeviceInfoList(DeviceAPIVO searchVO) {
        return deviceAPIDAO.selectDeviceInfoList(searchVO);
    }

    public int selectDeviceInfoListTotCnt(DeviceAPIVO searchVO) {
        return deviceAPIDAO.selectDeviceInfoListTotCnt(searchVO);
    }
}
