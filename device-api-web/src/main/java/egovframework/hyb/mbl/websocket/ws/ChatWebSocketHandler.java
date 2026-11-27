package egovframework.hyb.mbl.websocket.ws;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.socket.BinaryMessage;
import org.springframework.web.socket.CloseStatus;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;
import org.springframework.web.socket.handler.ConcurrentWebSocketSessionDecorator;
import org.springframework.web.socket.handler.SessionLimitExceededException;
import org.springframework.web.socket.handler.TextWebSocketHandler;

import egovframework.hyb.mbl.ws.service.SocketMessageLimits;

public class ChatWebSocketHandler extends TextWebSocketHandler {

	private static final Logger LOGGER = LoggerFactory.getLogger(ChatWebSocketHandler.class);

	private static final String MESSAGE_PREFIX = "msg:";

	/** 느린 수신자 한 명이 전체 브로드캐스트를 막지 않도록 하는 송신 제한 */
	private static final int SEND_TIME_LIMIT_MS = 10_000;
	private static final int SEND_BUFFER_LIMIT_BYTES = 512 * 1024;

	private final int maxSessions;

	private final Map<String, WebSocketSession> users = new ConcurrentHashMap<>();

	public ChatWebSocketHandler(int maxSessions) {
		this.maxSessions = maxSessions > 0 ? maxSessions : 50;
	}

	@Override
	public void afterConnectionEstablished(WebSocketSession session) throws Exception {
		boolean accepted;
		synchronized (users) {
			accepted = users.size() < maxSessions;
			if (accepted) {
				// 여러 스레드가 동시에 보내도 안전하도록 감싼다.
				users.put(session.getId(),
						new ConcurrentWebSocketSessionDecorator(session, SEND_TIME_LIMIT_MS, SEND_BUFFER_LIMIT_BYTES));
			}
		}
		if (!accepted) {
			log("연결 거절 (sessions=" + users.size() + ", max=" + maxSessions + ")");
			session.close(CloseStatus.SERVICE_OVERLOAD);
			return;
		}
		log(session.getId() + " 연결 됨 (sessions=" + users.size() + ")");
	}

	@Override
	public void afterConnectionClosed(WebSocketSession session, CloseStatus status) throws Exception {
		users.remove(session.getId());
		log(session.getId() + " 연결 종료됨 (sessions=" + users.size() + ")");
	}

	@Override
	protected void handleTextMessage(WebSocketSession session, TextMessage message) throws Exception {
		String payload = message.getPayload();
		log(session.getId() + "로부터 텍스트 메시지 수신 length=" + SocketMessageLimits.length(payload));

		if (!acceptText(payload)) {
			log(session.getId() + " 메시지 거절 length=" + SocketMessageLimits.length(payload));
			return;
		}

		broadcastText(payload);
	}

	@Override
	protected void handleBinaryMessage(WebSocketSession session, BinaryMessage message) {
		log(session.getId() + " 바이너리 메시지 거절 length=" + message.getPayloadLength());
	}

	private boolean acceptText(String payload) {
		if (payload == null || !payload.startsWith(MESSAGE_PREFIX)) {
			return false;
		}
		String body = payload.substring(MESSAGE_PREFIX.length());
		int separator = body.indexOf(':');
		if (separator <= 0 || separator >= body.length() - 1) {
			return false;
		}
		String sender = body.substring(0, separator);
		String text = body.substring(separator + 1);
		if (sender.isBlank() || text.isBlank()) {
			return false;
		}
		return SocketMessageLimits.within(sender, SocketMessageLimits.MAX_SENDER_LENGTH)
				&& SocketMessageLimits.within(text, SocketMessageLimits.MAX_MESSAGE_LENGTH);
	}

	private void broadcastText(String payload) {
		removeClosedSessions();
		TextMessage outbound = new TextMessage(payload);
		for (WebSocketSession s : users.values()) {
			if (!s.isOpen()) {
				continue;
			}
			try {
				s.sendMessage(outbound);
				log(s.getId() + "에 텍스트 메시지 발송 length=" + SocketMessageLimits.length(payload));
			} catch (IOException | SessionLimitExceededException e) {
				log(s.getId() + " 발송 실패: " + e.getMessage());
				users.remove(s.getId());
			}
		}
	}

	private void removeClosedSessions() {
		List<String> closedIds = new ArrayList<>();
		for (Map.Entry<String, WebSocketSession> entry : users.entrySet()) {
			if (!entry.getValue().isOpen()) {
				closedIds.add(entry.getKey());
			}
		}
		for (String id : closedIds) {
			users.remove(id);
		}
	}

	@Override
	public void handleTransportError(WebSocketSession session, Throwable exception) {
		log(session.getId() + " 익셉션 발생: " + exception.getMessage());
		users.remove(session.getId());
	}

	private void log(String logmsg) {
		LOGGER.info(logmsg);
	}

}
