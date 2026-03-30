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
package egovframework.hyb.mbl.nwk.service;

import java.io.Serializable;

import io.swagger.v3.oas.annotations.media.Schema;

/**  
 * @Class Name : NetworkAPIVO.java
 * @Description : 통합 Network API VO Class
 * @Modification Information  
 * @
 * @ 수정일               수정자              수정내용
 * @ ----------   ---------   -------------------------------
 *   2025.10.28   통합개발팀          Android/iOS 패키지 통합
 * 
 * @author 디바이스 API 실행환경 팀
 * @since 2025. 10. 28.
 * @version 2.0
 * @see
 * 
 */
@Schema(description = "네트워크 API VO")
public class NetworkAPIVO extends NetworkAPIDefaultVO implements Serializable {

    private static final long serialVersionUID = 1L;

    /** 일련번호 */
    @Schema(description = "일련번호")
    private int sn;
    
    /** 기기식별 */
    @Schema(description = "기기식별코드")
    private String uuid;
    
    /** 네트워크 유형 */
    @Schema(description = "네트워크 유형")
    private String networktype;
    
    /** 사용여부 */
    @Schema(description = "사용여부")
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

    public String getNetworktype() {
        return networktype;
    }

    public void setNetworktype(String networktype) {
        this.networktype = networktype;
    }

    public String getUseYn() {
        return useYn;
    }

    public void setUseYn(String useYn) {
        this.useYn = useYn;
    }
}

