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
package egovframework.hyb.ios.itf.service.impl;

import org.springframework.stereotype.Repository;

import egovframework.com.cmm.mapper.EgovComAbstractDAO;
import egovframework.hyb.ios.itf.service.InterfaceiOSAPIVO;


/**  
 * @Class Name : InterfaceiOSAPIDAO.java
 * @Description : InterfaceiOSAPIDAO DAO Class
 * @Modification Information  
 * @
 * @  수정일                 수정자                 수정내용
 * @ 
 * @ 2012.07.11    이한철                  최초생성
 * 
 * @author 모바일 디바이스 API 팀
 * @since 2012. 07. 11
 * @version 1.0
 * @see
 * 
 *  Copyright (C) by MOPAS All right reserved.
 */

@Repository("InterfaceiOSAPIDAO")
public class InterfaceiOSAPIDAO extends EgovComAbstractDAO {

    /**
     * 해당 ID로 가입된 정보가 있는지 확인 한다.
     * 
     * @param vo
     *            - 조회할 정보가 담긴 InterfaceiOSAPIVO
     * @return 인터페이스 정보 갯수
     * @exception
     */
    public int selectInterfaceInfoListTotCnt(InterfaceiOSAPIVO vo) {
        return (Integer) selectOne(
                "interfaceiOSAPIDAO.selectInterfaceInfoListCnt", vo);
    }

    /**
     * 회원 정보를 등록한다.
     * 
     * @param vo
     *            - 등록할 정보가 담긴 InterfaceiOSAPIVO
     * @return 등록 결과
     * @exception Exception
     */
    public int insertInterfaceInfo(InterfaceiOSAPIVO vo) throws Exception {
        return (Integer) insert("interfaceiOSAPIDAO.insertInterfaceInfo", vo);
    }

    /**
     * 로그인을 한다.
     * 
     * @param vo
     *            - 로그인할 정보가 담긴 InterfaceiOSAPIVO
     * @return 로그인 결과
     * @exception Exception
     */
    public InterfaceiOSAPIVO selectInterfaceInfo(InterfaceiOSAPIVO vo)
            throws Exception {
        return (InterfaceiOSAPIVO) selectOne(
                "interfaceiOSAPIDAO.selectInterfaceInfo", vo);
    }

    /**
     * 회원탈퇴를 한다.
     * 
     * @param vo
     *            - 탈퇴할 정보가 담긴 InterfaceiOSAPIVO
     * @return 회원탈퇴 결과
     * @exception Exception
     */
    public int deleteInterfaceInfo(InterfaceiOSAPIVO vo) throws Exception {
        return delete("interfaceiOSAPIDAO.deleteInterfaceInfo", vo);
    }

}
