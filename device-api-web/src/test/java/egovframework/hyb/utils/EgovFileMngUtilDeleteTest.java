package egovframework.hyb.utils;

import static org.assertj.core.api.Assertions.assertThat;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;

import org.egovframe.rte.fdl.cmmn.exception.BaseRuntimeException;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.io.TempDir;

class EgovFileMngUtilDeleteTest {

    @Test
    void deleteFile_저장확장자를_포함해_실제파일을_삭제한다(@TempDir Path tempDir) {
        // 업로드 저장 로직은 streFileNm(확장자 없음) + "." + fileExtsn 으로 파일을 만든다.
        String streFileNm = "File_20260809_1";
        String fileExtsn = "jpg";
        Path stored = tempDir.resolve(streFileNm + "." + fileExtsn);
        try {
			Files.writeString(stored, "img");
		} catch (IOException e) {
			throw new BaseRuntimeException(e);
		}
        assertThat(Files.exists(stored)).isTrue();

        EgovFileMngUtil util = new EgovFileMngUtil();
        util.filePath = tempDir.toString();

        FileVO fileVO = new FileVO();
        fileVO.setStreFileNm(streFileNm);
        fileVO.setFileExtsn(fileExtsn);

        util.deleteFile(fileVO);

        // 수정 전에는 삭제 경로에 확장자를 붙이지 않아 실제 파일을 찾지 못하고 고아 파일로 남았다.
        assertThat(Files.exists(stored))
                .as("삭제는 저장·다운로드와 동일하게 확장자를 포함해 실제 파일을 제거해야 한다")
                .isFalse();
    }
}
