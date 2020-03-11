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
package egovframework.hyb.ios.nwk.service;

import java.util.List;

/**  
 * @Class Name : EgovNetworkiOSAPIService.java
 * @Description : EgovNetworkiOSAPIService Class
 * @Modification Information  
 * @
 * @  수정일       수정자                 수정내용
 * @ ---------   ---------   -------------------------------
 * @ 2012.05.14   서준식                 최초생성
 * @ 2012.08.01    이해성        DeviceAPIGuide Network Info
 * 
 * @author 디바이스 API 실행환경 개발팀
 * @since 2012. 05. 14
 * @version 1.0
 * @see
 * 
 *  Copyright (C) by MOPAS All right reserved.
 */
public interface EgovNetworkiOSAPIService {
	
	/**
	 * 네트워크 정보를 등록한다.
	 * @param vo - 등록할 정보가 담긴 NetworkAPIVO
	 * @return 등록 결과
	 * @exception Exception
	 */
    int insertNetworkInfo(NetworkiOSAPIVO vo) throws Exception;
    
    /**
	 * 네트워크 정보를 수정한다.
	 * @param vo - 수정할 정보가 담긴 NetworkAPIVO
	 * @return void형
	 * @exception Exception
	 */
    int updateNetworkInfo(NetworkiOSAPIVO vo) throws Exception;
    
    /**
	 * 네트워크 정보를 삭제한다.
	 * @param vo - 삭제할 정보가 담긴 NetworkAPIVO
	 * @return void형 
	 * @exception Exception
	 */
    int deleteNetworkInfo(NetworkiOSAPIVO vo) throws Exception;
    
    /**
	 * 네트워크 정보를 조회한다.
	 * @param vo - 조회할 정보가 담긴 NetworkAPIVO
	 * @return 조회한 네트워크 정보
	 * @exception Exception
	 */
    NetworkiOSAPIVO selectNetworkInfo(NetworkiOSAPIVO vo) throws Exception;
    
    /**
	 * 네트워크 정보 목록을 조회한다.
	 * @param VO - 조회할 정보가 담긴 NetworkAPIVO
	 * @return 네트워크 정보 목록
	 * @exception Exception
	 */
    List<?> selectNetworkInfoList(NetworkiOSAPIVO vo) throws Exception;
    /**
	 * 네트워크 정보 총 갯수를 조회한다.
	 * @param VO - 조회할 정보가 담긴 NetworkAPIDefaultVO
	 * @return 네트워크 정보 총 갯수
	 * @exception
	 */
    int selectNetworkInfoListTotCnt(NetworkiOSAPIVO vo);
    
}
