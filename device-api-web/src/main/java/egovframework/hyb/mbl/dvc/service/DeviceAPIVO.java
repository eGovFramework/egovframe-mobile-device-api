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
package egovframework.hyb.mbl.dvc.service;

import java.io.Serializable;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Getter;
import lombok.Setter;

/**
 * @Class Name : DeviceAPIVO.java
 * @Description : 통합 Device API VO Class
 * @Modification Information
 * @
 * @ 수정일               수정자              수정내용
 * @ ----------   ---------   -------------------------------
 *   2025.10.28   통합개발팀          Android/iOS 패키지 통합
 *
 */
@Getter
@Setter
@Schema(description = "디바이스 API VO")
public class DeviceAPIVO implements Serializable {

    private static final long serialVersionUID = 1L;

    /** 일련번호 */
    private int sn;

    /** 기기식별코드 */
    private String uuid;

    /** OS */
    private String os;

    /** 전화번호 */
    private String telno;

    /** 스토리지 정보 */
    private String strgeInfo;

    /** 네트워크 디바이스 정보 */
    private String ntwrkDeviceInfo;

    /** 폰갭 버전 */
    private String pgVer;

    /** 디바이스 명 */
    private String deviceNm;

    /** 활성화 여부 */
    private String useYn;
}
