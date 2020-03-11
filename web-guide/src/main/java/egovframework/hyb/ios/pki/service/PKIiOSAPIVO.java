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
package egovframework.hyb.ios.pki.service;

import javax.xml.bind.annotation.XmlElement;

/**  
 * @Class Name : PKIiOSAPIVO.java
 * @Description : PKIiOSAPIVO Class
 * @Modification Information  
 * @
 * @  수정일                 수정자                 수정내용
 * @ 
 * @ 2012.07.16    이한철                  최초생성
 * 
 * @author 모바일 디바이스 API 팀
 * @since 2012. 07. 11
 * @version 1.0
 * @see
 * 
 *  Copyright (C) by MOPAS All right reserved.
 */

public class PKIiOSAPIVO extends PKIiOSAPIDefaultVO {

    private static final long serialVersionUID = 1L;

    /** 일련번호 */
    private int sn;

    /** 기기식별 */
    private String uuid;

    /** Direct Message */
    private String dn;

    /** CRTFC_DT */
    private String crtfcDt;

    /** sign */
    private String sign;

    /** ENTRPRS_SE_CODE */
    private String entrprsSeCode;

    /**
     * @return sn을 반환한다
     */
    public int getSn() {
        return sn;
    }

    /**
     * @param 파라미터
     *            sn를 변수 sn에 설정한다.
     */
    public void setSn(int sn) {
        this.sn = sn;
    }

    /**
     * @return uuid을 반환한다
     */
    public String getUuid() {
        return uuid;
    }

    /**
     * @param 파라미터
     *            uuid를 변수 uuid에 설정한다.
     */
    public void setUuid(String uuid) {
        this.uuid = uuid;
    }

    /**
     * @param dn
     *            반환한다
     */
    public String getDn() {
        return dn;
    }

    /**
     * @param 파라미터
     *            dn 를 변수 dn에 설정한다.
     */
    public void setDn(String dn) {
        this.dn = dn;
    }

    /**
     * @param CRTFC_DT를
     *            반환한다
     */
    public String getCrtfcDt() {
        return crtfcDt;
    }

    /**
     * @param 파라미터
     *            crtfc_dt를 변수 crtfc_dt에 설정한다.
     */
    public void setCrtfcDt(String crtfcDt) {
        this.crtfcDt = crtfcDt;
    }

    /**
     * @return entrprsSeCode을 반환한다
     */
    public String getEntrprsSeCode() {
        return entrprsSeCode;
    }

    /**
     * @param 파라미터
     *            entrprsSeCode를 변수 entrprsSeCode에 설정한다.
     */
    @XmlElement
    public void setEntrprsSeCode(String entrprsSeCode) {
        this.entrprsSeCode = entrprsSeCode;
    }

    /**
     * @return sign을 반환한다
     */
    public String getSign() {
        return sign;
    }

    /**
     * @param 파라미터
     *            sign를 변수 sign에 설정한다.
     */
    @XmlElement
    public void setSign(String sign) {
        this.sign = sign;
    }

}
