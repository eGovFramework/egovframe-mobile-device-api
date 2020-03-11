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
package egovframework.hyb.add.pki.web;

import java.util.List;

import egovframework.hyb.add.pki.service.EgovPKIAndroidAPIService;
import egovframework.hyb.add.pki.service.PKIAndroidAPIDefaultVO;
import egovframework.hyb.add.pki.service.PKIAndroidAPIVO;
import egovframework.hyb.add.pki.service.PKIAndroidAPIVOList;
import egovframework.rte.fdl.property.EgovPropertyService;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.support.SessionStatus;

/**  
 * @Class Name : EgovPKIAndroidAPIController
 * @Description : EgovPKIAndroidAPIController Controller Class
 * @Modification Information  
 * @
 * @  수정일                 수정자                 수정내용
 * @ ---------   ---------   -------------------------------
 * @ 2012.07.23    나신일                  최초생성
 * 
 * @author 모바일 디바이스 API 팀
 * @since 2012. 07. 23
 * @version 1.0
 * @see
 * 
 *  Copyright (C) by MOPAS All right reserved.
 */

@Controller
public class EgovPKIAndroidAPIController {

	/** EgovPKIAPIService */
	@Resource(name = "EgovPKIAndroidAPIService")
	private EgovPKIAndroidAPIService egovPKIAPIService;

	/** propertiesService */
	@Resource(name = "propertiesService")
	protected EgovPropertyService propertiesService;

	/**
	 * pki 정보 목록을 조회한다.
	 * 
	 * @param searchPKIVO
	 *            - 조회할 정보가 담긴 PKIAndroidAPIVO
	 * @param model
	 * @return ModelAndView
	 * @exception Exception
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping("/pki/xml/pkiInfoList.do")
	public @ResponseBody
	PKIAndroidAPIVOList selectPKIInfoListXml(@ModelAttribute("searchPKIVO") PKIAndroidAPIDefaultVO searchVO, ModelMap model) throws Exception {

		List<PKIAndroidAPIVO> pkiInfoList = (List<PKIAndroidAPIVO>) egovPKIAPIService.selectPKIInfoList(searchVO);

		PKIAndroidAPIVOList pkiAndroidAPIVOList = new PKIAndroidAPIVOList();
		pkiAndroidAPIVOList.setPKIInfoList(pkiInfoList);

		return pkiAndroidAPIVOList;
	}

	@RequestMapping("/pki/xml/addPKIInfo.do")
	public @ResponseBody
	PKIAndroidAPIVO addPKIInfoXml(@ModelAttribute("searchVO") PKIAndroidAPIDefaultVO searchVO, PKIAndroidAPIVO PKIVO, BindingResult bindingResult, Model model, SessionStatus status)
			throws Exception {
		String sClientName = egovPKIAPIService.verifyCert(PKIVO);
		PKIAndroidAPIVO pkiAPIVO = new PKIAndroidAPIVO();

		if (sClientName.length() < 0) {
			pkiAPIVO.setResultState("FAIL");
			pkiAPIVO.setResultMessage("인증에 실패하였습니다.");
			return pkiAPIVO;
		}

		pkiAPIVO = PKIVO;
		pkiAPIVO.setDn(sClientName);
		pkiAPIVO.setSign(null);

		int success = egovPKIAPIService.insertPKIInfo(pkiAPIVO);
		if (success > 0) {
			pkiAPIVO.setResultState("OK");
			pkiAPIVO.setResultMessage("인증에 성공하였습니다.");
		} else {
			pkiAPIVO.setResultState("OK");
			pkiAPIVO.setResultMessage("저장에 실패하였습니다.");
		}

		return pkiAPIVO;
	}

}
