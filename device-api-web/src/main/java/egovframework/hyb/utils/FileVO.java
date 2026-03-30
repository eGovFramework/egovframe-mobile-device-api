package egovframework.hyb.utils;

import java.io.Serializable;

import io.swagger.v3.oas.annotations.media.Schema;

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

    public int getSn() {
        return sn;
    }

    public void setSn(int sn) {
        this.sn = sn;
    }

    public int getFileSn() {
        return fileSn;
    }

    public void setFileSn(int fileSn) {
        this.fileSn = fileSn;
    }

    public String getFileStreCours() {
        return fileStreCours;
    }

    public void setFileStreCours(String fileStreCours) {
        this.fileStreCours = fileStreCours;
    }

    public String getStreFileNm() {
        return streFileNm;
    }

    public void setStreFileNm(String streFileNm) {
        this.streFileNm = streFileNm;
    }

    public String getOrignlFileNm() {
        return orignlFileNm;
    }

    public void setOrignlFileNm(String orignlFileNm) {
        this.orignlFileNm = orignlFileNm;
    }

    public String getFileExtsn() {
        return fileExtsn;
    }

    public void setFileExtsn(String fileExtsn) {
        this.fileExtsn = fileExtsn;
    }

    public String getFileCn() {
        return fileCn;
    }

    public void setFileCn(String fileCn) {
        this.fileCn = fileCn;
    }

    public String getFileSize() {
        return fileSize;
    }

    public void setFileSize(String fileSize) {
        this.fileSize = fileSize;
    }

    public String getMdCode() {
        return mdCode;
    }

    public void setMdCode(String mdCode) {
        this.mdCode = mdCode;
    }

    public String getMdSj() {
        return mdSj;
    }

    public void setMdSj(String mdSj) {
        this.mdSj = mdSj;
    }

    public String getUuid() {
        return uuid;
    }

    public void setUuid(String uuid) {
        this.uuid = uuid;
    }

    public String getUseyn() {
        return useyn;
    }

    public void setUseyn(String useyn) {
        this.useyn = useyn;
    }

    public String getRevivCo() {
        return revivCo;
    }

    public void setRevivCo(String revivCo) {
        this.revivCo = revivCo;
    }
}
