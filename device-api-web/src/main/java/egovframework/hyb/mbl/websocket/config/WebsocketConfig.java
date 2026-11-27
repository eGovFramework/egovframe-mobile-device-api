package egovframework.hyb.mbl.websocket.config;

import java.util.Arrays;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.socket.config.annotation.EnableWebSocket;
import org.springframework.web.socket.config.annotation.WebSocketConfigurer;
import org.springframework.web.socket.config.annotation.WebSocketHandlerRegistry;

import egovframework.hyb.mbl.websocket.ws.ChatWebSocketHandler;
import egovframework.hyb.mbl.websocket.ws.HandshakeInterceptor;

@Configuration
@EnableWebSocket
public class WebsocketConfig implements WebSocketConfigurer {

	private static final Logger LOGGER = LoggerFactory.getLogger(WebsocketConfig.class);
	
	@Autowired
	private HandshakeInterceptor handshakeInterceptor;

	@Value("${app.websocket.allowed-origins:http://localhost:9700,http://127.0.0.1:9700}")
	private String allowedOrigins;

	@Value("${app.websocket.max-sessions:50}")
	private int maxSessions;
	
	@Override
	public void registerWebSocketHandlers(WebSocketHandlerRegistry registry) {				
		String[] origins = Arrays.stream(allowedOrigins.split(","))
				.map(String::trim)
				.filter(origin -> !origin.isEmpty())
				.toArray(String[]::new);
		LOGGER.debug(">>registerWebSocketHandlers - /websocket/chat.ws origins={}", origins.length);
		registry.addHandler(chatHandler(), "/websocket/chat.ws")
				.addInterceptors(handshakeInterceptor)
				.setAllowedOrigins(origins);
	}

	@Bean
	public ChatWebSocketHandler chatHandler() {
		return new ChatWebSocketHandler(maxSessions);
	}

}
