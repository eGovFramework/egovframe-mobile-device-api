package egovframework.hyb.utils;

import static org.assertj.core.api.Assertions.assertThat;

import java.io.File;
import java.lang.reflect.Proxy;
import java.nio.file.Path;
import java.util.List;
import java.util.concurrent.atomic.AtomicInteger;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.io.TempDir;
import org.springframework.mock.web.MockMultipartFile;
import org.springframework.test.util.ReflectionTestUtils;
import org.springframework.web.multipart.MultipartFile;

import org.egovframe.rte.fdl.idgnr.EgovIdGnrService;

/**
 * 서로 다른 업로드 요청이 같은 초에 들어와도 저장 파일이 덮어써지지 않는지 검증한다.
 *
 * <p>저장명은 {@code File_<타임스탬프>_<번호>} 형식인데 타임스탬프가 초 단위
 * ({@code yyyyMMddhhmmss})다. 수정 전에는 뒤에 붙는 번호가 요청마다 1부터 다시 세는
 * 지역 변수여서, 두 요청이 같은 초에 각자 첫 파일을 올리면 이름이 같아졌다.
 * 저장은 존재 확인 없이 {@code new FileOutputStream(...)} 으로 하므로 뒤엣것이
 * 앞엣것을 지웠고, 파일 정보는 두 건 다 저장돼 DB 두 행이 같은 파일 하나를 가리켰다.
 *
 * <p>같은 초를 노려 스레드를 다투게 하는 대신, 두 요청을 연달아 호출하고 두 저장명이
 * 같은 타임스탬프를 갖는 경우만 검사한다. 초가 바뀌면 전제가 성립하지 않으므로
 * 그때는 다시 시도한다.
 */
class EgovFileMngUtilUploadNameTest {

    @TempDir
    Path storage;

    @Test
    void 같은_초에_들어온_두_요청의_저장파일이_서로_덮어쓰지_않는다() throws Exception {
        for (int attempt = 0; attempt < 50; attempt++) {
            EgovFileMngUtil util = newUtil();

            String firstName = upload(util, "report.pdf");
            String secondName = upload(util, "report.pdf");

            if (!timestampOf(firstName).equals(timestampOf(secondName))) {
                continue; // 초가 넘어갔다. 전제가 성립하지 않으므로 다시 시도한다.
            }

            assertThat(secondName)
                    .as("같은 초에 올린 두 파일이 같은 저장명을 받았다: %s", firstName)
                    .isNotEqualTo(firstName);
            assertThat(storage.toFile().listFiles())
                    .as("저장된 파일이 하나뿐이다 — 뒤엣것이 앞엣것을 덮어썼다")
                    .hasSize(2);
            return;
        }
        // 50회 동안 같은 초에 두 번 올리지 못했다. 이 환경에서는 검증할 수 없다.
        org.junit.jupiter.api.Assumptions.abort("같은 초에 두 요청을 넣지 못했다");
    }

    /** 저장명 {@code File_<타임스탬프>_<번호>} 에서 타임스탬프 부분. */
    private String timestampOf(String storedName) {
        return storedName.split("_")[1];
    }

    private String upload(EgovFileMngUtil util, String originalName) throws Exception {
        MultipartFile file = new MockMultipartFile("file", originalName, "application/pdf",
                "hello".getBytes(java.nio.charset.StandardCharsets.UTF_8));
        return util.writeUploadedFile(List.of(file), false).get(0).getStreFileNm();
    }

    private EgovFileMngUtil newUtil() {
        EgovFileMngUtil util = new EgovFileMngUtil();
        ReflectionTestUtils.setField(util, "filePath", storage.toString());
        ReflectionTestUtils.setField(util, "maxFileSize", "10MB");
        ReflectionTestUtils.setField(util, "dangerousFileExtensions", "exe,bat");
        ReflectionTestUtils.setField(util, "allowedMediaExtensions", "pdf,png,jpg");
        ReflectionTestUtils.setField(util, "egovFileIdGnrService", idGenerator());
        ReflectionTestUtils.setField(util, "fileService", fileServiceStub());
        return util;
    }

    /** 시퀀스처럼 매 호출마다 다른 값을 준다. 실제 구현도 같은 계약이다. */
    private EgovIdGnrService idGenerator() {
        AtomicInteger next = new AtomicInteger(1);
        return (EgovIdGnrService) Proxy.newProxyInstance(
                EgovIdGnrService.class.getClassLoader(),
                new Class<?>[] { EgovIdGnrService.class },
                (proxy, method, args) -> "getNextIntegerId".equals(method.getName())
                        ? next.getAndIncrement()
                        : defaultValue(method.getReturnType()));
    }

    /** DB 저장은 이 검증의 대상이 아니므로 성공만 돌려준다. */
    private Object fileServiceStub() {
        Class<?> type = fileServiceType();
        return Proxy.newProxyInstance(type.getClassLoader(), new Class<?>[] { type },
                (proxy, method, args) -> "insertFileDetailInfo".equals(method.getName())
                        ? 1
                        : defaultValue(method.getReturnType()));
    }

    private Class<?> fileServiceType() {
        return java.util.Arrays.stream(EgovFileMngUtil.class.getDeclaredFields())
                .filter(f -> "fileService".equals(f.getName()))
                .findFirst()
                .orElseThrow()
                .getType();
    }

    private Object defaultValue(Class<?> type) {
        if (!type.isPrimitive()) return null;
        if (type == boolean.class) return false;
        if (type == int.class) return 0;
        if (type == long.class) return 0L;
        return null;
    }
}
