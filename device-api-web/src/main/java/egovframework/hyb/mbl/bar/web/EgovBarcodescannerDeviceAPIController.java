package egovframework.hyb.mbl.bar.web;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;

import egovframework.hyb.mbl.bar.service.BarcodescannerAPIVO;
import egovframework.hyb.mbl.bar.service.EgovBarcodescannerAPIService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.annotation.Resource;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.DeleteMapping;

@Controller
@Tag(name = "14. BarcodeScanner Guide Program Service", description = "바코드 스캐너 API 관리")
public class EgovBarcodescannerDeviceAPIController {

	@Resource(name = "EgovBarcodescannerAPIService")
	private EgovBarcodescannerAPIService egovBarcodescannerAPIService;

	private boolean isBlank(String value) {
		return value == null || value.trim().isEmpty();
	}

	private ResponseEntity<Map<String, Object>> uuidRequiredResponse() {
		Map<String, Object> response = new HashMap<>();
		response.put("resultState", "FAIL");
		response.put("resultMessage", "uuid is required");
		return ResponseEntity.badRequest().body(response);
	}

	@Operation(summary = "바코드 정보 목록 조회", description = "바코드 정보 목록을 조회합니다.")
	@GetMapping("/bar/selectBarcodeInfoList.do")
	public ResponseEntity<Map<String, Object>> selectBarcodeInfoList(BarcodescannerAPIVO searchVO) throws Exception {
		if (isBlank(searchVO.getUuid())) {
			return uuidRequiredResponse();
		}

		Map<String, Object> response = new HashMap<>();
		List<BarcodescannerAPIVO> barcodeInfoList = egovBarcodescannerAPIService.selectBarcodeInfoList(searchVO);
		response.put("barcodeInfoList", barcodeInfoList);
		response.put("resultState", "OK");
		return ResponseEntity.ok(response);
	}

	@Operation(summary = "바코드 정보 등록", description = "바코드 정보를 등록합니다.")
	@PostMapping("/bar/insertBarcodeInfo.do")
	public ResponseEntity<Map<String, Object>> insertBarcodeInfo(BarcodescannerAPIVO sampleVO) throws Exception {
		if (isBlank(sampleVO.getUuid())) {
			return uuidRequiredResponse();
		}

		Map<String, Object> response = new HashMap<>();
		int cnt = egovBarcodescannerAPIService.insertBarcodeInfo(sampleVO);
		if (cnt > 0) {
			response.put("resultState", "OK");
			response.put("resultMessage", "insert success");
		} else {
			response.put("resultState", "FAIL");
			response.put("resultMessage", "insert fail");
		}
		return ResponseEntity.ok(response);
	}

	@Operation(summary = "바코드 정보 삭제", description = "바코드 정보를 삭제합니다.")
	@DeleteMapping("/bar/deleteBarcodeInfo.do")
	public ResponseEntity<Map<String, Object>> deleteBarcodeInfo(BarcodescannerAPIVO sampleVO) throws Exception {
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
		int cnt = egovBarcodescannerAPIService.deleteBarcodeInfo(sampleVO);
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
