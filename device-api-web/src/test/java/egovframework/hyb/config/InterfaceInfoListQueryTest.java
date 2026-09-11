package egovframework.hyb.config;

import static org.assertj.core.api.Assertions.assertThat;

import java.lang.reflect.Proxy;
import java.util.ArrayList;
import java.util.List;

import javax.sql.DataSource;

import org.apache.ibatis.mapping.BoundSql;
import org.apache.ibatis.mapping.ParameterMapping;
import org.apache.ibatis.session.SqlSessionFactory;
import org.junit.jupiter.api.Test;
import org.springframework.test.util.ReflectionTestUtils;

import egovframework.hyb.mbl.itf.service.InterfaceAPIVO;

class InterfaceInfoListQueryTest {

    /** application.properties 의 Globals.DbType 주석이 지원한다고 밝힌 DB 타입 */
    private static final List<String> DB_TYPES = List.of("mysql", "oracle", "altibase", "tibero", "cubrid");

    @Test
    void 목록조회는_상세조회와_같이_아이디와_비밀번호를_모두_조건으로_쓴다() throws Exception {
        List<String> withoutPassword = new ArrayList<>();

        for (String dbType : DB_TYPES) {
            List<String> parameters = parametersOf(dbType, "interfaceAPIDAO.selectInterfaceInfoList");
            if (!parameters.contains("userPw")) {
                withoutPassword.add(dbType + " -> " + parameters);
            }
        }

        assertThat(withoutPassword).isEmpty();
    }

    private List<String> parametersOf(String dbType, String statement) throws Exception {
        EgovConfigMapper egovConfigMapper = new EgovConfigMapper();
        ReflectionTestUtils.setField(egovConfigMapper, "dbType", dbType);
        SqlSessionFactory sqlSessionFactory = egovConfigMapper.sqlSessionFactory(unusedDataSource());

        BoundSql boundSql = sqlSessionFactory.getConfiguration()
                .getMappedStatement(statement)
                .getBoundSql(new InterfaceAPIVO());

        List<String> parameters = new ArrayList<>();
        for (ParameterMapping mapping : boundSql.getParameterMappings()) {
            parameters.add(mapping.getProperty());
        }
        return parameters;
    }

    private DataSource unusedDataSource() {
        return (DataSource) Proxy.newProxyInstance(getClass().getClassLoader(),
                new Class<?>[] { DataSource.class },
                (proxy, method, args) -> {
                    throw new UnsupportedOperationException("이 테스트는 매퍼 등록만 확인한다");
                });
    }
}
