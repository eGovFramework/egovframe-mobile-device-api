package egovframework.hyb.utils;

import org.egovframe.rte.fdl.cmmn.EgovAbstractServiceImpl;
import org.springframework.stereotype.Service;

import egovframework.hyb.mbl.mda.service.impl.MediaAPIDAO;
import jakarta.annotation.Resource;

@Service("EgovFileService")
public class EgovFileServiceImpl extends EgovAbstractServiceImpl implements EgovFileService{

	@Resource(name="FileDAO")
	private EgovFileDAO fileDAO;

	@Override
	public FileVO selectFileDetailInfo(int fileSn) throws Exception {
		return fileDAO.selectFileDetailInfo(fileSn);
	}

	@Override
	public int insertFileDetailInfo(FileVO fileVO) throws Exception {
		return fileDAO.insertFileDetailInfo(fileVO);
	}

}
