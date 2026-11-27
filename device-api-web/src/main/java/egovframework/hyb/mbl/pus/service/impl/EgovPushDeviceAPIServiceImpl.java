package egovframework.hyb.mbl.pus.service.impl;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import org.egovframe.rte.fdl.cmmn.EgovAbstractServiceImpl;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.ClassPathResource;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import com.google.auth.oauth2.GoogleCredentials;

import egovframework.hyb.mbl.pus.service.EgovPushDeviceAPIService;
import egovframework.hyb.mbl.pus.service.PushDeviceAPIVO;
import jakarta.annotation.Resource;

/**
 * Push 기기 등록, FCM HTTP v1 발송, 발송 이력 서비스
 *
 * 수정이력
 * 2016.06.20 신성학 최초생성
 * 2017.02.15 최두영 시큐어코딩(ES) 오류 메시지를 통한 정보 노출[CWE-209]
 */
@Service("EgovPushDeviceAPIService")
public class EgovPushDeviceAPIServiceImpl extends EgovAbstractServiceImpl implements EgovPushDeviceAPIService {

	private static final Logger LOGGER = LoggerFactory.getLogger(EgovPushDeviceAPIServiceImpl.class);

	@Value("${Globals.fcmSdk}")
	private String fcmSdk;

	@Value("${Globals.fcmMessagingScope}")
	private String fcmMessagingScope;

	@Value("${Globals.fcmRequestPath}")
	private String fcmRequestPath;

	@Resource(name = "PushDeviceAPIDAO")
	private PushDeviceAPIDAO pushDeviceAPIDAO;

	private final RestTemplate restTemplate = new RestTemplate();

	@Override
	public List<PushDeviceAPIVO> selectPushDeviceList(PushDeviceAPIVO searchVO) {
		return pushDeviceAPIDAO.selectPushDeviceList(searchVO);
	}

	@Override
	public int selectPushDeviceCount(PushDeviceAPIVO vo) {
		return pushDeviceAPIDAO.selectPushDeviceCount(vo);
	}

	@Override
	public List<PushDeviceAPIVO> selectAllPushDeviceList(PushDeviceAPIVO searchVO) {
		return pushDeviceAPIDAO.selectAllPushDeviceList(searchVO);
	}

	@Override
	public int selectAllPushDeviceCount(PushDeviceAPIVO searchVO) {
		return pushDeviceAPIDAO.selectAllPushDeviceCount(searchVO);
	}

	@Override
	public int insertPushDevice(PushDeviceAPIVO vo) {
		return pushDeviceAPIDAO.insertPushDevice(vo);
	}

	@Override
	public int deletePushDevice(PushDeviceAPIVO vo) {
		return pushDeviceAPIDAO.deletePushDevice(vo);
	}

	@Override
	public int sendPushNotification(PushDeviceAPIVO vo) {
		return sendFcm(vo.getTokenId(), vo.getMessage());
	}

	@Override
	public int insertPushMessage(PushDeviceAPIVO vo) {
		return pushDeviceAPIDAO.insertPushInfo(vo);
	}

	@Override
	public List<PushDeviceAPIVO> selectPushMessageList(PushDeviceAPIVO vo) {
		return pushDeviceAPIDAO.selectPushMessageList(vo);
	}

	@Override
	public int selectPushMessageCount(PushDeviceAPIVO vo) {
		return pushDeviceAPIDAO.selectPushMessageCount(vo);
	}

	@Override
	public List<PushDeviceAPIVO> selectAllPushMessageList(PushDeviceAPIVO searchVO) {
		return pushDeviceAPIDAO.selectAllPushMessageList(searchVO);
	}

	@Override
	public int selectAllPushMessageCount(PushDeviceAPIVO searchVO) {
		return pushDeviceAPIDAO.selectAllPushMessageCount(searchVO);
	}

	/** FCM 등록 토큰으로 발송한다. Android, iOS 공통 */
	private int sendFcm(String pushRegId, String pushMessage) {
		List<String> scopes = List.of(fcmMessagingScope == null ? "" : fcmMessagingScope.trim());
		try {
			GoogleCredentials googleCredentials;
			try (InputStream serviceAccountStream = openFcmServiceAccountStream()) {
				googleCredentials = GoogleCredentials.fromStream(serviceAccountStream).createScoped(scopes);
			}
			googleCredentials.refreshIfExpired();

			HttpHeaders headers = new HttpHeaders();
			headers.setBearerAuth(googleCredentials.getAccessToken().getTokenValue());
			headers.setContentType(MediaType.APPLICATION_JSON);

			Map<String, Object> notification = new LinkedHashMap<>();
			notification.put("title", "FCM Test Title");
			notification.put("body", pushMessage);

			Map<String, Object> message = new LinkedHashMap<>();
			message.put("token", pushRegId);
			message.put("notification", notification);

			ResponseEntity<String> res = restTemplate.exchange(fcmRequestPath, HttpMethod.POST,
					new HttpEntity<>(Map.of("message", message), headers), String.class);
			LOGGER.info("FCM send result: status={}", res.getStatusCode());
			return res.getStatusCode() == HttpStatus.OK ? 0 : 1;
		} catch (FileNotFoundException fnfe) {
			LOGGER.error("FCM service account not found. configured={} : {}", fcmSdk, fnfe.getMessage());
			return 2;
		} catch (IOException ioe) {
			LOGGER.error("[{}] IOException : {}", ioe.getClass().getName(), ioe.getMessage());
			return 3;
		} catch (Exception e) {
			LOGGER.error("[{}] Exception : {}", e.getClass().getName(), e.getMessage());
			return 4;
		}
	}

	/** 서비스 계정 JSON 탐색 순서: 절대/상대 경로, 실행 디렉터리, classpath */
	private InputStream openFcmServiceAccountStream() throws IOException {
		String configuredPath = fcmSdk == null ? "" : fcmSdk.trim();
		if (configuredPath.isEmpty()) {
			throw new FileNotFoundException("Globals.fcmSdk is empty");
		}

		File direct = new File(configuredPath);
		if (direct.isFile()) {
			return new FileInputStream(direct);
		}

		File fromWorkingDir = new File(System.getProperty("user.dir"), configuredPath);
		if (fromWorkingDir.isFile()) {
			return new FileInputStream(fromWorkingDir);
		}

		ClassPathResource classpathResource = new ClassPathResource(configuredPath);
		if (classpathResource.exists()) {
			return classpathResource.getInputStream();
		}

		throw new FileNotFoundException(configuredPath + " (searched: path, user.dir, classpath)");
	}
}
