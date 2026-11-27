package egovframework.hyb.mbl.pus.service.impl;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.mapper.EgovMapper;

import egovframework.hyb.mbl.pus.service.PushDeviceAPIVO;

/**
 * Push 기기·발송 이력 DAO
 *
 * 수정이력
 * 2016.06.20 신성학 최초생성
 */
@EgovMapper("PushDeviceAPIDAO")
public interface PushDeviceAPIDAO {

	/** UUID 기준 등록 기기 목록 */
	List<PushDeviceAPIVO> selectPushDeviceList(PushDeviceAPIVO searchVO);

	/** UUID 기준 등록 기기 수 */
	int selectPushDeviceCount(PushDeviceAPIVO vo);

	/** 전체 등록 기기 목록(관리 화면) */
	List<PushDeviceAPIVO> selectAllPushDeviceList(PushDeviceAPIVO searchVO);

	/** 전체 등록 기기 수(관리 화면) */
	int selectAllPushDeviceCount(PushDeviceAPIVO searchVO);

	int insertPushDevice(PushDeviceAPIVO vo);

	int deletePushDevice(PushDeviceAPIVO vo);

	/** 발송 이력 저장 */
	int insertPushInfo(PushDeviceAPIVO vo);

	/** UUID 기준 발송 이력 */
	List<PushDeviceAPIVO> selectPushMessageList(PushDeviceAPIVO vo);

	int selectPushMessageCount(PushDeviceAPIVO vo);

	/** 전체 발송 이력(관리 화면) */
	List<PushDeviceAPIVO> selectAllPushMessageList(PushDeviceAPIVO searchVO);

	int selectAllPushMessageCount(PushDeviceAPIVO searchVO);
}
