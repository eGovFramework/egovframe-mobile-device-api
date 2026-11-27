package egovframework.hyb.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.autoconfigure.security.SecurityProperties;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.Customizer;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.provisioning.InMemoryUserDetailsManager;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.util.StringUtils;

/**
 * app.security.required 가 false 이면 인증 없이 호출하고, true 이면 HTTP Basic을 요구한다.
 */
@Configuration
@EnableWebSecurity
public class SecurityConfig {

	@Value("${app.security.required:true}")
	private boolean securityRequired;

	@Bean
	PasswordEncoder passwordEncoder() {
		return new BCryptPasswordEncoder();
	}

	/**
	 * spring.security.user.* 계정. PasswordEncoder 빈이 있으면 Boot 기본 계정은 평문으로 저장돼
	 * BCrypt 비교에 실패하므로 직접 인코딩해 등록한다.
	 */
	@Bean
	UserDetailsService userDetailsService(SecurityProperties properties, PasswordEncoder passwordEncoder) {
		SecurityProperties.User user = properties.getUser();
		if (!StringUtils.hasText(user.getName()) || !StringUtils.hasText(user.getPassword())) {
			if (securityRequired) {
				throw new IllegalStateException(
						"app.security.required=true 이면 spring.security.user.name 과 spring.security.user.password 가 필요합니다.");
			}
			return new InMemoryUserDetailsManager();
		}
		return new InMemoryUserDetailsManager(User.withUsername(user.getName())
				.password(passwordEncoder.encode(user.getPassword()))
				.roles(user.getRoles().toArray(new String[0]))
				.build());
	}

	@Bean
	SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
		http.csrf(csrf -> csrf.disable());

		if (!securityRequired) {
			http.httpBasic(basic -> basic.disable())
					.formLogin(form -> form.disable())
					.authorizeHttpRequests(auth -> auth.anyRequest().permitAll());
			return http.build();
		}

		http.sessionManagement(session -> session.sessionCreationPolicy(SessionCreationPolicy.IF_REQUIRED))
				.httpBasic(Customizer.withDefaults())
				.authorizeHttpRequests(auth -> auth
						.requestMatchers(
								"/css/**",
								"/fonts/**",
								"/images/**",
								"/img/**",
								"/js/**",
								"/favicon.ico",
								"/error")
						.permitAll()
						.anyRequest()
						.authenticated());
		return http.build();
	}
}
