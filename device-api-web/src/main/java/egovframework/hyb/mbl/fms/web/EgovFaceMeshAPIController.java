package egovframework.hyb.mbl.fms.web;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;

import egovframework.hyb.mbl.fms.service.EgovFaceMeshAPIService;
import egovframework.hyb.mbl.fms.service.FaceMeshAPIVO;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.annotation.Resource;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.DeleteMapping;

@Controller
@Tag(name = "15. FaceMesh Guide Program Service", description = "얼굴 메시 API 관리")
public class EgovFaceMeshAPIController {

	@Resource(name = "EgovFaceMeshAPIService")
	private EgovFaceMeshAPIService egovFaceMeshAPIService;

	private boolean isBlank(String value) {
		return value == null || value.trim().isEmpty();
	}

	private ResponseEntity<Map<String, Object>> uuidRequiredResponse() {
		Map<String, Object> response = new HashMap<>();
		response.put("resultState", "FAIL");
		response.put("resultMessage", "uuid is required");
		return ResponseEntity.badRequest().body(response);
	}

	@Operation(summary = "얼굴 메시 정보 목록 조회", description = "얼굴 메시 정보 목록을 조회합니다.")
	@GetMapping("/fms/selectFaceMeshInfoList.do")
	public ResponseEntity<Map<String, Object>> selectFaceMeshInfoList(
			FaceMeshAPIVO searchVO) throws Exception {
		if (isBlank(searchVO.getUuid())) {
			return uuidRequiredResponse();
		}

		Map<String, Object> response = new HashMap<>();
		List<FaceMeshAPIVO> faceMeshInfoList = egovFaceMeshAPIService.selectFaceMeshInfoList(searchVO);
		response.put("faceMeshInfoList", faceMeshInfoList);
		response.put("resultState", "OK");
		return ResponseEntity.ok(response);
	}

	@Operation(summary = "얼굴 메시 정보 등록", description = "얼굴 메시 정보(얼굴 1행)를 등록합니다.")
	@PostMapping("/fms/insertFaceMeshInfo.do")
	public ResponseEntity<Map<String, Object>> insertFaceMeshInfo(FaceMeshAPIVO sampleVO) throws Exception {
		if (isBlank(sampleVO.getUuid())) {
			return uuidRequiredResponse();
		}
		if (isBlank(sampleVO.getFaceGroupId())) {
			Map<String, Object> response = new HashMap<>();
			response.put("resultState", "FAIL");
			response.put("resultMessage", "faceGroupId is required");
			return ResponseEntity.badRequest().body(response);
		}

		Map<String, Object> response = new HashMap<>();
		int cnt = egovFaceMeshAPIService.insertFaceMeshInfo(sampleVO);
		if (cnt > 0) {
			response.put("resultState", "OK");
			response.put("resultMessage", "insert success");
		} else {
			response.put("resultState", "FAIL");
			response.put("resultMessage", "insert fail");
		}
		return ResponseEntity.ok(response);
	}

	@Operation(summary = "얼굴 메시 정보 삭제", description = "얼굴 메시 정보를 삭제합니다.")
	@DeleteMapping("/fms/deleteFaceMeshInfo.do")
	public ResponseEntity<Map<String, Object>> deleteFaceMeshInfo(FaceMeshAPIVO sampleVO) throws Exception {
		if (isBlank(sampleVO.getUuid())) {
			return uuidRequiredResponse();
		}
		if (sampleVO.getSn() <= 0) {
			Map<String, Object> response = new HashMap<>();
			response.put("resultState", "FAIL");
			response.put("resultMessage", "sn is required");
			return ResponseEntity.badRequest().body(response);
		}

		Map<String, Object> response = new HashMap<>();
		int cnt = egovFaceMeshAPIService.deleteFaceMeshInfo(sampleVO);
		if (cnt > 0) {
			response.put("resultState", "OK");
			response.put("resultMessage", "delete success");
		} else {
			response.put("resultState", "FAIL");
			response.put("resultMessage", "delete fail");
		}
		return ResponseEntity.ok(response);
	}
}
