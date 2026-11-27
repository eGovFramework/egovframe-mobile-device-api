package egovframework.hyb.mbl.ws.service.impl;

import java.util.List;

import org.egovframe.rte.fdl.cmmn.EgovAbstractServiceImpl;
import org.springframework.stereotype.Service;

import egovframework.hyb.mbl.ws.service.EgovSocketMessageAPIService;
import egovframework.hyb.mbl.ws.service.SocketMessageAPIVO;
import jakarta.annotation.Resource;

@Service("EgovSocketMessageAPIService")
public class EgovSocketMessageAPIServiceImpl extends EgovAbstractServiceImpl implements EgovSocketMessageAPIService {

    @Resource(name = "SocketMessageAPIDAO")
    private SocketMessageAPIDAO socketMessageAPIDAO;

    public int insertSocketMessageInfo(SocketMessageAPIVO vo) {
        return socketMessageAPIDAO.insertSocketMessageInfo(vo);
    }

    public List<SocketMessageAPIVO> selectSocketMessageInfoList(SocketMessageAPIVO searchVO) {
        return socketMessageAPIDAO.selectSocketMessageInfoList(searchVO);
    }

    public int deleteSocketMessageInfo(SocketMessageAPIVO vo) {
        return socketMessageAPIDAO.deleteSocketMessageInfo(vo);
    }
}
