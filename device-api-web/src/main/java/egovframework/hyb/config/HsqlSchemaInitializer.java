package egovframework.hyb.config;

import java.sql.ResultSet;

import javax.sql.DataSource;

import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.io.ClassPathResource;
import org.springframework.jdbc.datasource.init.DataSourceInitializer;
import org.springframework.jdbc.datasource.init.ResourceDatabasePopulator;

/**
 * HSQL 기동 시 DATABASE/hsql 의 DDL, 기초데이터를 적용한다.
 * 스크립트가 테이블을 DROP 후 생성하므로 스키마가 없을 때(최초 기동)만 실행한다.
 * 초기화하려면 HSQL 데이터 디렉터리(./data/hsql)를 지운다.
 */
@Configuration
@ConditionalOnProperty(name = "Globals.DbType", havingValue = "hsql")
public class HsqlSchemaInitializer {

	private static final String MARKER_TABLE = "COMTECOPSEQ";

	@Bean
	DataSourceInitializer hsqlDataSourceInitializer(DataSource dataSource) {
		ResourceDatabasePopulator populator = new ResourceDatabasePopulator(
				new ClassPathResource("db/hsql/all_deviceapi_ddl_hsql.sql"),
				new ClassPathResource("db/hsql/all_deviceapi_data_hsql.sql"));
		populator.setSqlScriptEncoding("UTF-8");

		DataSourceInitializer initializer = new DataSourceInitializer();
		initializer.setDataSource(dataSource);
		initializer.setDatabasePopulator(connection -> {
			try (ResultSet rs = connection.getMetaData().getTables(null, null, MARKER_TABLE, null)) {
				if (!rs.next()) {
					populator.populate(connection);
				}
			}
		});
		return initializer;
	}
}
