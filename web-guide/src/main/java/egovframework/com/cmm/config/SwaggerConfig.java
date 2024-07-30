package egovframework.com.cmm.config;
import static springfox.documentation.builders.PathSelectors.regex;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.EnableWebMvc;

import springfox.documentation.builders.ApiInfoBuilder;
import springfox.documentation.builders.PathSelectors;
import springfox.documentation.service.ApiInfo;
import springfox.documentation.spi.DocumentationType;
import springfox.documentation.spring.web.plugins.Docket;
import springfox.documentation.swagger2.annotations.EnableSwagger2;

@Configuration
@EnableSwagger2
@EnableWebMvc
//@ComponentScan("egovframework")
public class SwaggerConfig {

    @Bean
    public Docket newsApiAll() {
        return new Docket(DocumentationType.SWAGGER_2)
                .groupName("00. All Device API REST Service")
                .apiInfo(apiInfo())
                .select()
                .paths(PathSelectors.any())
                .build();
    }
	
    @Bean
    public Docket newsApiAccelerator() {
        return new Docket(DocumentationType.SWAGGER_2)
                .groupName("01. Accelerator Guide Program Service")
                .apiInfo(apiInfo())
                .select()
                .paths(regex("/acl.*"))
                //.paths(PathSelectors.any())
                .build();
    }

    @Bean
    public Docket newsApiCamera() {
        return new Docket(DocumentationType.SWAGGER_2)
                .groupName("02. Camera Guide Program Service")
                .apiInfo(apiInfo())
                .select()
                .paths(regex("/cmr.*"))
                .build();
    }

    @Bean
    public Docket newsApiCompass() {
        return new Docket(DocumentationType.SWAGGER_2)
                .groupName("03. Compass Guide Program Service")
                .apiInfo(apiInfo())
                .select()
                .paths(regex("/cps.*"))
                .build();
    }

    @Bean
    public Docket newsApiContacts() {
        return new Docket(DocumentationType.SWAGGER_2)
                .groupName("04. Contacts Guide Program Service")
                .apiInfo(apiInfo())
                .select()
                .paths(regex("/ctt.*"))
                .build();
    }

    @Bean
    public Docket newsApiDeviceInfo() {
        return new Docket(DocumentationType.SWAGGER_2)
                .groupName("05. DeviceInfo Guide Program Service")
                .apiInfo(apiInfo())
                .select()
                .paths(regex("/dvc.*"))
                .build();
    }

    @Bean
    public Docket newsApiFileReaderWriter() {
        return new Docket(DocumentationType.SWAGGER_2)
                .groupName("06. FileReaderWriter Guide Program Service")
                .apiInfo(apiInfo())
                .select()
                .paths(regex("/frw.*"))
                .build();
    }

    @Bean
    public Docket newsApiFileGPS() {
        return new Docket(DocumentationType.SWAGGER_2)
                .groupName("07. GPS Guide Program Service")
                .apiInfo(apiInfo())
                .select()
                .paths(regex("/gps.*"))
                .build();
    }

    @Bean
    public Docket newsApiInterface() {
        return new Docket(DocumentationType.SWAGGER_2)
                .groupName("08. Interface Guide Program Service")
                .apiInfo(apiInfo())
                .select()
                .paths(regex("/itf.*"))
                .build();
    }

    @Bean
    public Docket newsApiMedia () {
        return new Docket(DocumentationType.SWAGGER_2)
                .groupName("09. Media Guide Program Service")
                .apiInfo(apiInfo())
                .select()
                .paths(regex("/mda.*"))
                .build();
    }

    @Bean
    public Docket newsApiNetwork () {
        return new Docket(DocumentationType.SWAGGER_2)
                .groupName("10. Network Guide Program Service")
                .apiInfo(apiInfo())
                .select()
                .paths(regex("/nwk.*"))
                .build();
    }

    @Bean
    public Docket newsApiVibrator () {
        return new Docket(DocumentationType.SWAGGER_2)
                .groupName("11. Vibrator Guide Program Service")
                .apiInfo(apiInfo())
                .select()
                .paths(regex("/vbr.*"))
                .build();
    }

    @Bean
    public Docket newsApiPushNotifications () {
        return new Docket(DocumentationType.SWAGGER_2)
                .groupName("12. PushNotifications Guide Program Service")
                .apiInfo(apiInfo())
                .select()
                .paths(regex("/pus.*"))
                .build();
    }

    @Bean
    public Docket newsApiFileOpener () {
        return new Docket(DocumentationType.SWAGGER_2)
                .groupName("13. FileOpener Guide Program Service")
                .apiInfo(apiInfo())
                .select()
                .paths(regex("/fop.*"))
                .build();
    }

    @Bean
    public Docket newsApiStreamingMedia () {
        return new Docket(DocumentationType.SWAGGER_2)
                .groupName("14. StreamingMedia Guide Program Service")
                .apiInfo(apiInfo())
                .select()
                .paths(regex("/stm.*"))
                .build();
    }

    @Bean
    public Docket newsApiBarcodescanner () {
        return new Docket(DocumentationType.SWAGGER_2)
                .groupName("15. Barcodescanner Guide Program Service")
                .apiInfo(apiInfo())
                .select()
                .paths(regex("/bar.*"))
                .build();
    }

    @Bean
    public Docket newsApiWebResourceUpdate () {
        return new Docket(DocumentationType.SWAGGER_2)
                .groupName("16. WebResourceUpdate Guide Program Service")
                .apiInfo(apiInfo())
                .select()
                .paths(regex("/upd.*"))
                .build();
    }
    
    @Bean
    public Docket newsApiJailbreakDetection () {
        return new Docket(DocumentationType.SWAGGER_2)
                .groupName("17. JailbreakDetection Guide Program Service")
                .apiInfo(apiInfo())
                .select()
                .paths(regex("/jai.*"))
                .build();
    }
    
    private ApiInfo apiInfo() {
        return new ApiInfoBuilder()
                .title("표준프레임워크 DeviceAPI 연계서비스 (Hybrid App)")
                .description("표준프레임워크 하이브리드앱 실행환경  - iOS / Android 하이브리드앱 Rest 서비스")
                .termsOfServiceUrl("https://www.egovframe.go.kr/wiki/doku.php?id=egovframework:hyb:gate_page")
                .license("Apache License Version 2.0")
                .licenseUrl("https://www.egovframe.go.kr")
                .version("3.10")
                .build();
    }

}