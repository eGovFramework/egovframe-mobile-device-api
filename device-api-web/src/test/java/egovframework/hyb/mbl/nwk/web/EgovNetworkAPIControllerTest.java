package egovframework.hyb.mbl.nwk.web;

import static org.assertj.core.api.Assertions.assertThat;

import java.util.Map;

import org.junit.jupiter.api.Test;
import org.mockito.Mockito;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.support.PropertySourcesPlaceholderConfigurer;
import org.springframework.ui.ModelMap;

import egovframework.hyb.config.EgovConfigProperties;
import egovframework.hyb.mbl.nwk.service.EgovNetworkAPIService;

@SpringBootTest(classes = { EgovConfigProperties.class, EgovNetworkAPIController.class,
		EgovNetworkAPIControllerTest.TestConfig.class }, properties = "Globals.serverContext=http://127.0.0.1:9700/")
class EgovNetworkAPIControllerTest {

	@Autowired
	private EgovNetworkAPIController egovNetworkAPIController;

	@Test
	@SuppressWarnings("unchecked")
	void htmlLoad_는_설정된_서버_주소를_반환한다() throws Exception {
		Map<String, Object> response = (Map<String, Object>) egovNetworkAPIController.htmlLoad(new ModelMap()).getBody();

		assertThat(response.get("serverUrl")).isEqualTo("http://127.0.0.1:9700/");
	}

	@Configuration
	static class TestConfig {

		@Bean
		static PropertySourcesPlaceholderConfigurer propertySourcesPlaceholderConfigurer() {
			return new PropertySourcesPlaceholderConfigurer();
		}

		@Bean(name = "EgovNetworkAPIService")
		EgovNetworkAPIService egovNetworkAPIService() {
			return Mockito.mock(EgovNetworkAPIService.class);
		}
	}

}
