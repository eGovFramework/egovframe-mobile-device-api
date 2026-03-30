package egovframework.hyb.mbl.nwk.web;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.egovframe.rte.fdl.property.EgovPropertyService;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.support.SessionStatus;

import egovframework.hyb.mbl.nwk.service.EgovNetworkAPIService;
import egovframework.hyb.mbl.nwk.service.NetworkAPIVO;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.annotation.Resource;
import jakarta.servlet.http.HttpServletResponse;

/**
 * 통합 Network API Controller
 */
@Controller
@Tag(name = "10. Network Guide Program Service", description = "네트워크 API 관리")
public class EgovNetworkAPIController {

	@Resource(name = "EgovNetworkAPIService")
	private EgovNetworkAPIService egovNetworkAPIService;

	@Resource(name = "propertiesService")
	protected EgovPropertyService propertiesService;

	@RequestMapping("/nwk/htmlLoad.do")
	public ResponseEntity<?> htmlLoad(ModelMap model) throws Exception {
		Map<String, Object> response = new HashMap<>();
		response.put("serverUrl", propertiesService.getString("serverContext"));
		response.put("resultState","OK");
		return ResponseEntity.ok(response);
	}

	@Operation(summary = "네트워크 정보 목록 조회", description = "네트워크 정보 목록을 조회합니다.")
	@RequestMapping(value = "/nwk/selectNetworkInfoList.do", method = RequestMethod.GET)
	public ResponseEntity<?> selectNetworkInfoList(@ModelAttribute("searchNetworkVO") NetworkAPIVO searchNetworkVO, ModelMap model) throws Exception {
		Map<String, Object> response = new HashMap<>();
		List<?> networkInfoList = egovNetworkAPIService.selectNetworkInfoList(searchNetworkVO);
		response.put("networkInfoList", networkInfoList);
		response.put("resultState","OK");
		return ResponseEntity.ok(response);
	}

	@Operation(summary = "네트워크 세부정보 등록", description = "네트워크 세부정보를 등록합니다.")
	@RequestMapping(value = "/nwk/insertNetworkInfo.do", method = RequestMethod.POST)
	public ResponseEntity<?> insertNetworkInfo(NetworkAPIVO networkVO, BindingResult bindingResult, Model model, SessionStatus status) throws Exception {
		Map<String, Object> response = new HashMap<>();
		int cnt = egovNetworkAPIService.insertNetworkInfo(networkVO);
		if(cnt > 0) {
			response.put("resultState","OK");
			response.put("resultMessage","insert success");
		} else {
			response.put("resultState","FAIL");
			response.put("resultMessage","insert fail");
		}
		return ResponseEntity.ok(response);
	}

	@Operation(summary = "네트워크 세부정보 삭제", description = "네트워크 세부정보를 삭제합니다.")
	@RequestMapping(value = "/nwk/deleteNetworkInfo.do", method = RequestMethod.DELETE)
	public ResponseEntity<?> deleteNetworkInfo(NetworkAPIVO networkVO, SessionStatus status) throws Exception {
		Map<String, Object> response = new HashMap<>();
		int cnt = egovNetworkAPIService.deleteNetworkInfo(networkVO);
		if(cnt > 0) {
			response.put("resultState","OK");
			response.put("resultMessage","delete success");
		} else {
			response.put("resultState","FAIL");
			response.put("resultMessage","delete fail");
		}
		return ResponseEntity.ok(response);
	}

}
