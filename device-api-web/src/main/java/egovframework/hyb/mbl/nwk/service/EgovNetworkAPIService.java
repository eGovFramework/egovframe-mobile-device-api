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

import jakarta.servlet.http.HttpServletResponse;

public interface EgovNetworkAPIService {

    /**
     * 네트워크 정보를 등록한다.
     * @param vo - 등록할 정보가 담긴 NetworkAPIVO
     * @return 등록 결과
     * @exception Exception
     */
    int insertNetworkInfo(NetworkAPIVO vo) throws Exception;

    /**
     * 네트워크 정보를 삭제한다.
     * @param vo - 삭제할 정보가 담긴 NetworkAPIVO
     * @return 삭제 결과
     * @exception Exception
     */
    int deleteNetworkInfo(NetworkAPIVO vo) throws Exception;


    /**
     * 네트워크 정보 목록을 조회한다.
     * @param vo - 조회할 정보가 담긴 VO (NetworkAPIVO 또는 NetworkAPIDefaultVO)
     * @return 네트워크 정보 목록
     * @exception Exception
     */
    List<?> selectNetworkInfoList(Object vo) throws Exception;

    /**
     * 네트워크 정보 총 갯수를 조회한다.
     * @param vo - 조회할 정보가 담긴 VO
     * @return 네트워크 정보 총 갯수
     * @exception
     */
    int selectNetworkInfoListTotCnt(Object vo);

}

