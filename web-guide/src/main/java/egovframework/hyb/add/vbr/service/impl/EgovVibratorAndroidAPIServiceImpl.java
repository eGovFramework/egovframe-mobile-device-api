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
package egovframework.hyb.add.vbr.service.impl;

import java.util.List;

import egovframework.hyb.add.vbr.service.EgovVibratorAndroidAPIService;
import egovframework.hyb.add.vbr.service.VibratorAndroidAPIDefaultVO;
import egovframework.hyb.add.vbr.service.VibratorAndroidAPIVO;
import egovframework.hyb.add.vbr.service.VibratorAndroidAPIXmlVO;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

/**  
 * @Class Name : EgovVibratorAndroidAPIServiceImpl.java
 * @Description : EgovVibratorAndroidAPIServiceImpl Class
 * @Modification Information  
 * @
 * @  수정일            수정자        수정내용
 * @ ---------        ---------    -------------------------------
 * @ 2012. 8. 16.        이율경        최초생성
 * 
 * @author 디바이스 API 실행환경 팀
 * @since 2012. 8. 16.
 * @version 1.0
 * @see
 * 
 */
@Service("EgovVibratorAndroidAPIService")
public class EgovVibratorAndroidAPIServiceImpl extends EgovAbstractServiceImpl implements EgovVibratorAndroidAPIService {
    
    /** VibratorAPIDAO */
    @Resource(name="VibratorAndroidAPIDAO")
    private VibratorAndroidAPIDAO vibratorAPIDAO;

    /**
     * 알림 설정 정보를 등록한다.
     * @param vo - 등록할 정보가 담긴 VibratorAPIVO
     * @return 등록 결과
     * @exception Exception
     */
    public int insertVibrator(VibratorAndroidAPIXmlVO xmlVO) throws Exception {
        
        VibratorAndroidAPIVO vo =  new VibratorAndroidAPIVO();
        vo.setUuid(xmlVO.getUuid());
        vo.setTimeStamp(xmlVO.getTimeStamp());
        
        return (Integer)vibratorAPIDAO.insertVibrator(vo);        
    }
    
    /**
     * 알림 설정 정보 목록을 조회한다.
     * @param VO - 조회할 정보가 담긴 VibratorAPIVO
     * @return 알림 설정 정보 목록
     * @exception Exception
     */
    public List<?> selectVibratorList(VibratorAndroidAPIDefaultVO searchVO) throws Exception {
        return vibratorAPIDAO.selectVibratorList(searchVO);
    }
}
