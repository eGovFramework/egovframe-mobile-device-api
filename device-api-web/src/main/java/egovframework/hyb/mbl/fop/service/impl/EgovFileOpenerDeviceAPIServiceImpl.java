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
package egovframework.hyb.mbl.fop.service.impl;

import java.util.List;

import org.egovframe.rte.fdl.cmmn.EgovAbstractServiceImpl;
import org.springframework.stereotype.Service;

import egovframework.hyb.mbl.fop.service.EgovFileOpenerDeviceAPIService;
import egovframework.hyb.mbl.fop.service.FileOpenerDeviceAPIVO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;


/**  
 * @Class Name : EgovFileOpenerDeviceAPIServiceImpl.java
 * @Description : EgovFileOpenerDeviceAPIServiceImpl Class
 * @Modification Information  
 * @
 * @  수정일       수정자                   수정내용
 * @ ---------   ---------   -------------------------------
 * @ 2016.07.11   장성호                   최초생성
 *   2026.07.21  이백행          [2026년 컨트리뷰션] 사용하지 않는 import 제거
 * 
 * @author 디바이스 API 실행환경 개발팀
 * @since 2016. 07.11
 * @version 1.0
 * @see
 * 
 *  Copyright (C) by Ministry of Interior All right reserved.
 */

@Service
@RequiredArgsConstructor
@Slf4j
public class EgovFileOpenerDeviceAPIServiceImpl extends EgovAbstractServiceImpl implements EgovFileOpenerDeviceAPIService {
	
	/** FileOpenerDeviceAPIDAO */
    private final FileOpenerDeviceAPIDAO fileOpenerDeviceAPIDAO;

    /**
	 * 문서목록을 조회한다.
	 * @param VO - 조회할 정보가 담긴 FileOpenerDeviceAPIVO
	 * @return 문서 조회 목록 
	 */
    public List<FileOpenerDeviceAPIVO> selectFileOpenerList(FileOpenerDeviceAPIVO searchVO) {
		log.debug("uuid={}", searchVO.getUuid());
		return fileOpenerDeviceAPIDAO.selectFileOpenerList(searchVO);
	}
    
    
    
}
