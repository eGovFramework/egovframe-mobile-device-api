package egovframework.hyb.mbl.iot.service.impl;

import org.egovframe.rte.psl.dataaccess.mapper.EgovMapper;

import java.util.List;


import egovframework.hyb.mbl.iot.service.IotMessageAPIVO;

@EgovMapper("IotMessageAPIDAO")
public interface IotMessageAPIDAO {

    public int insertIotMessageInfo(IotMessageAPIVO vo);


    public List<IotMessageAPIVO> selectIotMessageInfoList(IotMessageAPIVO searchVO);


    public int deleteIotMessageInfo(IotMessageAPIVO vo);

}
