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
package egovframework.hyb.ios.mda.service;

import java.util.List;

import javax.servlet.http.HttpServletResponse;

/**  
 * @Class Name : EgovMediaiOSAPIService.java
 * @Description : EgovMediaiOSAPIService Class
 * @Modification Information  
 * @
 * @  수정일			수정자		수정내용
 * @ ---------		---------	-------------------------------
 * @ 2012. 7. 30.		이율경		최초생성
 * @ 2012. 8. 14.		이해성       커스터마이징
 * 
 * @author 디바이스 API 실행환경 팀
 * @since 2012. 7. 30.
 * @version 1.0
 * @see
 * 
 */
public interface EgovMediaiOSAPIService {

	/**
	 * 녹음 Media를 등록한다.
	 * @param vo - 등록할 정보가 담긴 MediaiOSAPIVO
	 * @return void형
	 * @exception Exception
	 */
	public int insertMediaInfo(MediaiOSAPIVO vo, int fileSn) throws Exception;
	
	/**
	 * 녹음 파일을 등록한다.
	 * @param vo - 등록할 정보가 담긴 MediaiOSAPIFileVO
	 * @return void형
	 * @exception Exception
	 */
	public int insertMediaRecordFile(MediaiOSAPIFileVO vo) throws Exception;
	
	/**
	 * 미디어 정보를 조회한다.
	 * @param VO - 조회할 정보가 담긴 MediaiOSAPIVO
	 * @return 조회 목록
	 * @exception Exception
	 */
	public MediaiOSAPIFileVO selectMediaInfoDetail(MediaiOSAPIVO vo) throws Exception;
	
	/**
	 * 미디어 목록을 조회한다.
	 * @param VO - 조회할 정보가 담긴 MediaiOSAPIVO
	 * @return 조회 목록
	 * @exception Exception
	 */
	public List<?> selectMediaInfoList(MediaiOSAPIVO vo) throws Exception;
	
	
	/**
	 * 미디어 파일을 조회한다.
	 * @param VO - 조회할 정보가 담긴 MediaiOSAPIFileVO
	 * @return 파일 정보
	 * @exception Exception
	 */
	public boolean selectMediaFileInf(HttpServletResponse response, MediaiOSAPIFileVO vo) throws Exception;
}
