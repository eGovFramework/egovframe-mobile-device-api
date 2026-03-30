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
package egovframework.hyb.mbl.acl.service;

import java.io.Serializable;

import io.swagger.v3.oas.annotations.media.Schema;

/**  
 * @Class Name : AcceleratorAPIVO.java
 * @Description : 통합 Accelerator API VO Class (Android/iOS 공통)
 * @Modification Information  
 * @
 * @ 수정일               수정자              수정내용
 * @ ----------   ---------   -------------------------------
 *   2025.10.28   통합개발팀          Android/iOS 패키지 통합
 * 
 */
@Schema(description = "가속도계 API VO")
public class AcceleratorAPIVO implements Serializable {

    private static final long serialVersionUID = 1L;

    /** 일련번호 */
    private int sn;

    /** 기기식별코드 */
    private String uuid;

    /** x축 값 */
    private String xaxis;

    /** y축 값 */
    private String yaxis;

    /** z축 값 */
    private String zaxis;

    /** 타임스탬프 */
    private String timestamp;

    /** 사용여부 */
    private String useYn;

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

    public String getXaxis() {
        return xaxis;
    }

    public void setXaxis(String xaxis) {
        this.xaxis = xaxis;
    }

    public String getYaxis() {
        return yaxis;
    }

    public void setYaxis(String yaxis) {
        this.yaxis = yaxis;
    }

    public String getZaxis() {
        return zaxis;
    }

    public void setZaxis(String zaxis) {
        this.zaxis = zaxis;
    }

    public String getTimestamp() {
        return timestamp;
    }

    public void setTimestamp(String timestamp) {
        this.timestamp = timestamp;
    }

    public String getUseYn() {
        return useYn;
    }

    public void setUseYn(String useYn) {
        this.useYn = useYn;
    }
}
