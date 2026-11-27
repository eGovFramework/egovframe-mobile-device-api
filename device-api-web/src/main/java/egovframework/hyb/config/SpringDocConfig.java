package egovframework.hyb.config;

import org.springdoc.core.models.GroupedOpenApi;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import io.swagger.v3.oas.models.OpenAPI;
import io.swagger.v3.oas.models.info.Contact;
import io.swagger.v3.oas.models.info.Info;
import io.swagger.v3.oas.models.info.License;

/**
 * SpringDoc OpenAPI 설정. 그룹 이름은 컨트롤러 @Tag 이름과 맞춘다.
 * 활성 여부는 springdoc.*.enabled 프로퍼티(local만 true)로 제어한다.
 */
@Configuration
public class SpringDocConfig {

	private static final String API_PACKAGE = "egovframework.hyb.mbl";

	@Bean
	OpenAPI openAPI() {
		return new OpenAPI().info(new Info()
				.title("표준프레임워크 DeviceAPI 연계서비스 (Flutter)")
				.description("Flutter 기반 표준프레임워크 DeviceAPI App / WEB Server")
				.version("5.1.0")
				.contact(new Contact().name("표준프레임워크 Email").email("egovframesupport@gmail.com"))
				.license(new License().name("Apache License Version 2.0").url("https://www.apache.org/licenses/LICENSE-2.0")));
	}

	@Bean
	GroupedOpenApi allApi() {
		return GroupedOpenApi.builder()
				.group("00. All Device API REST Service")
				.packagesToScan(API_PACKAGE)
				.build();
	}

	@Bean
	GroupedOpenApi acceleratorApi() {
		return group("01. Accelerator Guide Program Service", "/acl/**");
	}

	@Bean
	GroupedOpenApi compassApi() {
		return group("02. Compass Guide Program Service", "/cps/**");
	}

	@Bean
	GroupedOpenApi contactsApi() {
		return group("03. Contacts Guide Program Service", "/ctt/**");
	}

	@Bean
	GroupedOpenApi deviceApi() {
		return group("04. DeviceInfo Guide Program Service", "/dvc/**");
	}

	@Bean
	GroupedOpenApi fileReaderWriterApi() {
		return group("05. FileReaderWriter Guide Program Service", "/frw/**");
	}

	@Bean
	GroupedOpenApi gpsApi() {
		return group("06. GPS Guide Program Service", "/gps/**");
	}

	@Bean
	GroupedOpenApi interfaceApi() {
		return group("07. Interface Guide Program Service", "/itf/**");
	}

	@Bean
	GroupedOpenApi mediaApi() {
		return group("08. Media Guide Program Service", "/mda/**");
	}

	@Bean
	GroupedOpenApi networkApi() {
		return group("09. Network Guide Program Service", "/nwk/**");
	}

	@Bean
	GroupedOpenApi pushApi() {
		return group("10. PushNotifications Guide Program Service", "/pus/**");
	}

	@Bean
	GroupedOpenApi fileOpenerApi() {
		return group("11. FileOpener Guide Program Service", "/fop/**");
	}

	@Bean
	GroupedOpenApi socketApi() {
		return group("12. SocketIO Guide Program Service", "/ws/**");
	}

	@Bean
	GroupedOpenApi streamingMediaApi() {
		return group("13. StreamingMedia Guide Program Service", "/stm/**");
	}

	@Bean
	GroupedOpenApi barcodeScannerApi() {
		return group("14. BarcodeScanner Guide Program Service", "/bar/**");
	}

	@Bean
	GroupedOpenApi faceMeshApi() {
		return group("15. FaceMesh Guide Program Service", "/fms/**");
	}

	@Bean
	GroupedOpenApi iotApi() {
		return group("16. IoT MQTT Guide Program Service", "/iot/**");
	}

	@Bean
	GroupedOpenApi aiChatApi() {
		return group("17. AI Chat Guide Program Service", "/aic/**");
	}

	private static GroupedOpenApi group(String name, String path) {
		return GroupedOpenApi.builder()
				.group(name)
				.packagesToScan(API_PACKAGE)
				.pathsToMatch(path)
				.build();
	}
}
