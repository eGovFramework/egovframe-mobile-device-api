package egovframework.hyb.mbl.gps.web;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;

import egovframework.hyb.mbl.gps.service.EgovGPSAPIService;
import egovframework.hyb.mbl.gps.service.GPSAPIVO;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

/**
 * 통합 GPS API Controller
 */
@Controller
@RequiredArgsConstructor
@Slf4j
@Tag(name = "07. GPS Guide Program Service", description = "GPS API 관리")
public class EgovGPSAPIController {

    private final EgovGPSAPIService egovGPSAPIService;

    @Operation(summary = "GPS 정보 목록 조회", description = "GPS 정보 목록을 조회합니다.")
    @GetMapping("/gps/selectGPSInfoList.do")
    public ResponseEntity<Map<String, Object>> selectGPSInfoList(GPSAPIVO searchVO) {
        log.debug("uuid={}", searchVO.getUuid());
        Map<String, Object> response = new HashMap<>();
        List<GPSAPIVO> gpsInfoList = egovGPSAPIService.selectGPSInfoList(searchVO);
        response.put("gpsInfoList", gpsInfoList);
        response.put("resultState", "OK");
        return ResponseEntity.ok(response);
    }

    @Operation(summary = "GPS 정보 등록", description = "GPS 정보를 등록합니다.")
    @PostMapping("/gps/insertGPSInfo.do")
    public ResponseEntity<Map<String, Object>> insertGPSInfo(GPSAPIVO gpsVO) {
        Map<String, Object> response = new HashMap<>();
        
        int cnt = egovGPSAPIService.insertGPSInfo(gpsVO);
        if(cnt > 0) {
			response.put("resultState","OK");
			response.put("resultMessage","insert success");
		} else {
			response.put("resultState","FAIL");
			response.put("resultMessage","insert fail");
		}
        return ResponseEntity.ok(response);
    }

    @Operation(summary = "GPS 정보 삭제", description = "GPS 정보를 삭제합니다.")
    @DeleteMapping("/gps/deleteGPSInfo.do")
    public ResponseEntity<Map<String, Object>> deleteGPSInfo(GPSAPIVO sampleVO) {
    	Map<String, Object> response = new HashMap<>();
    	int cnt = egovGPSAPIService.deleteGPSInfo(sampleVO);
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
