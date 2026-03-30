package egovframework.hyb.mbl.websocket.ws;

import java.io.IOException;
import java.util.Date;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.socket.BinaryMessage;
import org.springframework.web.socket.CloseStatus;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;
import org.springframework.web.socket.handler.TextWebSocketHandler;

public class ChatWebSocketHandler extends TextWebSocketHandler {

	private static final Logger LOGGER = LoggerFactory.getLogger(ChatWebSocketHandler.class);

	private Map<String, WebSocketSession> users = new ConcurrentHashMap<>();

	@Override
	public void afterConnectionEstablished(WebSocketSession session) throws Exception {
		log(session.getId() + " 연결 됨");
		users.put(session.getId(), session);
	}

	@Override
	public void afterConnectionClosed(WebSocketSession session, CloseStatus status) throws Exception {
		log(session.getId() + " 연결 종료됨");
		users.remove(session.getId());
	}

	@Override
	protected void handleTextMessage(WebSocketSession session, TextMessage message) throws Exception {
		String payload = message.getPayload();
		log(session.getId() + "로부터 텍스트 메시지 수신: " + payload);
		
		// 모든 연결된 사용자에게 메시지 브로드캐스트
		for (WebSocketSession s : users.values()) {
			try {
				s.sendMessage(new TextMessage(payload));
			} catch (IOException e) {
				handleTransportError(session, e);
			}
			log(s.getId() + "에 메시지 발송: " + payload);
		}
	}

	@Override
	protected void handleBinaryMessage(WebSocketSession session, BinaryMessage message) {
		log(session.getId() + "로부터 바이너리 메시지 수신: " + message.getPayload());
		for (WebSocketSession s : users.values()) {
			try {
				s.sendMessage(message);
			} catch (IOException e) {
				handleTransportError(session, e);
			}
			log(s.getId() + "에 메시지 발송: " + message.getPayload());
		}
	}

	@Override
	public void handleTransportError(WebSocketSession session, Throwable exception) {
		log(session.getId() + " 익셉션 발생: " + exception.getMessage());
	}

	private void log(String logmsg) {
		LOGGER.info(new Date() + " : " + logmsg);
	}

}
