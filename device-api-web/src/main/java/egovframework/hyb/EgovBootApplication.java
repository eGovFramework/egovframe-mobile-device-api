package egovframework.hyb;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import jakarta.servlet.http.HttpServletRequest;

@SpringBootApplication
public class EgovBootApplication {

	public static void main(String[] args) {
		SpringApplication.run(EgovBootApplication.class, args);
	}

	@Controller
	static class IndexController {
		@GetMapping("/")
		public String index() {
			return "index";
		}

		@GetMapping("/chat-sockjs")
		public String chatSockjs(Model model, HttpServletRequest request) {
			String serverName = request.getServerName();
			int serverPort = request.getServerPort();
			String contextPath = request.getContextPath();
			String serverUrl = "ws://" + serverName + ":" + serverPort + contextPath;
			model.addAttribute("serverUrl", serverUrl);
			return "chat-sockjs";
		}

		@GetMapping("/test-ajax")
		public String testAjax() {
			return "test-ajax";
		}

		// favicon.ico 요청 처리 (404 오류 방지)
		@GetMapping("/favicon.ico")
		public ResponseEntity<Void> favicon() {
			return new ResponseEntity<>(HttpStatus.NO_CONTENT);
		}
	}

}
