package egovframework.hyb.config;

import static org.assertj.core.api.Assertions.assertThat;

import java.lang.reflect.Proxy;
import java.util.ArrayList;
import java.util.List;

import javax.sql.DataSource;

import org.apache.ibatis.session.SqlSessionFactory;
import org.junit.jupiter.api.Test;
import org.springframework.test.util.ReflectionTestUtils;

class EgovConfigMapperFileDaoTest {

    /** application.properties 의 Globals.DbType 주석이 지원한다고 밝힌 DB 타입 */
    private static final List<String> DB_TYPES = List.of("mysql", "oracle", "altibase", "tibero", "cubrid");

    /** EgovFileDAO 가 호출하는 fileDAO 네임스페이스 구문 */
    private static final List<String> FILE_DAO_STATEMENTS = List.of(
            "fileDAO.selectFileDetailInfo",
            "fileDAO.insertFileDetailInfo",
            "fileDAO.countFileOwnershipByUuid",
            "fileDAO.countFileRegistration");

    @Test
    void 지원_대상_DbType마다_fileDAO_구문이_모두_등록된다() throws Exception {
        List<String> missing = new ArrayList<>();

        for (String dbType : DB_TYPES) {
            SqlSessionFactory sqlSessionFactory = sqlSessionFactory(dbType);
            for (String statement : FILE_DAO_STATEMENTS) {
                if (!sqlSessionFactory.getConfiguration().hasStatement(statement)) {
                    missing.add(dbType + " -> " + statement);
                }
            }
        }

        assertThat(missing).isEmpty();
    }

    private SqlSessionFactory sqlSessionFactory(String dbType) throws Exception {
        EgovConfigMapper egovConfigMapper = new EgovConfigMapper();
        ReflectionTestUtils.setField(egovConfigMapper, "dbType", dbType);
        return egovConfigMapper.sqlSessionFactory(unusedDataSource());
    }

    private DataSource unusedDataSource() {
        return (DataSource) Proxy.newProxyInstance(getClass().getClassLoader(),
                new Class<?>[] { DataSource.class }, (proxy, method, args) -> null);
    }
}
