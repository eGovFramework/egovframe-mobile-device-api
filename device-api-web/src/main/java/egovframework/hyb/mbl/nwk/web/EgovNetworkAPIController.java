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
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.support.SessionStatus;

import egovframework.hyb.mbl.nwk.service.EgovNetworkAPIService;
import egovframework.hyb.mbl.nwk.service.NetworkAPIVO;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.annotation.Resource;

/**
 * 통합 Network API Controller
 * @Modification Information
 * @
 * @ 수정일         수정자        수정내용
 * @ ----------   ---------   -----------------------------------------------------------
 *   2026.07.21  이백행          [2026년 컨트리뷰션] 사용하지 않는 import 제거
 */
@Controller
@Tag(name = "10. Network Guide Program Service", description = "네트워크 API 관리")
public class EgovNetworkAPIController {

	@Resource(name = "EgovNetworkAPIService")
	private EgovNetworkAPIService egovNetworkAPIService;

	@Resource(name = "propertiesService")
	protected EgovPropertyService propertiesService;

	@GetMapping("/nwk/htmlLoad.do")
	public ResponseEntity<?> htmlLoad(ModelMap model) {
		Map<String, Object> response = new HashMap<>();
		response.put("serverUrl", propertiesService.getString("serverContext"));
		response.put("resultState","OK");
		return ResponseEntity.ok(response);
	}

	@Operation(summary = "네트워크 정보 목록 조회", description = "네트워크 정보 목록을 조회합니다.")
	@GetMapping("/nwk/selectNetworkInfoList.do")
	public ResponseEntity<?> selectNetworkInfoList(@ModelAttribute("searchNetworkVO") NetworkAPIVO searchNetworkVO, ModelMap model) {
		Map<String, Object> response = new HashMap<>();
		List<?> networkInfoList = egovNetworkAPIService.selectNetworkInfoList(searchNetworkVO);
		response.put("networkInfoList", networkInfoList);
		response.put("resultState","OK");
		return ResponseEntity.ok(response);
	}

	@Operation(summary = "네트워크 세부정보 등록", description = "네트워크 세부정보를 등록합니다.")
	@PostMapping("/nwk/insertNetworkInfo.do")
	public ResponseEntity<?> insertNetworkInfo(NetworkAPIVO networkVO, BindingResult bindingResult, Model model, SessionStatus status) {
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
	@DeleteMapping("/nwk/deleteNetworkInfo.do")
	public ResponseEntity<?> deleteNetworkInfo(NetworkAPIVO networkVO, SessionStatus status) {
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
