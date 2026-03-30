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

import java.util.List;

import org.egovframe.rte.psl.dataaccess.EgovAbstractMapper;
import org.springframework.stereotype.Repository;

import egovframework.hyb.mbl.nwk.service.NetworkAPIVO;

/**  
 * @Class Name : NetworkAPIDAO.java
 * @Description : 통합 Network API DAO Class
 * @Modification Information  
 * @
 * @  수정일            수정자        수정내용
 * @ ---------        ---------    -------------------------------
 * @ 2025.10.28        통합개발팀    Android/iOS 패키지 통합
 * 
 * @author 디바이스 API 실행환경 팀
 * @since 2025. 10. 28.
 * @version 2.0
 * @see
 * 
 */
@Repository("NetworkAPIDAO")
public class NetworkAPIDAO extends EgovAbstractMapper {

    /**
     * 네트워크 정보를 등록한다.
     * @param vo - 등록할 정보가 담긴 NetworkAPIVO
     * @return 등록 결과
     * @exception Exception
     */
    public int insertNetworkInfo(NetworkAPIVO vo) throws Exception {
        return (Integer)insert("networkAPIDAO.insertNetworkInfo", vo);
    }

    /**
     * 네트워크 정보를 수정한다.
     * @param vo - 수정할 정보가 담긴 NetworkAPIVO
     * @return 수정 결과
     * @exception Exception
     */
    public int updateNetworkInfo(NetworkAPIVO vo) throws Exception {
        return (Integer)update("networkAPIDAO.updateNetworkInfo", vo);
    }

    /**
     * 네트워크 정보를 삭제한다.
     * @param vo - 삭제할 정보가 담긴 NetworkAPIVO
     * @return 삭제 결과
     * @exception Exception
     */
    public int deleteNetworkInfo(NetworkAPIVO vo) throws Exception {
        return (Integer)delete("networkAPIDAO.deleteNetworkInfo", vo);
    }

    /**
     * 네트워크 정보를 조회한다.
     * @param vo - 조회할 정보가 담긴 NetworkAPIVO
     * @return 조회한 네트워크 정보
     * @exception Exception
     */
    public NetworkAPIVO selectNetworkInfo(NetworkAPIVO vo) throws Exception {
        return (NetworkAPIVO) selectOne("networkAPIDAO.selectNetworkInfo", vo);
    }

    /**
     * 네트워크 정보 목록을 조회한다.
     * @param vo - 조회할 정보가 담긴 NetworkAPIVO 또는 NetworkAPIDefaultVO
     * @return 네트워크 정보 목록
     * @exception Exception
     */
    public List<?> selectNetworkInfoList(Object vo) throws Exception {
        return selectList("networkAPIDAO.selectNetworkInfoList", vo);
    }

    /**
     * 네트워크 정보 총 갯수를 조회한다.
     * @param  vo - 조회할 정보가 담긴 NetworkAPIVO 또는 NetworkAPIDefaultVO
     * @return 네트워크 정보 총 갯수
     * @exception
     */
    public int selectNetworkInfoListTotCnt(Object vo) {
        return (Integer) selectOne("networkAPIDAO.selectNetworkInfoListTotCnt", vo);
    }
}

