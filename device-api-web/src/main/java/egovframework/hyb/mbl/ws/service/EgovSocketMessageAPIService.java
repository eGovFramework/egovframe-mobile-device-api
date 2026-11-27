package egovframework.hyb.mbl.ws.service;

import java.util.List;

public interface EgovSocketMessageAPIService {

    int insertSocketMessageInfo(SocketMessageAPIVO vo);

    List<SocketMessageAPIVO> selectSocketMessageInfoList(SocketMessageAPIVO searchVO);

    int deleteSocketMessageInfo(SocketMessageAPIVO vo);
}
