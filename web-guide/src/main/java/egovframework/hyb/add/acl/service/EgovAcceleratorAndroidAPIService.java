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
package egovframework.hyb.add.acl.service;

import java.util.List;

/**  
 * @Class Name : EgovAcceleratorAPIService.java
 * @Description : EgovAcceleratorAPIService Class
 * @Modification Information  
 * @
 * @  수정일                 수정자                 수정내용
 * @ ---------   ---------   -------------------------------
 * @ 2012.07.23    서형주                  최초생성
 * 
 * @author Device API 실행환경팀
 * @since 2012. 07. 23
 * @version 1.0
 * @see
 * 
 */
public interface EgovAcceleratorAndroidAPIService {
    
    /**
     * 가속도 정보를 등록한다.
     * @param vo - 등록할 정보가 담긴 AcceleratorAPIVO
     * @return 등록 결과
     * @exception Exception
     */
    int insertAcceleratorInfo(AcceleratorAndroidAPIVO vo) throws Exception;
    
    /**
     * 가속도 정보를 수정한다.
     * @param vo - 수정할 정보가 담긴 AcceleratorAPIVO
     * @return void형
     * @exception Exception
     */
    void updateAcceleratorInfo(AcceleratorAndroidAPIVO vo) throws Exception;
    
    /**
     * 가속도 정보를 삭제한다.
     * @param vo - 삭제할 정보가 담긴 AcceleratorAPIVO
     * @return 등록 결과 
     * @exception Exception
     */
    int deleteAcceleratorInfo(AcceleratorAndroidAPIVO vo) throws Exception;
    
    /**
     * 가속도 정보를 조회한다.
     * @param vo - 조회할 정보가 담긴 AcceleratorAPIVO
     * @return 조회한 가속도 정보
     * @exception Exception
     */
    AcceleratorAndroidAPIVO selectAcceleratorInfo(AcceleratorAndroidAPIVO vo) throws Exception;
    
    /**
     * 가속도 정보 목록을 조회한다.
     * @param VO - 조회할 정보가 담긴 AcceleratorAPIDefaultVO
     * @return 가속도 정보 목록
     * @exception Exception
     */
    List<?> selectAcceleratorInfoList(AcceleratorAndroidAPIDefaultVO searchVO) throws Exception;
    
    /**
     * 가속도 정보 총 갯수를 조회한다.
     * @param VO - 조회할 정보가 담긴 AcceleratorAPIDefaultVO
     * @return 가속도 정보 총 갯수
     * @exception
     */
    int selectAcceleratorInfoListTotCnt(AcceleratorAndroidAPIDefaultVO searchVO);
    
}
