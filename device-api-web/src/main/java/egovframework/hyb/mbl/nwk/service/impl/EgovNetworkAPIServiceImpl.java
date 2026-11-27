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

import org.egovframe.rte.fdl.cmmn.EgovAbstractServiceImpl;
import org.springframework.stereotype.Service;

import egovframework.hyb.mbl.nwk.service.EgovNetworkAPIService;
import egovframework.hyb.mbl.nwk.service.NetworkAPIVO;
import jakarta.annotation.Resource;

/**
 * 통합 Network API ServiceImpl
 *
 * 수정이력
 * 2025.10.28 통합개발팀 Android/iOS 패키지 통합
 */
@Service("EgovNetworkAPIService")
public class EgovNetworkAPIServiceImpl extends EgovAbstractServiceImpl implements EgovNetworkAPIService {

    @Resource(name = "NetworkAPIDAO")
    private NetworkAPIDAO networkAPIDAO;

    @Override
    public int insertNetworkInfo(NetworkAPIVO vo) {
        return networkAPIDAO.insertNetworkInfo(vo);
    }

    @Override
    public int deleteNetworkInfo(NetworkAPIVO vo) {
        return networkAPIDAO.deleteNetworkInfo(vo);
    }

    @Override
    public List<NetworkAPIVO> selectNetworkInfoList(Object vo) {
        return networkAPIDAO.selectNetworkInfoList(vo);
    }

    @Override
    public int selectNetworkInfoListTotCnt(Object vo) {
        return networkAPIDAO.selectNetworkInfoListTotCnt(vo);
    }
}
