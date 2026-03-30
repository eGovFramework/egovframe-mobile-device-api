package egovframework.hyb.config;

import org.springdoc.core.models.GroupedOpenApi;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import io.swagger.v3.oas.models.OpenAPI;
import io.swagger.v3.oas.models.info.Contact;
import io.swagger.v3.oas.models.info.Info;
import io.swagger.v3.oas.models.info.License;

/**
 * SpringDoc OpenAPI 설정 클래스
 * 
 * @author 표준프레임워크센터
 * @since 2025. 06. 01
 * @version 1.0
 */
@Configuration
public class SpringDocConfig {

	@Bean
	public OpenAPI openAPI() {
		return new OpenAPI().info(
				new Info()
				.title("표준프레임워크 DeviceAPI 연계서비스 (Hybrid App)")
				.description("표준프레임워크 하이브리드앱 실행환경  - iOS / Android 하이브리드앱 Rest 서비스")
				.version("5.0.0")
				.contact(new Contact().name("표준프레임워크").email("egovframesupport@gmail.com"))
				.license(new License().name("Apache License Version 2.0").url("https://www.egovframe.go.kr"))
		);
	}

	@Bean
	public GroupedOpenApi newsApiAll() {
		return GroupedOpenApi.builder()
				.group("00. All Device API REST Service")
				.pathsToMatch("/**")
				.build();
	}

	@Bean
	public GroupedOpenApi acceleratorApi() {
		return GroupedOpenApi.builder()
				.group("01. Accelerator Guide Program Service")
				.pathsToMatch("/acl/**")
				.packagesToScan("egovframework.hyb.mbl.acl.web")
				.build();
	}

	@Bean
	public GroupedOpenApi cameraApi() {
		return GroupedOpenApi.builder()
				.group("02. Camera Guide Program Service")
				.pathsToMatch("/cmr/**")
				.build();
	}

	@Bean
	public GroupedOpenApi compassApi() {
		return GroupedOpenApi.builder()
				.group("03. Compass Guide Program Service")
				.pathsToMatch("/cps/**")
				.build();
	}

	@Bean
	public GroupedOpenApi contactsApi() {
		return GroupedOpenApi.builder()
				.group("04. Contacts Guide Program Service")
				.pathsToMatch("/ctt/**")
				.build();
	}

	@Bean
	public GroupedOpenApi deviceApi() {
		return GroupedOpenApi.builder()
				.group("05. DeviceInfo Guide Program Service")
				.pathsToMatch("/dvc/**")
				.build();
	}

	@Bean
	public GroupedOpenApi fileReaderWriterApi() {
		return GroupedOpenApi.builder()
				.group("06. FileReaderWriter Guide Program Service")
				.pathsToMatch("/frw/**")
				.build();
	}

	@Bean
	public GroupedOpenApi gpsApi() {
		return GroupedOpenApi.builder()
				.group("07. GPS Guide Program Service")
				.pathsToMatch("/gps/**")
				.build();
	}

	@Bean
	public GroupedOpenApi interfaceApi() {
		return GroupedOpenApi.builder()
				.group("08. Interface Guide Program Service")
				.pathsToMatch("/itf/**")
				.build();
	}

	@Bean
	public GroupedOpenApi mediaApi() {
		return GroupedOpenApi.builder()
				.group("09. Media Guide Program Service")
				.pathsToMatch("/mda/**")
				.build();
	}

	@Bean
	public GroupedOpenApi networkApi() {
		return GroupedOpenApi.builder()
				.group("10. Network Guide Program Service")
				.pathsToMatch("/nwk/**")
				.build();
	}

	@Bean
	public GroupedOpenApi vibratorApi() {
		return GroupedOpenApi.builder()
				.group("11. Vibrator Guide Program Service")
				.pathsToMatch("/vbr/**")
				.build();
	}

	@Bean
	public GroupedOpenApi pushApi() {
		return GroupedOpenApi.builder()
				.group("12. PushNotifications Guide Program Service")
				.pathsToMatch("/pus/**")
				.build();
	}

	@Bean
	public GroupedOpenApi fileOpenerApi() {
		return GroupedOpenApi.builder()
				.group("13. FileOpener Guide Program Service")
				.pathsToMatch("/fop/**")
				.build();
	}

	@Bean
	public GroupedOpenApi streamingMediaApi() {
		return GroupedOpenApi.builder()
				.group("14. StreamingMedia Guide Program Service")
				.pathsToMatch("/stm/**")
				.build();
	}

	@Bean
	public GroupedOpenApi barcodeScannerApi() {
		return GroupedOpenApi.builder()
				.group("15. Barcodescanner Guide Program Service")
				.pathsToMatch("/bar/**")
				.build();
	}

	@Bean
	public GroupedOpenApi resourceUpdateApi() {
		return GroupedOpenApi.builder()
				.group("16. WebResourceUpdate Guide Program Service")
				.pathsToMatch("/upd/**")
				.build();
	}

	@Bean
	public GroupedOpenApi jailbreakDetectionApi() {
		return GroupedOpenApi.builder()
				.group("17. JailbreakDetection Guide Program Service")
				.pathsToMatch("/jai/**")
				.build();
	}

}
