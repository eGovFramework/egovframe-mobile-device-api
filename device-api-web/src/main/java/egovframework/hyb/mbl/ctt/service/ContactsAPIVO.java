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
package egovframework.hyb.mbl.ctt.service;

import java.io.Serializable;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Getter;
import lombok.Setter;

/**
 * 통합 Contacts API VO Class (Android/iOS 공통)
 *
 * 수정이력
 * 2025.10.28 통합개발팀 Android/iOS 패키지 통합
 */
@Schema(description = "연락처 API VO")
@Getter
@Setter
public class ContactsAPIVO implements Serializable {

    private static final long serialVersionUID = 1L;

    /** 일련번호 (UUID별 MAX+1 채번) */
    private int sn;

    /** UUID(기기식별코드) */
    private String uuid;

    /** 연락처 이름 */
    private String name;

    /** 연락처 전화번호 */
    private String telNo;

    /** 연락처 전화번호 비교용 */
    private String telNoCompare;

    /** 연락처 이메일 */
    private String emails;

    /** 사용 여부 */
    private String useYn;

    /** 연락처 총 개수 */
    private int totCount;

    /** 연락처 리스트 */
    private String contactsList;

    /** resultState */
    private String resultState;

    /** resultMessage */
    private String resultMessage;

    /** Flutter 앱 telno 필드 바인딩 */
    public void setTelno(String telno) {
        this.telNo = telno;
    }

    public String getTelno() {
        return telNo;
    }
}
