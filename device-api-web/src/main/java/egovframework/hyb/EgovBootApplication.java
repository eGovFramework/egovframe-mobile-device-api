package egovframework.hyb;

import org.egovframe.rte.psl.dataaccess.mapper.EgovMapper;
import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import io.swagger.v3.oas.annotations.Hidden;
import jakarta.servlet.http.HttpServletRequest;

@SpringBootApplication
@MapperScan(basePackages = "egovframework.hyb", annotationClass = EgovMapper.class, sqlSessionFactoryRef = "sqlSession")
public class EgovBootApplication {

	public static void main(String[] args) {
		SpringApplication.run(EgovBootApplication.class, args);
	}

	@Controller
	@Hidden
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
			String scheme = request.isSecure() ? "wss" : "ws";
			String serverUrl = scheme + "://" + serverName + ":" + serverPort + contextPath;
			model.addAttribute("serverUrl", serverUrl);
			return "chat-sockjs";
		}

		@GetMapping("/test-ajax")
		public String testAjax() {
			return "test-ajax";
		}

		// favicon 404 로그 방지
		@GetMapping("/favicon.ico")
		public ResponseEntity<Void> favicon() {
			return new ResponseEntity<>(HttpStatus.NO_CONTENT);
		}
	}

}
