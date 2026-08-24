package egovframework.hyb.mbl.dvc.web;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;

import egovframework.hyb.mbl.dvc.service.DeviceAPIVO;
import egovframework.hyb.mbl.dvc.service.EgovDeviceAPIService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

/**
 * 통합 Device API Controller
 */
@Controller
@RequiredArgsConstructor
@Slf4j
@Tag(name = "05. DeviceInfo Guide Program Service", description = "디바이스 API 관리")
public class EgovDeviceAPIController {

    private final EgovDeviceAPIService egovDeviceAPIService;

    @Operation(summary = "디바이스 정보 목록 조회", description = "디바이스 정보 목록을 조회합니다.")
    @GetMapping("/dvc/selectDeviceInfoList.do")
    public ResponseEntity<Map<String, Object>> selectDeviceInfoList(DeviceAPIVO searchVO) {
        log.debug("uuid={}", searchVO.getUuid());
        Map<String, Object> response = new HashMap<>();
        List<DeviceAPIVO> deviceInfoList = egovDeviceAPIService.selectDeviceInfoList(searchVO);
        response.put("deviceInfoList", deviceInfoList);
        response.put("resultState", "OK");
        return ResponseEntity.ok(response);
    }
    
    @Operation(summary = "디바이스 정보 상세 조회", description = "디바이스 정보를 조회합니다.")
    @GetMapping("/dvc/selectDeviceInfo.do")
    public ResponseEntity<Map<String, Object>> selectDeviceInfo(DeviceAPIVO searchVO) {
        Map<String, Object> response = new HashMap<>();
        searchVO = egovDeviceAPIService.selectDeviceInfo(searchVO);
        response.put("deviceInfo", searchVO);
        response.put("resultState", "OK");
        return ResponseEntity.ok(response);
    }

    @Operation(summary = "디바이스 정보 등록", description = "디바이스 정보를 등록합니다.")
    @PostMapping("/dvc/insertDeviceInfo.do")
    public ResponseEntity<Map<String, Object>> insertDeviceInfo(DeviceAPIVO deviceVO) {
        Map<String, Object> response = new HashMap<>();
        int cnt = egovDeviceAPIService.insertDeviceInfo(deviceVO);
        if(cnt > 0) {
			response.put("resultState","OK");
			response.put("resultMessage","insert success");
		} else {
			response.put("resultState","FAIL");
			response.put("resultMessage","insert fail");
		}
        return ResponseEntity.ok(response);
    }

    @Operation(summary = "디바이스 정보 삭제", description = "디바이스 정보를 삭제합니다.")
    @DeleteMapping("/dvc/deleteDeviceInfo.do")
    public ResponseEntity<Map<String, Object>> deleteDeviceInfo(DeviceAPIVO deviceVO) {
        Map<String, Object> response = new HashMap<>();
        int cnt = egovDeviceAPIService.deleteDeviceInfo(deviceVO);
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
