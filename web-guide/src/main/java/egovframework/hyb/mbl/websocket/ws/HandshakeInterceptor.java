package egovframework.hyb.mbl.websocket.ws;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpHeaders;
import org.springframework.http.server.ServerHttpRequest;
import org.springframework.http.server.ServerHttpResponse;
import org.springframework.stereotype.Component;
import org.springframework.web.socket.WebSocketHandler;
import org.springframework.web.socket.server.support.HttpSessionHandshakeInterceptor;

@Component
public class HandshakeInterceptor extends HttpSessionHandshakeInterceptor{

	private static final Logger LOGGER = LoggerFactory.getLogger(HandshakeInterceptor.class);
	
	@Override
	public boolean beforeHandshake(ServerHttpRequest request,
			ServerHttpResponse response, WebSocketHandler wsHandler,
			Map<String, Object> attributes) throws Exception {
		
		HttpHeaders headers = request.getHeaders();
		LOGGER.debug("===>>> headers.size() = "+headers.size());
		
		for (Map.Entry<String, List<String>> entry : headers.entrySet()) {
			String headerName = entry.getKey();
			for (String headerValue : entry.getValue()) {
				LOGGER.debug(String.format(">> Header '%s' = %s", headerName, headerValue));
			}
		}

		/*headers.forEach((key, value) -> {
			LOGGER.debug(String.format("Header '%s' = %s", key, value));
	    });*/

		//The extension [x-webkit-deflate-frame] is not supported
		request.getHeaders().set("Access-Control-Allow-Headers", "X-Requested-With");
		if(request.getHeaders().containsKey("Sec-WebSocket-Extensions")) {
			//request.getHeaders().set("Sec-WebSocket-Extensions", "permessage-deflate");
        }
		
		return super.beforeHandshake(request, response, wsHandler, attributes);
	}

}

