package egovframework.hyb.utils;

/**
 * 파일 경로·로그 입력값 정제 유틸
 */
public final class EgovWebUtil {

	private EgovWebUtil() {
	}

	/** 경로 조작(..) 문자열을 제거한다. */
	public static String filePathBlackList(String value) {
		if (value == null || value.isBlank()) {
			return "";
		}
		return value.replace("..", "");
	}

	/** 응답 헤더·로그 분할을 막기 위해 CR, LF를 제거한다. */
	public static String removeCRLF(String parameter) {
		return parameter.replace("\r", "").replace("\n", "");
	}

}
