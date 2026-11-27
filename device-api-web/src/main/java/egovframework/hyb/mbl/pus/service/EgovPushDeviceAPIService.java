package egovframework.hyb.mbl.pus.service;

import java.util.List;

/**
 * Push 기기 등록, FCM 발송, 발송 이력 서비스
 *
 * 수정이력
 * 2016.06.20 신성학 최초생성
 */
public interface EgovPushDeviceAPIService {

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

	/**
	 * FCM 발송
	 *
	 * @return 0 성공, 1 HTTP 오류, 2 서비스 계정 파일 없음, 3 IO 오류, 4 기타 예외
	 */
	int sendPushNotification(PushDeviceAPIVO vo);

	/** 발송 이력 저장 */
	int insertPushMessage(PushDeviceAPIVO vo);

	/** UUID 기준 발송 이력 */
	List<PushDeviceAPIVO> selectPushMessageList(PushDeviceAPIVO vo);

	int selectPushMessageCount(PushDeviceAPIVO vo);

	/** 전체 발송 이력(관리 화면) */
	List<PushDeviceAPIVO> selectAllPushMessageList(PushDeviceAPIVO searchVO);

	int selectAllPushMessageCount(PushDeviceAPIVO searchVO);
}
