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
package egovframework.hyb.mbl.nwk.service;

import java.util.List;

/**
 * @Class Name : EgovNetworkAPIService.java
 * @Description : 통합 Network API Service Class
 * @Modification Information
 * @
 * @ 수정일         수정자        수정내용
 * @ ----------   ---------   -----------------------------------------------------------
 *   2026.07.21  이백행          [2026년 컨트리뷰션] 사용하지 않는 import 제거
 */
public interface EgovNetworkAPIService {

    /**
     * 네트워크 정보를 등록한다.
     * @param vo - 등록할 정보가 담긴 NetworkAPIVO
     * @return 등록 결과
     */
    int insertNetworkInfo(NetworkAPIVO vo);

    /**
     * 네트워크 정보를 삭제한다.
     * @param vo - 삭제할 정보가 담긴 NetworkAPIVO
     * @return 삭제 결과
     */
    int deleteNetworkInfo(NetworkAPIVO vo);


    /**
     * 네트워크 정보 목록을 조회한다.
     * @param vo - 조회할 정보가 담긴 VO (NetworkAPIVO 또는 NetworkAPIDefaultVO)
     * @return 네트워크 정보 목록
     */
    List<?> selectNetworkInfoList(Object vo);

    /**
     * 네트워크 정보 총 개수를 조회한다.
     * @param vo - 조회할 정보가 담긴 VO
     * @return 네트워크 정보 총 개수
     */
    int selectNetworkInfoListTotCnt(Object vo);

}

