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
package egovframework.hyb.mbl.gps.service;

import java.io.Serializable;

import io.swagger.v3.oas.annotations.media.Schema;

/**  
 * @Class Name : GPSAPIVO.java
 * @Description : 통합 GPS API VO Class (Android/iOS 공통)
 * @Modification Information  
 * @
 * @ 수정일               수정자              수정내용
 * @ ----------   ---------   -------------------------------
 *   2025.10.28   통합개발팀          Android/iOS 패키지 통합
 * 
 */
@Schema(description = "GPS API VO")
public class GPSAPIVO implements Serializable {

    private static final long serialVersionUID = 1L;

    /** 일련번호 */
    private int sn;

    /** 기기식별코드 */
    private String uuid;

    /** 위도 */
    private String lat;

    /** 경도 */
    private String lon;

    /** 정확도 */
    private String accrcy;

    /** 사용여부 */
    private String useYn;

    /** 결과 상태 */
    private String resultState;

    /** 결과 메시지 */
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

    public String getLat() {
        return lat;
    }

    public void setLat(String lat) {
        this.lat = lat;
    }

    public String getLon() {
        return lon;
    }

    public void setLon(String lon) {
        this.lon = lon;
    }

    public String getAccrcy() {
        return accrcy;
    }

    public void setAccrcy(String accrcy) {
        this.accrcy = accrcy;
    }

    public String getUseYn() {
        return useYn;
    }

    public void setUseYn(String useYn) {
        this.useYn = useYn;
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