package egovframework.hyb.mbl.websocket.ws;

import org.springframework.stereotype.Component;
import org.springframework.web.socket.server.support.HttpSessionHandshakeInterceptor;

/**
 * 채팅 WebSocket 핸드셰이크 시 HTTP 세션 속성을 WebSocket 세션으로 복사한다.
 */
@Component
public class HandshakeInterceptor extends HttpSessionHandshakeInterceptor {
}
