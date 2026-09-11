package egovframework.hyb.mbl.itf.web;

import static org.assertj.core.api.Assertions.assertThat;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.ui.ExtendedModelMap;
import org.springframework.validation.BeanPropertyBindingResult;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.support.SimpleSessionStatus;

import egovframework.hyb.mbl.itf.service.EgovInterfaceAPIService;
import egovframework.hyb.mbl.itf.service.InterfaceAPIVO;

class EgovInterfaceAPIControllerTest {

    private StubInterfaceAPIService egovInterfaceAPIService;

    private EgovInterfaceAPIController controller;

    @BeforeEach
    void setUp() {
        egovInterfaceAPIService = new StubInterfaceAPIService();
        controller = new EgovInterfaceAPIController(egovInterfaceAPIService);
    }

    @Test
    void insertInterfaceInfo_같은_아이디를_다른_비밀번호로_등록하면_거부한다() {
        assertThat(insertInterfaceInfo("alice", "hash-aaaaaa").get("resultState")).isEqualTo("OK");

        Map<String, Object> response = insertInterfaceInfo("alice", "hash-bbbbbb");

        assertThat(response.get("resultState")).isEqualTo("FAIL");
        assertThat(egovInterfaceAPIService.selectInterfaceInfoListTotCnt(searchVO("alice"))).isEqualTo(1);
    }

    @Test
    void insertInterfaceInfo_다른_아이디는_그대로_등록된다() {
        insertInterfaceInfo("alice", "hash-aaaaaa");

        assertThat(insertInterfaceInfo("bob", "hash-bbbbbb").get("resultState")).isEqualTo("OK");
        assertThat(egovInterfaceAPIService.selectInterfaceInfoListTotCnt(searchVO("bob"))).isEqualTo(1);
    }

    private Map<String, Object> insertInterfaceInfo(String userId, String userPw) {
        InterfaceAPIVO interfaceVO = searchVO(userId);
        interfaceVO.setUserPw(userPw);
        interfaceVO.setEmails(userId + "@example.com");
        interfaceVO.setUuid("uuid-" + userId);
        BindingResult bindingResult = new BeanPropertyBindingResult(interfaceVO, "interfaceVO");
        return controller
                .insertInterfaceInfo(interfaceVO, bindingResult, new ExtendedModelMap(), new SimpleSessionStatus())
                .getBody();
    }

    private InterfaceAPIVO searchVO(String userId) {
        InterfaceAPIVO vo = new InterfaceAPIVO();
        vo.setUserId(userId);
        return vo;
    }

    /** INTERFACE_EGOV 테이블 대신 매퍼 구문과 같은 조건으로 조회하는 스텁 */
    private static class StubInterfaceAPIService implements EgovInterfaceAPIService {

        private final List<InterfaceAPIVO> rows = new ArrayList<>();

        @Override
        public int insertInterfaceInfo(InterfaceAPIVO vo) {
            rows.add(vo);
            return 1;
        }

        /** selectInterfaceInfo : WHERE USER_ID = #{userId} AND USER_PW = #{userPw} */
        @Override
        public InterfaceAPIVO selectInterfaceInfo(InterfaceAPIVO vo) {
            return rows.stream()
                    .filter(row -> row.getUserId().equals(vo.getUserId()) && row.getUserPw().equals(vo.getUserPw()))
                    .findFirst()
                    .orElse(null);
        }

        /** selectInterfaceInfoListTotCnt : WHERE USER_ID = #{userId} */
        @Override
        public int selectInterfaceInfoListTotCnt(InterfaceAPIVO searchVO) {
            return (int) rows.stream()
                    .filter(row -> row.getUserId().equals(searchVO.getUserId()))
                    .count();
        }

        @Override
        public int updateInterfaceInfo(InterfaceAPIVO vo) {
            throw new UnsupportedOperationException();
        }

        @Override
        public int deleteInterfaceInfo(InterfaceAPIVO vo) {
            throw new UnsupportedOperationException();
        }

        @Override
        public List<InterfaceAPIVO> selectInterfaceInfoList(InterfaceAPIVO searchVO) {
            throw new UnsupportedOperationException();
        }
    }
}
