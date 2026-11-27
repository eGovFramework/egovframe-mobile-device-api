package egovframework.hyb.config;

import java.util.Locale;
import java.util.Set;

import javax.sql.DataSource;

import org.apache.commons.dbcp2.BasicDataSource;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

/**
 * DataSource 설정. 접속 정보는 Globals.* 프로퍼티에서 읽는다.
 */
@Configuration
public class EgovConfigDatasource {

	/** 매퍼(*_SQL_{DbType}.xml)가 있는 DB */
	private static final Set<String> SUPPORTED_DB_TYPES = Set.of("hsql", "mysql", "oracle", "altibase", "tibero", "cubrid");

	@Value("${Globals.DbType}")
	private String dbType;

	@Value("${Globals.DriverClassName}")
	private String driverClassName;

	@Value("${Globals.Url}")
	private String url;

	@Value("${Globals.UserName}")
	private String username;

	@Value("${Globals.Password}")
	private String password;

	@Bean(name = "dataSource", destroyMethod = "close")
	DataSource dataSource() {
		if (!SUPPORTED_DB_TYPES.contains(dbType.toLowerCase(Locale.ROOT))) {
			throw new IllegalArgumentException("Unsupported database type: " + dbType);
		}
		BasicDataSource dataSource = new BasicDataSource();
		dataSource.setDriverClassName(driverClassName);
		dataSource.setUrl(url);
		dataSource.setUsername(username);
		dataSource.setPassword(password);
		return dataSource;
	}
}
