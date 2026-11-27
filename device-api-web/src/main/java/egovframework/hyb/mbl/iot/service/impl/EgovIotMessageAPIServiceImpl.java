package egovframework.hyb.mbl.iot.service.impl;

import java.util.List;

import org.egovframe.rte.fdl.cmmn.EgovAbstractServiceImpl;
import org.springframework.stereotype.Service;

import egovframework.hyb.mbl.iot.service.EgovIotMessageAPIService;
import egovframework.hyb.mbl.iot.service.IotMessageAPIVO;
import jakarta.annotation.Resource;

@Service("EgovIotMessageAPIService")
public class EgovIotMessageAPIServiceImpl extends EgovAbstractServiceImpl implements EgovIotMessageAPIService {

    @Resource(name = "IotMessageAPIDAO")
    private IotMessageAPIDAO iotMessageAPIDAO;

    public int insertIotMessageInfo(IotMessageAPIVO vo) {
        return iotMessageAPIDAO.insertIotMessageInfo(vo);
    }

    public List<IotMessageAPIVO> selectIotMessageInfoList(IotMessageAPIVO searchVO) {
        return iotMessageAPIDAO.selectIotMessageInfoList(searchVO);
    }

    public int deleteIotMessageInfo(IotMessageAPIVO vo) {
        return iotMessageAPIDAO.deleteIotMessageInfo(vo);
    }
}
