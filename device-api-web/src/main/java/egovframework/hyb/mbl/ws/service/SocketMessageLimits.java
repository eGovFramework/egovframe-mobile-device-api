package egovframework.hyb.mbl.ws.service;

/**
 * SOCKET_MESSAGE 컬럼과 같은 문자 수 상한.
 * MySQL VARCHAR(n)은 utf8mb4에서 문자 수이고, Java 코드 포인트 수와 맞춘다.
 */
public final class SocketMessageLimits {

	public static final int MAX_SENDER_LENGTH = 100;

	public static final int MAX_MESSAGE_LENGTH = 1000;

	private SocketMessageLimits() {
	}

	public static boolean within(String value, int maxLength) {
		return length(value) <= maxLength;
	}

	public static int length(String value) {
		if (value == null || value.isEmpty()) {
			return 0;
		}
		return value.codePointCount(0, value.length());
	}
}
