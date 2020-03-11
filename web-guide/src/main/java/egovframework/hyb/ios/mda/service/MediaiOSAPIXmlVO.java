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

import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;

/**  
 * @Class Name : MediaiOSXmlVO.java
 * @Description : MediaiOSXmlVO Class
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
@XmlRootElement
public class MediaiOSAPIXmlVO {
	
	/** 성공 여부 */
	private String resultState;
	
	/** 서버 Context */
	private String serverContext;
	
	/** 다운로드 Context */
	private String downloadContext;
	
	/** 미디어 정보 */
	private MediaiOSAPIFileVO mediaiOSAPIFileVO;
	
	/** 목록 정보 */
	private List<MediaiOSAPIVO> mediaiOSAPIVOList;

	/**
	 * @return serverContext을 반환한다.
	 */
	public String getServerContext() {
		return serverContext;
	}

	/**
	 * @param 파라미터 serverContext을 serverContext에 설정한다.
	 */
	@XmlElement
	public void setServerContext(String serverContext) {
		this.serverContext = serverContext;
	}
	
	/**
	 * @return downloadContext을 반환한다.
	 */
	public String getDownloadContext() {
		return downloadContext;
	}

	/**
	 * @return mediaiOSAPIFileVO을 반환한다.
	 */
	public MediaiOSAPIFileVO getMediaiOSAPIFileVO() {
		return mediaiOSAPIFileVO;
	}

	/**
	 * @param 파라미터 mediaiOSAPIFileVO을 mediaiOSAPIFileVO에 설정한다.
	 */
	@XmlElement
	public void setMediaiOSAPIFileVO(MediaiOSAPIFileVO mediaiOSAPIFileVO) {
		this.mediaiOSAPIFileVO = mediaiOSAPIFileVO;
	}

	/**
	 * @param 파라미터 downloadContext을 downloadContext에 설정한다.
	 */
	@XmlElement
	public void setDownloadContext(String downloadContext) {
		this.downloadContext = downloadContext;
	}

	/**
	 * @return mediaiOSAPIVOList을 반환한다.
	 */
	public List<MediaiOSAPIVO> getMediaiOSAPIVOList() {
		return mediaiOSAPIVOList;
	}

	/**
	 * @param 파라미터 mediaiOSAPIVOList을 mediaiOSAPIVOList에 설정한다.
	 */
	@XmlElement
	public void setMediaiOSAPIVOList(
			List<MediaiOSAPIVO> mediaiOSAPIVOList) {
		this.mediaiOSAPIVOList = mediaiOSAPIVOList;
	}

	public void setResultState(String resultState) {
		this.resultState = resultState;
	}

	public String getResultState() {
		return resultState;
	}
	
	
}
