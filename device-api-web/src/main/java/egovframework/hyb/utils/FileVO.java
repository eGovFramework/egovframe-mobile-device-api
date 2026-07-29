package egovframework.hyb.utils;

import java.io.Serializable;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Getter;
import lombok.Setter;

/**
 * @Class Name : MediaAPIFileVO.java
 * @Description : 통합 Media API File VO Class
 * @Modification Information
 * @
 * @ 수정일               수정자              수정내용
 * @ ----------   ---------   -------------------------------
 *   2025.10.28   통합개발팀          Android/iOS 패키지 통합
 *
 */
@Getter
@Setter
@Schema(description = "미디어 API 파일 업로드용 VO")
public class FileVO implements Serializable {

    private static final long serialVersionUID = 1L;

    /** 미디어 일련번호 */
    private int sn;

    /** 파일연번 */
    private int fileSn;

    /** 파일저장경로 */
    private String fileStreCours;

    /** 저장파일명 */
    private String streFileNm;

    /** 원파일명 */
    private String orignlFileNm;

    /** 파일확장자 */
    private String fileExtsn;

    /** 파일내용 */
    private String fileCn;

    /** 파일크기 */
    private String fileSize;

    /** 미디어 구분 코드 */
    private String mdCode;

    /** 미디어 제목 */
    private String mdSj;

    /** 디바이스 식별 */
    private String uuid;

    /** 활성화여부 */
    private String useyn;

    /** 재생 횟수 */
    private String revivCo;
}
