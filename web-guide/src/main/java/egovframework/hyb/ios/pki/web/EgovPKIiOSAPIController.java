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
package egovframework.hyb.ios.pki.web;

import java.util.List;

import egovframework.hyb.ios.pki.service.EgovPKIiOSAPIService;
import egovframework.hyb.ios.pki.service.PKIiOSAPIDefaultVO;
import egovframework.hyb.ios.pki.service.PKIiOSAPIVO;

import egovframework.rte.fdl.property.EgovPropertyService;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.support.SessionStatus;
import org.springframework.web.servlet.ModelAndView;

/**  
 * @Class Name : EgovPKIiOSAPIController
 * @Description : EgovPKIiOSAPIController Controller Class
 * @Modification Information  
 * @
 * @  수정일                 수정자                 수정내용
 * @ 
 * @ 2012.07.16    이한철                  최초생성
 * 
 * @author 모바일 디바이스 API 팀
 * @since 2012. 07. 11
 * @version 1.0
 * @see
 * 
 *  Copyright (C) by MOPAS All right reserved.
 */

@Controller
public class EgovPKIiOSAPIController {

    /** EgovPKIAPIService */
    @Resource(name = "EgovPKIiOSAPIService")
    private EgovPKIiOSAPIService egovPKIAPIService;

    /** propertiesService */
    @Resource(name = "propertiesService")
    protected EgovPropertyService propertiesService;

    /**
     * pki 정보 목록을 조회한다.
     * 
     * @param searchPKIVO
     *            - 조회할 정보가 담긴 PKIiOSAPIDefaultVO
     * @param model
     * @return ModelAndView
     * @exception Exception
     */
    @RequestMapping(value = "/pki/pkiInfoList.do")
    public ModelAndView selectPKIInfoList(
            @ModelAttribute("searchPKIVO") PKIiOSAPIDefaultVO searchVO,
            ModelMap model) throws Exception {

        ModelAndView jsonView = new ModelAndView("jsonView");
        List<?> pkiInfoList = egovPKIAPIService.selectPKIInfoList(searchVO);

        jsonView.addObject("pkiInfoList", pkiInfoList);
        jsonView.addObject("resultState", "OK");

        return jsonView;
    }

    /**
     * 인증서로그인한 정보를 등록한다.
     * 
     * @param searchVO
     *            - 등록할 정보가 담긴 PKIAPIDefaultVO
     * @param status
     * @return "forward:/pki/addPKIInfo.do"
     * @exception Exception
     */
    /**
     * @RequestMapping("/pki/addPKIiOSInfo.do") public ModelAndView addPKIInfo2(
     * @ModelAttribute("searchPKIVO") PKIiOSAPIDefaultVO searchVO, PKIiOSAPIVO
     *                                PKIVO, BindingResult bindingResult, Model
     *                                model, SessionStatus status) throws
     *                                Exception {
     * 
     *                                ModelAndView jsonView = new
     *                                ModelAndView("jsonView");
     * 
     *                                int success =
     *                                EgovPKIAPIService.insertPKIInfo(PKIVO);
     *                                if(success > 0) {
     *                                jsonView.addObject("resultState","OK");
     *                                jsonView
     *                                .addObject("resultMessage","저장에 성공하였습니다."
     *                                ); } else {
     *                                jsonView.addObject("resultState","FAIL");
     *                                jsonView
     *                                .addObject("resultMessage","저장에 실패하였습니다."
     *                                ); }
     * 
     *                                return jsonView; }
     */

    @RequestMapping("/pki/addPKIiOSInfo.do")
    public ModelAndView addPKIInfo(
            @ModelAttribute("searchPKIVO") PKIiOSAPIDefaultVO searchVO,
            PKIiOSAPIVO PKIVO, BindingResult bindingResult, Model model,
            SessionStatus status) throws Exception {
        String sClientName = egovPKIAPIService.verifyCert(PKIVO);
        ModelAndView jsonView = new ModelAndView("jsonView");

        if (sClientName == null) {
            jsonView.addObject("resultState", "FAIL");
            jsonView.addObject("resultMessage", "인증에 실패하였습니다.");
            return jsonView;
        }

        PKIVO.setDn(sClientName);

        int success = egovPKIAPIService.insertPKIInfo(PKIVO);
        if (success > 0) {
            jsonView.addObject("resultState", "OK");
            jsonView.addObject("dn", sClientName);
            jsonView.addObject("resultMessage", "인증에 성공하였습니다.");
        } else {
            jsonView.addObject("resultState", "FAIL");
            jsonView.addObject("resultMessage", "인증에 실패하였습니다.");
        }

        return jsonView;
    }

}
