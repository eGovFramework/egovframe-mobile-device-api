package egovframework.hyb.config;

import javax.sql.DataSource;

import org.apache.commons.dbcp2.BasicDataSource;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Primary;

@Configuration
public class EgovConfigDatasource {

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

	/**
	 * MySQL DataSource
	 * XML의 destroy-method="close"와 동일 (Spring Boot는 자동으로 close 메서드 인식)
	 */
	@Bean(name = "dataSource-mysql", destroyMethod = "close")
	public DataSource dataSourceMysql() {
		BasicDataSource dataSource = new BasicDataSource();
		dataSource.setDriverClassName(driverClassName);
		dataSource.setUrl(url);
		dataSource.setUsername(username);
		dataSource.setPassword(password);
		return dataSource;
	}

	/**
	 * Oracle DataSource
	 */
	@Bean(name = "dataSource-oracle", destroyMethod = "close")
	public DataSource dataSourceOracle() {
		BasicDataSource dataSource = new BasicDataSource();
		dataSource.setDriverClassName(driverClassName);
		dataSource.setUrl(url);
		dataSource.setUsername(username);
		dataSource.setPassword(password);
		return dataSource;
	}

	/**
	 * Altibase DataSource
	 */
	@Bean(name = "dataSource-altibase", destroyMethod = "close")
	public DataSource dataSourceAltibase() {
		BasicDataSource dataSource = new BasicDataSource();
		dataSource.setDriverClassName(driverClassName);
		dataSource.setUrl(url);
		dataSource.setUsername(username);
		dataSource.setPassword(password);
		return dataSource;
	}

	/**
	 * Tibero DataSource
	 */
	@Bean(name = "dataSource-tibero", destroyMethod = "close")
	public DataSource dataSourceTibero() {
		BasicDataSource dataSource = new BasicDataSource();
		dataSource.setDriverClassName(driverClassName);
		dataSource.setUrl(url);
		dataSource.setUsername(username);
		dataSource.setPassword(password);
		return dataSource;
	}

	/**
	 * Cubrid DataSource
	 */
	@Bean(name = "dataSource-cubrid", destroyMethod = "close")
	public DataSource dataSourceCubrid() {
		BasicDataSource dataSource = new BasicDataSource();
		dataSource.setDriverClassName(driverClassName);
		dataSource.setUrl(url);
		dataSource.setUsername(username);
		dataSource.setPassword(password);
		return dataSource;
	}

	/**
	 * Primary DataSource (Globals.DbType에 따라 동적으로 선택)
	 * XML의 alias name="dataSource-${Globals.DbType}" alias="dataSource"와 동일한 역할
	 */
	@Bean(name = "dataSource")
	@Primary
	public DataSource dataSource() {
		switch (dbType.toLowerCase()) {
			case "mysql":
				return dataSourceMysql();
			case "oracle":
				return dataSourceOracle();
			case "altibase":
				return dataSourceAltibase();
			case "tibero":
				return dataSourceTibero();
			case "cubrid":
				return dataSourceCubrid();
			default:
				throw new IllegalArgumentException("Unsupported database type: " + dbType);
		}
	}
}
