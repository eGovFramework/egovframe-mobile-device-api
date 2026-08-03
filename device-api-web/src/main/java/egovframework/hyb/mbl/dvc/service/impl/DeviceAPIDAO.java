package egovframework.hyb.mbl.dvc.service.impl;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.EgovAbstractMapper;
import org.springframework.stereotype.Repository;

import egovframework.hyb.mbl.dvc.service.DeviceAPIVO;

/**
 * 통합 Device API DAO
 */
@Repository
public class DeviceAPIDAO extends EgovAbstractMapper {

    public int insertDeviceInfo(DeviceAPIVO vo) {
        return insert("deviceAPIDAO.insertDeviceInfo", vo);
    }

    public int deleteDeviceInfo(DeviceAPIVO vo) {
        return delete("deviceAPIDAO.deleteDeviceInfo", vo);
    }

    public DeviceAPIVO selectDeviceInfo(DeviceAPIVO vo) {
        return selectOne("deviceAPIDAO.selectDeviceInfo", vo);
    }

    public List<DeviceAPIVO> selectDeviceInfoList(DeviceAPIVO searchVO) {
        return selectList("deviceAPIDAO.selectDeviceInfoList", searchVO);
    }

    public int selectDeviceInfoListTotCnt(DeviceAPIVO searchVO) {
        return selectOne("deviceAPIDAO.selectDeviceInfoListTotCnt", searchVO);
    }
}
