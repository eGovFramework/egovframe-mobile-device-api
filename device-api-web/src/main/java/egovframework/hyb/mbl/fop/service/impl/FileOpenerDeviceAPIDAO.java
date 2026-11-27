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

import org.egovframe.rte.psl.dataaccess.mapper.EgovMapper;

import java.util.List;


import egovframework.hyb.mbl.fop.service.FileOpenerDeviceAPIVO;


/**
 * FileOpener DAO
 *
 * 수정이력
 * 2016.07.11 장성호 최초생성
 * 2026.06.24 이백행 [2026년 컨트리뷰션] 불필요한 예외 제거
 */

@EgovMapper("FileOpenerDeviceAPIDAO")
public interface FileOpenerDeviceAPIDAO {

    /**
	 * Push Device 정보 목록을 조회한다.
	 * @param vo - 조회할 정보가 담긴 PushDeviceAPIDefaultVO
	 * @return Push Device 정보 목록
	 */
    public List<FileOpenerDeviceAPIVO> selectFileOpenerList(FileOpenerDeviceAPIVO searchVO);


    public int insertFileOpenerList(FileOpenerDeviceAPIVO vo);


}
