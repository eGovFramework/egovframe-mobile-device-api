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
package egovframework.hyb.add.pki.service;

import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;

/**  
 * @Class Name : PKIAndroidAPIVO.java
 * @Description : PKIAndroidAPIVO Class
 * @Modification Information  
 * @
 * @  수정일                 수정자                 수정내용
 * @ ---------   ---------   -------------------------------
 * @ 2012.07.23    나신일                  최초생성
 * 
 * @author 모바일 디바이스 API 팀
 * @since 2012. 07. 23
 * @version 1.0
 * @see
 * 
 *  Copyright (C) by MOPAS All right reserved.
 */

@XmlRootElement
public class PKIAndroidAPIVO extends PKIAndroidAPIDefaultVO {

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

    /** resultState */
    private String resultState;

    /** resultMessage */
    private String resultMessage;

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
    @XmlElement
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
    @XmlElement
    public void setUuid(String uuid) {
        this.uuid = uuid;
    }

    /**
     * @return dn을 반환한다
     */
    public String getDn() {
        return dn;
    }

    /**
     * @param 파라미터
     *            dn를 변수 dn에 설정한다.
     */
    @XmlElement
    public void setDn(String dn) {
        this.dn = dn;
    }

    /**
     * @return crtfcDt을 반환한다
     */
    public String getCrtfcDt() {
        return crtfcDt;
    }

    /**
     * @param 파라미터
     *            crtfcDt 변수 crtfcDt에 설정한다.
     */
    @XmlElement
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

    /**
     * @param resultState를
     *            반환한다
     */
    public String getResultState() {
        return resultState;
    }

    /**
     * @param 파라미터
     *            resultState를 변수 resultState에 설정한다.
     */
    @XmlElement
    public void setResultState(String resultState) {
        this.resultState = resultState;
    }

    /**
     * @param resultMessage를
     *            반환한다
     */
    public String getResultMessage() {
        return resultMessage;
    }

    /**
     * @param 파라미터
     *            resultMessage를 변수 resultMessage에 설정한다.
     */
    @XmlElement
    public void setResultMessage(String resultMessage) {
        this.resultMessage = resultMessage;
    }

}
