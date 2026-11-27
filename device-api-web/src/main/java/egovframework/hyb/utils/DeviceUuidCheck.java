package egovframework.hyb.utils;

import java.util.HashMap;
import java.util.Map;

import org.springframework.http.ResponseEntity;

/**
 * 기기 데이터 API에서 빈 UUID를 거절한다.
 */
public final class DeviceUuidCheck {

	private DeviceUuidCheck() {
	}

	public static boolean isBlank(String value) {
		return value == null || value.isBlank();
	}

	public static ResponseEntity<Map<String, Object>> requiredResponse() {
		Map<String, Object> response = new HashMap<>();
		response.put("resultState", "FAIL");
		response.put("resultMessage", "uuid is required");
		return ResponseEntity.badRequest().body(response);
	}
}
