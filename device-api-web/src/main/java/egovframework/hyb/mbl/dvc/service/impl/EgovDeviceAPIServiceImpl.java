package egovframework.hyb.mbl.dvc.service.impl;

import java.util.List;

import org.egovframe.rte.fdl.cmmn.EgovAbstractServiceImpl;
import org.springframework.stereotype.Service;

import egovframework.hyb.mbl.dvc.service.DeviceAPIVO;
import egovframework.hyb.mbl.dvc.service.EgovDeviceAPIService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

/**
 * 통합 Device API ServiceImpl
 */
@Service
@RequiredArgsConstructor
@Slf4j
public class EgovDeviceAPIServiceImpl extends EgovAbstractServiceImpl implements EgovDeviceAPIService {

    private final DeviceAPIDAO deviceAPIDAO;

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
        log.debug("uuid={}", searchVO.getUuid());
        return deviceAPIDAO.selectDeviceInfoList(searchVO);
    }

    public int selectDeviceInfoListTotCnt(DeviceAPIVO searchVO) {
        return deviceAPIDAO.selectDeviceInfoListTotCnt(searchVO);
    }
}
