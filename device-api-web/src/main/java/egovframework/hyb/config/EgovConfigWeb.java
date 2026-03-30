package egovframework.hyb.config;

import java.util.List;
import java.util.Properties;

import org.springframework.context.ApplicationContext;
import org.springframework.context.ApplicationContextAware;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Import;
import org.springframework.web.servlet.HandlerExceptionResolver;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;
import org.springframework.web.servlet.handler.SimpleMappingExceptionResolver;
import org.springframework.web.servlet.i18n.LocaleChangeInterceptor;
import org.springframework.web.servlet.i18n.SessionLocaleResolver;
import org.thymeleaf.spring6.SpringTemplateEngine;
import org.thymeleaf.spring6.templateresolver.SpringResourceTemplateResolver;
import org.thymeleaf.spring6.view.ThymeleafViewResolver;
import org.thymeleaf.templatemode.TemplateMode;

@Configuration
@Import({
		EgovConfigAspect.class,
		EgovConfigCommon.class,
		EgovConfigDatasource.class,
		EgovConfigIdGeneration.class,
		EgovConfigMapper.class,
		EgovConfigProperties.class,
		EgovConfigTransaction.class,
		EgovConfigValidation.class,
		egovframework.hyb.mbl.websocket.config.WebsocketConfig.class
})
public class EgovConfigWeb implements WebMvcConfigurer, ApplicationContextAware {

	private ApplicationContext applicationContext;

	public void setApplicationContext(final ApplicationContext applicationContext) {
		this.applicationContext = applicationContext;
	}

	@Bean
	public SpringResourceTemplateResolver templateResolver() {
		SpringResourceTemplateResolver templateResolver = new SpringResourceTemplateResolver();
		templateResolver.setApplicationContext(this.applicationContext);
		templateResolver.setPrefix("classpath:/templates/thymeleaf/");
		templateResolver.setSuffix(".html");
		templateResolver.setTemplateMode(TemplateMode.HTML);
		templateResolver.setCacheable(true);
		return templateResolver;
	}

	@Bean
	public SpringTemplateEngine templateEngine() {
		SpringTemplateEngine templateEngine = new SpringTemplateEngine();
		templateEngine.setTemplateResolver(templateResolver());
		templateEngine.setEnableSpringELCompiler(true);
		return templateEngine;
	}

	@Bean
	public ThymeleafViewResolver thymeleafViewResolver() {
		ThymeleafViewResolver viewResolver = new ThymeleafViewResolver();
		viewResolver.setCharacterEncoding("UTF-8");
		viewResolver.setTemplateEngine(templateEngine());
		return viewResolver;
	}

	@Override
	public void addResourceHandlers(ResourceHandlerRegistry registry) {
		registry.addResourceHandler("/css/**").addResourceLocations("classpath:/static/css/");
        registry.addResourceHandler("/images/**").addResourceLocations("classpath:/static/images/");
        registry.addResourceHandler("/js/**").addResourceLocations("classpath:/static/js/");

        // favicon.ico 처리를 위한 빈 핸들러 (404 오류 방지)
        registry.addResourceHandler("/favicon.ico")
        		.addResourceLocations("classpath:/static/")
        		.setCachePeriod(3600);
        
        // .well-known 경로도 처리 (Chrome DevTools 자동 요청)
        registry.addResourceHandler("/.well-known/**")
        		.addResourceLocations("classpath:/static/.well-known/");
	}

	@Bean
	public SessionLocaleResolver localeResolver() {
		return new SessionLocaleResolver();
	}

	@Bean
	public LocaleChangeInterceptor localeChangeInterceptor() {
		LocaleChangeInterceptor interceptor = new LocaleChangeInterceptor();
		interceptor.setParamName("language");
		return interceptor;
	}

	@Override
	public void addInterceptors(InterceptorRegistry registry) {
		registry.addInterceptor(localeChangeInterceptor());
	}

	@Override
	public void configureHandlerExceptionResolvers(List<HandlerExceptionResolver> resolvers) {
		Properties prop = new Properties();
		prop.setProperty("org.springframework.dao.DataAccessException", "error");
		prop.setProperty("org.springframework.transaction.TransactionException", "error");
		prop.setProperty("org.egovframe.rte.fdl.cmmn.exception.EgovBizException", "error");
		prop.setProperty("org.springframework.security.AccessDeniedException", "error");
		prop.setProperty("java.lang.Throwable", "error");

		Properties statusCode = new Properties();
		statusCode.setProperty("error", "400");
		statusCode.setProperty("error", "500");

		SimpleMappingExceptionResolver smer = new SimpleMappingExceptionResolver();
		smer.setDefaultErrorView("error");
		smer.setExceptionMappings(prop);
		smer.setStatusCodes(statusCode);
		resolvers.add(smer);
	}

}
