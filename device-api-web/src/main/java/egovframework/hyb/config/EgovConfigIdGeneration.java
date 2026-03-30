package egovframework.hyb.config;

import javax.sql.DataSource;

import org.egovframe.rte.fdl.idgnr.impl.EgovTableIdGnrServiceImpl;
import org.egovframe.rte.fdl.idgnr.impl.strategy.EgovIdGnrStrategyImpl;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class EgovConfigIdGeneration {

	@Bean
	public EgovIdGnrStrategyImpl mixPrefixSample() {
		EgovIdGnrStrategyImpl egovIdGnrStrategyImpl = new EgovIdGnrStrategyImpl();
		egovIdGnrStrategyImpl.setPrefix("SAMPLE-");
		egovIdGnrStrategyImpl.setCipers(5);
		egovIdGnrStrategyImpl.setFillChar('0');
		return egovIdGnrStrategyImpl;
	}

	@Bean(destroyMethod="destroy")
	public EgovTableIdGnrServiceImpl egovIdGnrService(@Qualifier("dataSource") DataSource dataSource) {
		EgovTableIdGnrServiceImpl egovTableIdGnrServiceImpl = new EgovTableIdGnrServiceImpl();
		egovTableIdGnrServiceImpl.setDataSource(dataSource);
		egovTableIdGnrServiceImpl.setStrategy(mixPrefixSample());
		egovTableIdGnrServiceImpl.setBlockSize(10);
		egovTableIdGnrServiceImpl.setTable("IDS");
		egovTableIdGnrServiceImpl.setTableName("SAMPLE");
		return egovTableIdGnrServiceImpl;	
	}
	
	// FILEUPLOAD IDGENERATION
	@Bean
	public EgovIdGnrStrategyImpl filePrefix() {
		EgovIdGnrStrategyImpl egovIdGnrStrategyImpl = new EgovIdGnrStrategyImpl();
		egovIdGnrStrategyImpl.setCipers(10);
		return egovIdGnrStrategyImpl;
	}
	
	@Bean(name= "egovFileIdGnrService", destroyMethod = "destroy")
	public EgovTableIdGnrServiceImpl egovFileIdGnrService(@Qualifier("dataSource") DataSource dataSource) {
		EgovTableIdGnrServiceImpl egovTableIdGnrServiceImpl = new EgovTableIdGnrServiceImpl();
		egovTableIdGnrServiceImpl.setDataSource(dataSource);
		egovTableIdGnrServiceImpl.setStrategy(filePrefix());
		egovTableIdGnrServiceImpl.setBlockSize(10);
		egovTableIdGnrServiceImpl.setTable("COMTECOPSEQ");
		egovTableIdGnrServiceImpl.setTableName("FILE");
		return egovTableIdGnrServiceImpl;
		
	}

}
