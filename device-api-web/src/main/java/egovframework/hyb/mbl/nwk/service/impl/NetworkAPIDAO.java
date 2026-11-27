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
package egovframework.hyb.mbl.nwk.service.impl;

import org.egovframe.rte.psl.dataaccess.mapper.EgovMapper;

import java.util.List;


import egovframework.hyb.mbl.nwk.service.NetworkAPIVO;

/**
 * 통합 Network API DAO
 *
 * 수정이력
 * 2025.10.28 통합개발팀 Android/iOS 패키지 통합
 * 2026.06.24 이백행 [2026년 컨트리뷰션] 불필요한 예외 제거
 */
@EgovMapper("NetworkAPIDAO")
public interface NetworkAPIDAO {

    /**
     * 네트워크 정보를 등록한다.
     * @param vo - 등록할 정보가 담긴 NetworkAPIVO
     * @return 등록 결과
     */
    public int insertNetworkInfo(NetworkAPIVO vo);


    /**
     * 네트워크 정보를 수정한다.
     * @param vo - 수정할 정보가 담긴 NetworkAPIVO
     * @return 수정 결과
     */
    public int updateNetworkInfo(NetworkAPIVO vo);


    /**
     * 네트워크 정보를 삭제한다.
     * @param vo - 삭제할 정보가 담긴 NetworkAPIVO
     * @return 삭제 결과
     */
    public int deleteNetworkInfo(NetworkAPIVO vo);


    /**
     * 네트워크 정보를 조회한다.
     * @param vo - 조회할 정보가 담긴 NetworkAPIVO
     * @return 조회한 네트워크 정보
     */
    public NetworkAPIVO selectNetworkInfo(NetworkAPIVO vo);


    /**
     * 네트워크 정보 목록을 조회한다.
     * @param vo - 조회할 정보가 담긴 NetworkAPIVO 또는 NetworkAPIDefaultVO
     * @return 네트워크 정보 목록
     */
    public List<NetworkAPIVO> selectNetworkInfoList(Object vo);


    /**
     * 네트워크 정보 총 개수를 조회한다.
     * @param  vo - 조회할 정보가 담긴 NetworkAPIVO 또는 NetworkAPIDefaultVO
     * @return 네트워크 정보 총 개수
     */
    public int selectNetworkInfoListTotCnt(Object vo);

}

