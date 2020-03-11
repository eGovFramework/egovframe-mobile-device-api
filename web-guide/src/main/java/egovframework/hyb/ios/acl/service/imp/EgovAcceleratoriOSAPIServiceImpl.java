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
package egovframework.hyb.ios.acl.service.imp;

import java.util.List;

import egovframework.hyb.ios.acl.service.AcceleratoriOSAPIDefaultVO;
import egovframework.hyb.ios.acl.service.AcceleratoriOSAPIVO;
import egovframework.hyb.ios.acl.service.EgovAcceleratoriOSAPIService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

/**  
 * @Class Name : EgovAcceleratorAPIServiceImpl.java
 * @Description : EgovAcceleratorAPIServiceImpl Class
 * @Modification Information  
 * @
 * @  수정일         수정자                 수정내용
 * @ ---------   ---------   -------------------------------
 * @ 2012.07.23    서형주                  최초생성
 *   2012.08.16    서준식                 json 버전으로 변경 
 * 
 * @author Device API 실행환경팀
 * @since 2012. 07. 23
 * @version 1.0
 * @see
 * 
 */

@Service("EgovAcceleratoriOSAPIService")
public class EgovAcceleratoriOSAPIServiceImpl extends EgovAbstractServiceImpl implements EgovAcceleratoriOSAPIService {
	
	private static final Logger LOGGER = LoggerFactory.getLogger(EgovAcceleratoriOSAPIServiceImpl.class);
	
	/** AcceleratoriOSAPIDAO */
    @Resource(name="AcceleratoriOSAPIDAO")
    private AcceleratoriOSAPIDAO acceleratoriOSAPIDAO;

	/**
	 * 가속도 정보를 등록한다.
	 * @param vo - 등록할 정보가 담긴 AcceleratoriOSAPIVO
	 * @return 등록 결과
	 * @exception Exception
	 */
    public int insertAcceleratorInfo(AcceleratoriOSAPIVO vo) throws Exception {
    	LOGGER.debug(vo.toString());
    	
    	return acceleratoriOSAPIDAO.insertAcceleratorInfo(vo);    	
    }

    /**
	 * 가속도 정보를 수정한다.
	 * @param vo - 수정할 정보가 담긴 AcceleratoriOSAPIVO
	 * @return void형
	 * @exception Exception
	 */
    public void updateAcceleratorInfo(AcceleratoriOSAPIVO vo) throws Exception {
    	acceleratoriOSAPIDAO.updateAcceleratorInfo(vo);
    }

    /**
	 * 가속도 정보를 삭제한다.
	 * @param vo - 삭제할 정보가 담긴 AcceleratoriOSAPIVO
	 * @return void형 
	 * @exception Exception
	 */
    public int deleteAcceleratorInfo(AcceleratoriOSAPIVO vo) throws Exception {
    	return acceleratoriOSAPIDAO.deleteAcceleratorInfo(vo);
    }

    /**
	 * 가속도 정보를 조회한다.
	 * @param vo - 조회할 정보가 담긴 AcceleratoriOSAPIVO
	 * @return 조회한 가속도 정보
	 * @exception Exception
	 */
    public AcceleratoriOSAPIVO selectAcceleratorInfo(AcceleratoriOSAPIVO vo) throws Exception {
    	AcceleratoriOSAPIVO resultVO = acceleratoriOSAPIDAO.selectAcceleratorInfo(vo);
        if (resultVO == null)
            throw processException("info.nodata.msg");
        return resultVO;
    }

    /**
	 * 가속도 정보 목록을 조회한다.
	 * @param VO - 조회할 정보가 담긴 AcceleratoriOSAPIDefaultVO
	 * @return 가속도 정보 목록
	 * @exception Exception
	 */
    public List<?> selectAcceleratorInfoList(AcceleratoriOSAPIDefaultVO searchVO) throws Exception {
        return acceleratoriOSAPIDAO.selectAcceleratorInfoList(searchVO);
    }

    /**
	 * 가속도 정보 총 갯수를 조회한다.
	 * @param VO - 조회할 정보가 담긴 AcceleratoriOSAPIDefaultVO
	 * @return 가속도 정보 총 갯수
	 * @exception
	 */
    public int selectAcceleratorInfoListTotCnt(AcceleratoriOSAPIDefaultVO searchVO) {
		return acceleratoriOSAPIDAO.selectAcceleratorInfoListTotCnt(searchVO);
	}
    
}
