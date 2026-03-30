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

    public int insertDeviceInfo(DeviceAPIVO vo) throws Exception {
        return (Integer) deviceAPIDAO.insertDeviceInfo(vo);
    }

    public int deleteDeviceInfo(DeviceAPIVO vo) throws Exception {
        return (Integer) deviceAPIDAO.deleteDeviceInfo(vo);
    }

    public DeviceAPIVO selectDeviceInfo(DeviceAPIVO vo) throws Exception {
        return (DeviceAPIVO) deviceAPIDAO.selectDeviceInfo(vo);
    }

    public List<?> selectDeviceInfoList(DeviceAPIVO searchVO) throws Exception {
        return deviceAPIDAO.selectDeviceInfoList(searchVO);
    }

    public int selectDeviceInfoListTotCnt(DeviceAPIVO searchVO) throws Exception {
        return (Integer) deviceAPIDAO.selectDeviceInfoListTotCnt(searchVO);
    }
}
