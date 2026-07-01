package egovframework.hyb;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

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
