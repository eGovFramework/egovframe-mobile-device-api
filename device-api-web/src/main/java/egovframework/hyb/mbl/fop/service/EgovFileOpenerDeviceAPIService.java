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
package egovframework.hyb.mbl.fop.service;

import java.util.List;

/**
 * EgovPushAPIService
 *
 * 수정이력
 * 2016.07.11 장성호 최초생성
 * 2026.07.21 이백행 [2026년 컨트리뷰션] 사용하지 않는 import 제거
 */
public interface EgovFileOpenerDeviceAPIService {
    
    /**
	 * Push Device 정보 목록을 조회한다.
	 * @param VO - 조회할 정보가 담긴 PushDeviceAPIDefaultVO
	 * @return 네트워크 정보 목록
	 */
	List<FileOpenerDeviceAPIVO> selectFileOpenerList(FileOpenerDeviceAPIVO searchVO);

	/**
	 * 업로드된 파일을 문서 뷰어 목록에 등록한다.
	 * @param vo uuid, fileSn
	 * @return 등록 건수
	 */
	int insertFileOpenerList(FileOpenerDeviceAPIVO vo);
	
}
