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
package egovframework.hyb.mbl.mda.service;

import java.io.Serializable;

import egovframework.hyb.utils.FileVO;
import io.swagger.v3.oas.annotations.media.Schema;

/**  
 * @Class Name : MediaAPIVO.java
 * @Description : 통합 Media API VO Class
 * @Modification Information  
 * @
 * @ 수정일               수정자              수정내용
 * @ ----------   ---------   -------------------------------
 *   2025.10.28   통합개발팀          Android/iOS 패키지 통합
 * 
 */
@Schema(description = "미디어 API VO")
public class MediaAPIVO extends FileVO implements Serializable {

    private static final long serialVersionUID = 1L;

    /** 일련번호 */
    private int sn;

    /** 기기식별코드 */
    private String uuid;

    /** 파일 일련번호 */
    private int fileSn;

    /** 미디어구분코드 */
    private String mdCode;

    /** 미디어 제목 */
    private String mdSj;

    /** 사용여부 */
    private String useyn;

    /** 재생횟수 */
    private String revivCo;

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
