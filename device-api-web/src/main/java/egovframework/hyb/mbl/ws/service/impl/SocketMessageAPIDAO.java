package egovframework.hyb.mbl.ws.service.impl;

import org.egovframe.rte.psl.dataaccess.mapper.EgovMapper;

import java.util.List;


import egovframework.hyb.mbl.ws.service.SocketMessageAPIVO;

@EgovMapper("SocketMessageAPIDAO")
public interface SocketMessageAPIDAO {

    public int insertSocketMessageInfo(SocketMessageAPIVO vo);


    public List<SocketMessageAPIVO> selectSocketMessageInfoList(SocketMessageAPIVO searchVO);


    public int deleteSocketMessageInfo(SocketMessageAPIVO vo);

}
