package egovframework.hyb.config;

import java.util.ArrayList;
import java.util.List;

import javax.sql.DataSource;

import org.apache.ibatis.session.SqlSessionFactory;
import org.mybatis.spring.SqlSessionFactoryBean;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.io.Resource;
import org.springframework.core.io.support.PathMatchingResourcePatternResolver;

@Configuration
public class EgovConfigMapper {

	@Value("${Globals.DbType}")
	private String dbType;

	@Bean(name = "sqlSession")
	SqlSessionFactory sqlSessionFactory(@Qualifier("dataSource") DataSource dataSource) throws Exception {
		PathMatchingResourcePatternResolver pmrpr = new PathMatchingResourcePatternResolver();
		SqlSessionFactoryBean sqlSessionFactoryBean = new SqlSessionFactoryBean();
		sqlSessionFactoryBean.setDataSource(dataSource);
		sqlSessionFactoryBean.setConfigLocation(pmrpr.getResource("classpath:/egovframework/hyb/mapper/mapper-config.xml"));
		
		// *_SQL_{DbType}.xml 과 DB 구분이 없는 매퍼만 로드
		String dbSuffix = "_SQL_" + dbType.toLowerCase() + ".xml";
		List<Resource> mapperResources = new ArrayList<>();
		for (Resource resource : pmrpr.getResources("classpath:egovframework/hyb/mapper/mbl/**/*.xml")) {
			String filename = resource.getFilename();
			if (filename != null && (filename.endsWith(dbSuffix) || !filename.contains("_SQL_"))) {
				mapperResources.add(resource);
			}
		}

		sqlSessionFactoryBean.setMapperLocations(mapperResources.toArray(new Resource[0]));
		return sqlSessionFactoryBean.getObject();
	}

}
