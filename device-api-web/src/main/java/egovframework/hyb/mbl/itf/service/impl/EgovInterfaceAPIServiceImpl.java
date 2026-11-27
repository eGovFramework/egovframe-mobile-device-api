package egovframework.hyb.mbl.itf.service.impl;

import java.util.Collections;
import java.util.List;

import org.egovframe.rte.fdl.cmmn.EgovAbstractServiceImpl;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import egovframework.hyb.mbl.itf.service.EgovInterfaceAPIService;
import egovframework.hyb.mbl.itf.service.InterfaceAPIVO;
import jakarta.annotation.Resource;

/**
 * 통합 Interface API ServiceImpl
 */
@Service("EgovInterfaceAPIService")
public class EgovInterfaceAPIServiceImpl extends EgovAbstractServiceImpl implements EgovInterfaceAPIService {

    @Resource(name="InterfaceAPIDAO")
    private InterfaceAPIDAO interfaceAPIDAO;

    @Resource
    private PasswordEncoder passwordEncoder;

    public int insertInterfaceInfo(InterfaceAPIVO vo) {
        vo.setUserPw(passwordEncoder.encode(vo.getUserPw()));
        return interfaceAPIDAO.insertInterfaceInfo(vo);
    }

    public int updateInterfaceInfo(InterfaceAPIVO vo) {
        return interfaceAPIDAO.updateInterfaceInfo(vo);
    }

    public int deleteInterfaceInfo(InterfaceAPIVO vo) {
        if (selectInterfaceInfo(vo) == null) {
            return 0;
        }
        return interfaceAPIDAO.deleteInterfaceInfo(vo);
    }

    public InterfaceAPIVO selectInterfaceInfo(InterfaceAPIVO vo) {
        InterfaceAPIVO stored = interfaceAPIDAO.selectInterfaceInfo(vo);
        if (!passwordMatches(vo == null ? null : vo.getUserPw(), stored)) {
            return null;
        }
        stored.setUserPw(null);
        return stored;
    }

    public List<InterfaceAPIVO> selectInterfaceInfoList(InterfaceAPIVO searchVO) {
        if (selectInterfaceInfo(searchVO) == null) {
            return Collections.emptyList();
        }
        List<InterfaceAPIVO> list = interfaceAPIDAO.selectInterfaceInfoList(searchVO);
        for (InterfaceAPIVO item : list) {
            item.setUserPw(null);
        }
        return list;
    }

    public int selectInterfaceInfoListTotCnt(InterfaceAPIVO searchVO) {
        return interfaceAPIDAO.selectInterfaceInfoListTotCnt(searchVO);
    }

    private boolean passwordMatches(String rawPassword, InterfaceAPIVO stored) {
        if (rawPassword == null || stored == null || stored.getUserPw() == null || stored.getUserPw().isBlank()) {
            return false;
        }
        try {
            return passwordEncoder.matches(rawPassword, stored.getUserPw());
        } catch (IllegalArgumentException ex) {
            return false;
        }
    }
}
