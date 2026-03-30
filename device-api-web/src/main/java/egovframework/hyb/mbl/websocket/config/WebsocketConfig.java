package egovframework.hyb.mbl.websocket.config;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
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
	
	@Override
	public void registerWebSocketHandlers(WebSocketHandlerRegistry registry) {				
		LOGGER.debug(">>registerWebSocketHandlers - /websocket/chat.ws");
		registry.addHandler(chatHandler(), "/websocket/chat.ws")
				.addInterceptors(handshakeInterceptor)
				.setAllowedOrigins("*");
	}

	@Bean
	public ChatWebSocketHandler chatHandler() {
		return new ChatWebSocketHandler();
	}

}
