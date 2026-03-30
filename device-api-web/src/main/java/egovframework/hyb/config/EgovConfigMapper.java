package egovframework.hyb.config;

import java.util.ArrayList;
import java.util.List;

import javax.sql.DataSource;

import org.apache.ibatis.session.SqlSessionFactory;
import org.mybatis.spring.SqlSessionFactoryBean;
import org.mybatis.spring.SqlSessionTemplate;
import org.mybatis.spring.annotation.MapperScan;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.io.Resource;
import org.springframework.core.io.support.PathMatchingResourcePatternResolver;

@Configuration
@MapperScan(basePackages="egovframework.hyb")
public class EgovConfigMapper {

	@Value("${Globals.DbType}")
	private String dbType;

	@Bean(name = "sqlSession")
	public SqlSessionFactory sqlSessionFactory(@Qualifier("dataSource") DataSource dataSource) throws Exception {
		PathMatchingResourcePatternResolver pmrpr = new PathMatchingResourcePatternResolver();
		SqlSessionFactoryBean sqlSessionFactoryBean = new SqlSessionFactoryBean();
		sqlSessionFactoryBean.setDataSource(dataSource);
		sqlSessionFactoryBean.setConfigLocation(pmrpr.getResource("classpath:/egovframework/hyb/mapper/mapper-config.xml"));
		
		// 데이터베이스 타입에 해당하는 매퍼 파일만 로드
		String dbTypeLower = dbType.toLowerCase();
		List<Resource> mapperResources = new ArrayList<>();
		
		// 모든 매퍼 파일을 가져온 후 데이터베이스 타입에 맞는 것만 필터링
		Resource[] allMappers = pmrpr.getResources("classpath:egovframework/hyb/mapper/mbl/**/*.xml");
		
		for (Resource resource : allMappers) {
			String filename = resource.getFilename();
			// 데이터베이스 타입이 파일명에 포함된 경우만 추가
			// 예: *_SQL_mysql.xml, *_SQL_oracle.xml 등
			if (filename != null && filename.contains("_SQL_" + dbTypeLower)) {
				mapperResources.add(resource);
			} else if (filename != null && !filename.contains("_SQL_")) {
				// _SQL_ 패턴이 없는 일반 매퍼 파일은 모두 포함
				mapperResources.add(resource);
			}
		}
		
		sqlSessionFactoryBean.setMapperLocations(mapperResources.toArray(new Resource[0]));
		return sqlSessionFactoryBean.getObject();
	}

	@Bean(name = "sqlSessionTemplate")
	public SqlSessionTemplate sqlSessionTemplate(SqlSessionFactory sqlSessionFactory) {
		return new SqlSessionTemplate(sqlSessionFactory);
	}

}
