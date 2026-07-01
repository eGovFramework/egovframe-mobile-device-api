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
package egovframework.hyb.mbl.itf.service;

import java.io.Serializable;

import egovframework.hyb.validation.EgovNotNull;
import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.Size;

/**  
 * @Class Name : InterfaceAPIVO.java
 * @Description : 통합 Interface API VO Class (Android/iOS 공통)
 * @Modification Information  
 * @
 * @ 수정일               수정자              수정내용
 * @ ----------   ---------   -------------------------------
 *   2025.10.28   통합개발팀          Android/iOS 패키지 통합
 * 
 */
@Schema(description = "인터페이스 API VO")
public class InterfaceAPIVO implements Serializable {

    private static final long serialVersionUID = 1L;

    /** 일련번호 */
    private int sn;

    /** 기기식별코드 */
    @Size(max = 36, message = "{interface.uuid.maxlength}")
    private String uuid;

    /** 아이디 */
    @EgovNotNull(message = "{interface.userId.required}")
    @Size(max = 20, message = "{interface.userId.maxlength}")
    private String userId;

    /** 비밀번호 (앱 1차 해시: SHA-256(userId||password) Base64 — DB에 그대로 저장) */
    @EgovNotNull(message = "{interface.userPw.required}")
    @Size(min = 1, max = 200, message = "{interface.userPw.invalid}")
    private String userPw;

    /** E-mail */
    @Email(message = "{interface.emails.invalid}")
    @Size(max = 100, message = "{interface.emails.maxlength}")
    private String emails;

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

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public String getUserPw() {
        return userPw;
    }

    public void setUserPw(String userPw) {
        this.userPw = userPw;
    }

    public String getEmails() {
        return emails;
    }

    public void setEmails(String emails) {
        this.emails = emails;
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
