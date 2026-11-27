package egovframework.hyb.mbl.nwk.web;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;

import egovframework.hyb.mbl.nwk.service.EgovNetworkAPIService;
import egovframework.hyb.mbl.nwk.service.NetworkAPIVO;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.annotation.Resource;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.DeleteMapping;

/**
 * 통합 Network API Controller
 */
@Controller
@Tag(name = "09. Network Guide Program Service", description = "네트워크 API 관리")
public class EgovNetworkAPIController {

	@Resource(name = "EgovNetworkAPIService")
	private EgovNetworkAPIService egovNetworkAPIService;

	@Value("${Globals.serverContext}")
	private String serverContext;

	@GetMapping("/nwk/htmlLoad.do")
	public ResponseEntity<Map<String, Object>> htmlLoad() throws Exception {
		Map<String, Object> response = new HashMap<>();
		response.put("serverUrl", serverContext);
		response.put("resultState","OK");
		return ResponseEntity.ok(response);
	}

	@Operation(summary = "네트워크 정보 목록 조회", description = "네트워크 정보 목록을 조회합니다.")
	@GetMapping("/nwk/selectNetworkInfoList.do")
	public ResponseEntity<Map<String, Object>> selectNetworkInfoList(NetworkAPIVO searchNetworkVO) throws Exception {
		Map<String, Object> response = new HashMap<>();
		List<NetworkAPIVO> networkInfoList = egovNetworkAPIService.selectNetworkInfoList(searchNetworkVO);
		response.put("networkInfoList", networkInfoList);
		response.put("resultState","OK");
		return ResponseEntity.ok(response);
	}

	@Operation(summary = "네트워크 세부정보 등록", description = "네트워크 세부정보를 등록합니다.")
	@PostMapping("/nwk/insertNetworkInfo.do")
	public ResponseEntity<Map<String, Object>> insertNetworkInfo(NetworkAPIVO networkVO) throws Exception {
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
	public ResponseEntity<Map<String, Object>> deleteNetworkInfo(NetworkAPIVO networkVO) throws Exception {
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
