package egovframework.hyb.mbl.acl.service.impl;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.EgovAbstractMapper;
import org.springframework.stereotype.Repository;

import egovframework.hyb.mbl.acl.service.AcceleratorAPIVO;

/**
 * 통합 Accelerator API DAO
 */
@Repository("AcceleratorAPIDAO")
public class AcceleratorAPIDAO extends EgovAbstractMapper {

    public List<?> selectAcceleratorInfoList(AcceleratorAPIVO searchVO) {
        return selectList("acceleratorAPIDAO.selectAcceleratorInfoList", searchVO);
    }

    public int insertAcceleratorInfo(AcceleratorAPIVO vo) {
        return (Integer) insert("acceleratorAPIDAO.insertAcceleratorInfo", vo);
    }

    public int deleteAcceleratorInfo(AcceleratorAPIVO vo) {
        return (Integer) delete("acceleratorAPIDAO.deleteAcceleratorInfo", vo);
    }

}
