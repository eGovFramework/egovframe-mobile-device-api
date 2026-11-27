package egovframework.hyb.mbl.iot.service;

import java.util.List;

public interface EgovIotMessageAPIService {

    int insertIotMessageInfo(IotMessageAPIVO vo);

    List<IotMessageAPIVO> selectIotMessageInfoList(IotMessageAPIVO searchVO);

    int deleteIotMessageInfo(IotMessageAPIVO vo);
}
