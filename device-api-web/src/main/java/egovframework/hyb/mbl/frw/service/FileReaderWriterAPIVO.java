/*
 * Copyright 2008-2009 the original author or authors.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package egovframework.hyb.mbl.frw.service;

import java.io.Serializable;

import io.swagger.v3.oas.annotations.media.Schema;

/**  
 * @Class Name : FileReaderWriterAPIVO.java
 * @Description : 통합 FileReaderWriter API VO Class (Android/iOS 공통)
 * @Modification Information  
 * @
 * @ 수정일               수정자              수정내용
 * @ ----------   ---------   -------------------------------
 *   2025.10.28   통합개발팀          Android/iOS 패키지 통합
 * 
 */
@Schema(description = "파일 읽기/쓰기 API VO")
public class FileReaderWriterAPIVO implements Serializable {

    private static final long serialVersionUID = 1L;

    /** 일련번호 */
    private int sn;

    /** UUID(기기식별코드) */
    private String uuid;

    /** 파일 일련번호 */
    private int fileSn;

    /** 파일 이름 */
    private String fileNm;

    /** 파일 타입 */
    private String fileType;

    /** 수정일 */
    private String updtDt;

    /** 사용 여부 */
    private String useYn;

    /** 파일 저장 경로 */
    private String fileStreCours;

    /** 저장된 파일 이름 */
    private String streFileNm;

    /** 원 파일 이름 */
    private String orignlFileNm;

    /** 파일 확장자 명 */
    private String fileExtsn;

    /** 파일 내용 */
    private String fileCn;

    /** 파일 사이즈 */
    private String fileSize;

    /** resultState */
    private String resultState;

    /** resultMessage */
    private String resultMessage;

    public int getSn() {
        return sn;
    }

    public void setSn(int sn) {
        this.sn = sn;
    }

    public String getUuid() {
        return uuid;
    }

    public void setUuid(String uuid) {
        this.uuid = uuid;
    }

    public int getFileSn() {
        return fileSn;
    }

    public void setFileSn(int fileSn) {
        this.fileSn = fileSn;
    }

    public String getFileNm() {
        return fileNm;
    }

    public void setFileNm(String fileNm) {
        this.fileNm = fileNm;
    }

    public String getFileType() {
        return fileType;
    }

    public void setFileType(String fileType) {
        this.fileType = fileType;
    }

    public String getUpdtDt() {
        return updtDt;
    }

    public void setUpdtDt(String updtDt) {
        this.updtDt = updtDt;
    }

    public String getUseYn() {
        return useYn;
    }

    public void setUseYn(String useYn) {
        this.useYn = useYn;
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

    public String getResultState() {
        return resultState;
    }

    public void setResultState(String resultState) {
        this.resultState = resultState;
    }

    public String getResultMessage() {
        return resultMessage;
    }

    public void setResultMessage(String resultMessage) {
        this.resultMessage = resultMessage;
    }
}
