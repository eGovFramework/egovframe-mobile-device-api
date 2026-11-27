package egovframework.hyb.mbl.cps.web;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;

import egovframework.hyb.mbl.cps.service.CompassAPIVO;
import egovframework.hyb.mbl.cps.service.EgovCompassAPIService;
import egovframework.hyb.utils.DeviceUuidCheck;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.annotation.Resource;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.DeleteMapping;

/**
 * 통합 Compass API Controller
 */
@Controller
@Tag(name = "02. Compass Guide Program Service", description = "나침반 API 관리")
public class EgovCompassAPIController {

    @Resource(name = "EgovCompassAPIService")
    private EgovCompassAPIService egovCompassAPIService;

    @Operation(summary = "나침반 정보 목록 조회", description = "나침반 정보 목록을 조회합니다.")
    @GetMapping("/cps/selectCompassInfoList.do")
    public ResponseEntity<Map<String, Object>> selectCompassInfoList(CompassAPIVO searchVO) throws Exception {
        if (DeviceUuidCheck.isBlank(searchVO.getUuid())) {
            return DeviceUuidCheck.requiredResponse();
        }
        Map<String, Object> response = new HashMap<>();
        List<CompassAPIVO> compassInfoList = egovCompassAPIService.selectCompassInfoList(searchVO);
        response.put("compassInfoList", compassInfoList);
        response.put("resultState", "OK");
        return ResponseEntity.ok(response);
    }

    @Operation(summary = "나침반 정보 등록", description = "나침반 정보를 등록합니다.")
    @PostMapping("/cps/insertCompassInfo.do")
    public ResponseEntity<Map<String, Object>> insertCompassInfo(CompassAPIVO compassVO) throws Exception {
        if (DeviceUuidCheck.isBlank(compassVO.getUuid())) {
            return DeviceUuidCheck.requiredResponse();
        }
        Map<String, Object> response = new HashMap<>();
        int cnt = egovCompassAPIService.insertCompassInfo(compassVO);
        if(cnt > 0) {
			response.put("resultState","OK");
			response.put("resultMessage","insert success");
		} else {
			response.put("resultState","FAIL");
			response.put("resultMessage","insert fail");
		}
        return ResponseEntity.ok(response);
    }

    @Operation(summary = "나침반 정보 삭제", description = "나침반 정보를 삭제합니다.")
    @DeleteMapping("/cps/deleteCompassInfo.do")
    public ResponseEntity<Map<String, Object>> deleteCompassInfo(CompassAPIVO compassVO) throws Exception {
        if (DeviceUuidCheck.isBlank(compassVO.getUuid())) {
            return DeviceUuidCheck.requiredResponse();
        }
        Map<String, Object> response = new HashMap<>();
        int cnt = egovCompassAPIService.deleteCompassInfo(compassVO);
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
