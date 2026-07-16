package egovframework.hyb.utils;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;

import org.junit.jupiter.api.Test;

class EgovWebUtilTest {

    @Test
    void clearXSSMinimum_null이나_공백이면_빈문자열을_반환한다() {
        assertThat(EgovWebUtil.clearXSSMinimum(null)).isEqualTo("");
        assertThat(EgovWebUtil.clearXSSMinimum("   ")).isEqualTo("");
    }

    @Test
    void clearXSSMinimum_스크립트_태그와_특수문자를_이스케이프한다() {
        String result = EgovWebUtil.clearXSSMinimum("<script>alert('xss')</script>");
        assertThat(result).isEqualTo("&lt;script&gt;alert(&#39;xss&#39;)&lt;/script&gt;");
    }

    @Test
    void clearXSSMaximum_이스케이프된_값에_대해_추가_치환을_적용한다() {
        String result = EgovWebUtil.clearXSSMaximum("<img src=x onerror=alert(1)>");
        assertThat(result).isEqualTo("&lt;img src=x onerror=alert(1)&gt;");
    }

    @Test
    void clearXSS_퍼센트_인코딩된_꺾쇠도_이스케이프한다() {
        assertThat(EgovWebUtil.clearXSS("%3Cscript%3E")).isEqualTo("&lt;script&gt;");
        assertThat(EgovWebUtil.clearXSS("<script>")).isEqualTo("&lt;script&gt;");
    }

    @Test
    void filePathBlackList_단일인자는_점점을_모두_제거한다() {
        assertThat(EgovWebUtil.filePathBlackList(null)).isEqualTo("");
        assertThat(EgovWebUtil.filePathBlackList("../../etc/passwd")).isEqualTo("//etc/passwd");
    }

    @Test
    void filePathBlackList_basePath가_없으면_예외를_던진다() {
        assertThatThrownBy(() -> EgovWebUtil.filePathBlackList("x", null))
                .isInstanceOf(SecurityException.class)
                .hasMessage("base path is empty.");
        assertThatThrownBy(() -> EgovWebUtil.filePathBlackList("x", ""))
                .isInstanceOf(SecurityException.class)
                .hasMessage("base path is empty.");
    }

    @Test
    void filePathBlackList_basePath가_루트이면_예외를_던진다() {
        assertThatThrownBy(() -> EgovWebUtil.filePathBlackList("x", "/"))
                .isInstanceOf(SecurityException.class)
                .hasMessage("base path does not allow Root.");
    }

    @Test
    void filePathBlackList_basePath와_결합한_뒤_경로탐색문자를_제거한다() {
        String result = EgovWebUtil.filePathBlackList("../secret.txt", "/data/uploads");
        assertThat(result).isEqualTo("/data/uploads/secret.txt");
    }

    @Test
    void filePathReplaceAll_슬래시_역슬래시_점점_앰퍼샌드를_제거한다() {
        assertThat(EgovWebUtil.filePathReplaceAll(null)).isEqualTo("");
        assertThat(EgovWebUtil.filePathReplaceAll("../../etc/passwd")).isEqualTo("etcpasswd");
    }

    @Test
    void fileInjectPathReplaceAll_슬래시와_점으로_시작하는_두글자를_제거한다() {
        assertThat(EgovWebUtil.fileInjectPathReplaceAll(null)).isEqualTo("");
        assertThat(EgovWebUtil.fileInjectPathReplaceAll("../../etc/passwd.txt")).isEqualTo("etcpasswdxt");
    }

    @Test
    void isIPAddress_점으로_구분된_숫자_네덩이_형식만_인식한다() {
        assertThat(EgovWebUtil.isIPAddress("192.168.0.1")).isTrue();
        assertThat(EgovWebUtil.isIPAddress("not-an-ip")).isFalse();
        assertThat(EgovWebUtil.isIPAddress("192.168.0.1abc")).isFalse();
    }

    @Test
    void removeCRLF_개행문자를_제거한다() {
        assertThat(EgovWebUtil.removeCRLF("line1\r\nline2")).isEqualTo("line1line2");
    }

    @Test
    void removeSQLInjectionRisk_공백과_SQL_특수문자를_제거한다() {
        assertThat(EgovWebUtil.removeSQLInjectionRisk("1' OR '1'='1' --")).isEqualTo("1'OR'1'='1'");
    }

    @Test
    void removeOSCmdRisk_공백과_쉘_특수문자를_제거한다() {
        String result = EgovWebUtil.removeOSCmdRisk("ls -la; rm -rf / | mail attacker@example.com");
        assertThat(result).isEqualTo("ls-larm-rf/mailattacker@example.com");
    }
}
