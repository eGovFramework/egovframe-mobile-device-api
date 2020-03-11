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
package egovframework.hyb.add.cps.service.impl;

import java.util.List;

import egovframework.hyb.add.cps.service.CompassAndroidAPIDefaultVO;
import egovframework.hyb.add.cps.service.CompassAndroidAPIVO;
import egovframework.hyb.add.cps.service.EgovCompassAndroidAPIService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

/**  
 * @Class Name : EgovCompassAPIServiceImpl.java
 * @Description : EgovCompassAPIServiceImpl Class
 * @Modification Information  
 * @
 * @  수정일                 수정자                 수정내용
 * @ ---------   ---------   -------------------------------
 * @ 2012.07.23    서형주                  최초생성
 * 
 * @author Device API 실행환경팀
 * @since 2012. 07. 30
 * @version 1.0
 * @see
 * 
 */

@Service("EgovCompassAndroidAPIService")
public class EgovCompassAndroidAPIServiceImpl extends EgovAbstractServiceImpl implements EgovCompassAndroidAPIService {
    
    /** CompassAndroidAPIDAO */
    @Resource(name="CompassAndroidAPIDAO")
    private CompassAndroidAPIDAO compassAPIDAO;

    /**
     * 방향 정보를 등록한다.
     * @param vo - 등록할 정보가 담긴 CompassAPIVO
     * @return 등록 결과
     * @exception Exception
     */
    public int insertCompassInfo(CompassAndroidAPIVO vo) throws Exception {        
        return compassAPIDAO.insertCompassInfo(vo);        
    }

    /**
     * 방향 정보를 수정한다.
     * @param vo - 수정할 정보가 담긴 CompassAPIVO
     * @return void형
     * @exception Exception
     */
    public void updateCompassInfo(CompassAndroidAPIVO vo) throws Exception {
        compassAPIDAO.updateCompassInfo(vo);
    }

    /**
     * 방향 정보를 삭제한다.
     * @param vo - 삭제할 정보가 담긴 CompassAPIVO
     * @return void형 
     * @exception Exception
     */
    public int deleteCompassInfo(CompassAndroidAPIVO vo) throws Exception {
        return compassAPIDAO.deleteCompassInfo(vo);
    }

    /**
     * 방향 정보를 조회한다.
     * @param vo - 조회할 정보가 담긴 CompassAPIVO
     * @return 조회한 방향 정보
     * @exception Exception
     */
    public CompassAndroidAPIVO selectCompassInfo(CompassAndroidAPIVO vo) throws Exception {
        CompassAndroidAPIVO resultVO = compassAPIDAO.selectCompassInfo(vo);
        if (resultVO == null)
            throw processException("info.nodata.msg");
        return resultVO;
    }

    /**
     * 방향 정보 목록을 조회한다.
     * @param VO - 조회할 정보가 담긴 CompassAPIDefaultVO
     * @return 방향 정보 목록
     * @exception Exception
     */
    public List<?> selectCompassInfoList(CompassAndroidAPIDefaultVO searchVO) throws Exception {
        return compassAPIDAO.selectCompassInfoList(searchVO);
    }

    /**
     * 방향 정보 총 갯수를 조회한다.
     * @param VO - 조회할 정보가 담긴 CompassAPIDefaultVO
     * @return 방향 정보 총 갯수
     * @exception
     */
    public int selectCompassInfoListTotCnt(CompassAndroidAPIDefaultVO searchVO) {
        return compassAPIDAO.selectCompassInfoListTotCnt(searchVO);
    }
    
}
