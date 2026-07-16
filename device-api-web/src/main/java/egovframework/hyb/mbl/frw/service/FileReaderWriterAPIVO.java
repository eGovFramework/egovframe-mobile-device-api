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
import lombok.Getter;
import lombok.Setter;

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
@Getter
@Setter
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
}
