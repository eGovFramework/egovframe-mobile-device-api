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
package egovframework.hyb.add.pki.service.impl;

import java.util.List;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

import javax.annotation.Resource;

import org.apache.xerces.impl.dv.util.Base64;
import org.springframework.stereotype.Service;
// TODO : gpki 라이브러리는 공무원이 신청해서 다운로드 받아서 사용(해당 모듈 사용시 주석해제)
//import com.gpki.gpkiapi.GpkiApi;
//import com.gpki.gpkiapi.cert.CertPathValidator;
//import com.gpki.gpkiapi.cert.X509Certificate;
//import com.gpki.gpkiapi.cms.SignedData;
//import com.gpki.gpkiapi.storage.Disk;
import egovframework.hyb.add.pki.service.EgovPKIAndroidAPIService;
import egovframework.hyb.add.pki.service.PKIAndroidAPIDefaultVO;
import egovframework.hyb.add.pki.service.PKIAndroidAPIVO;

/**  
 * @Class Name : EgovPKIAndroidAPIServiceImpl.java
 * @Description : EgovPKIAndroidAPIServiceImpl Class
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

@Service("EgovPKIAndroidAPIService")
public class EgovPKIAndroidAPIServiceImpl extends EgovAbstractServiceImpl implements
        EgovPKIAndroidAPIService {

    /** PKIAndroidAPIDAO */
    @Resource(name = "PKIAndroidAPIDAO")
    private PKIAndroidAPIDAO pkiAPIDAO;

    /**
     * 인증서로그인 한 정보를 등록한다.
     * 
     * @param vo
     *            - 등록할 정보가 담긴 PKIAndroidAPIVO
     * @return 등록 결과
     * @exception Exception
     */
    public int insertPKIInfo(PKIAndroidAPIVO vo) throws Exception {
        return pkiAPIDAO.insertPKIInfo(vo);
    }

    /**
     * pki 정보 목록을 조회한다.
     * 
     * @param VO
     *            - 조회할 정보가 담긴 PKIAndroidAPIVO
     * @return pki 정보 목록
     * @exception Exception
     */
    public List<?> selectPKIInfoList(PKIAndroidAPIDefaultVO searchVO)
            throws Exception {
        return pkiAPIDAO.selectPKIInfoList(searchVO);
    }

    /**
     * pki 정보 총 갯수를 조회한다.
     * 
     * @param VO
     *            - 조회할 정보가 담긴 PKIAndroidAPIVO
     * @return pki 정보 총 갯수
     * @exception
     */
    public int selectPKIInfoListTotCnt(PKIAndroidAPIDefaultVO searchVO) {
        return pkiAPIDAO.selectPKIInfoListTotCnt(searchVO);
    }

    /**
     * 인증서 인증을 한다.
     * 
     * @param vo
     *            - 인증 정보가 담긴 PKIAndroidAPIVO
     * @return 인증 결과
     * @exception Exception
     */
    public String verifyCert(PKIAndroidAPIVO pkiVo) throws Exception {
        // API 초기화
//        GpkiApi.init("C:/libgpkiapi_jni/conf");

        String sign = null;
        sign = pkiVo.getSign();

        return verify(Base64.decode(sign));
    }

    /**
     * 인증서 인증을 한다.
     * 
     * @param signedData
     *            - 싸인데이타
     * @return 인증 결과
     * @exception Exception
     */
    private String verify(final byte[] bSignedData) {
        String sClientName = "";
       /* try {

            // 서명값을 검증
            SignedData signedData = null;
            signedData = new SignedData();

            signedData.verify(bSignedData);

            // 서명자의 인증서 검증을 위해서 서버의 서명용 인증서 획득
            X509Certificate clientCert = null;
            clientCert = signedData.getSignerCert(0);

            // 인증서 검증
            CertPathValidator certPathValiditor = null;
            certPathValiditor = new CertPathValidator(
                    "C:/libgpkiapi_jni/conf/gpkiapi.conf");

            // 신뢰하는 최상위 인증서 추가
            X509Certificate rootCertRsa = null;
            rootCertRsa = Disk.readCert("C:/libgpkiapi_jni/conf/root-rsa2.der");
            X509Certificate rootCertRsaSha = null;
            rootCertRsaSha = Disk
                    .readCert("C:/libgpkiapi_jni/conf/root-rsa-sha2.der");

            certPathValiditor.addTrustedRootCert(rootCertRsa);
            certPathValiditor.addTrustedRootCert(rootCertRsaSha);

            // 클라이언트의 인증서 검증 범위 설정
            certPathValiditor
                    .setVerifyRange(CertPathValidator.CERT_VERIFY_FULL_PATH);

            // 클라이언트의 인증서 폐지여부 확인 설정 (CRL/ARL 검증 설정함)
            certPathValiditor
                    .setRevokationCheck(CertPathValidator.REVOKE_CHECK_ARL
                            | CertPathValidator.REVOKE_CHECK_CRL);

            // 인증서 검증 요청
            certPathValiditor.validate(CertPathValidator.CERT_SIGN, clientCert);

            sClientName = clientCert.getSubjectDN();

        } catch (Exception e) {
            sClientName = "";
        }*/
        return sClientName;
    }
}
