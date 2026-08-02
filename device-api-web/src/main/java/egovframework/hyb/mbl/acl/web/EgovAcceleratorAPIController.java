package egovframework.hyb.mbl.acl.web;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;

import egovframework.hyb.mbl.acl.service.AcceleratorAPIVO;
import egovframework.hyb.mbl.acl.service.EgovAcceleratorAPIService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

/**
 * 통합 Accelerator API Controller
 */
@Controller
@RequiredArgsConstructor
@Slf4j
@Tag(name = "01. Accelerator Guide Program Service", description = "가속도계 API 관리")
public class EgovAcceleratorAPIController {

    private final EgovAcceleratorAPIService egovAcceleratorAPIService;

    @Operation(summary = "가속도계 정보 목록 조회", description = "가속도계 정보 목록을 조회합니다.")
    @GetMapping("/acl/selectAcceleratorInfoList.do")
    public ResponseEntity<Map<String, Object>> selectAcceleratorInfoList(AcceleratorAPIVO searchVO) {
        log.debug("uuid={}", searchVO.getUuid());
    	Map<String, Object> response = new HashMap<>();
    	List<AcceleratorAPIVO> acceleratorInfoList = egovAcceleratorAPIService.selectAcceleratorInfoList(searchVO);
        response.put("acceleratorInfoList", acceleratorInfoList);
        response.put("resultState", "OK");
        return ResponseEntity.ok(response);
    }

    @Operation(summary = "가속도계 정보 등록", description = "가속도계 정보를 등록합니다.")
    @PostMapping("/acl/insertAcceleratorInfo.do")
    public ResponseEntity<Map<String, Object>> insertAcceleratorInfo(AcceleratorAPIVO acceleratorVO) {
        Map<String, Object> response = new HashMap<>();
        int cnt = egovAcceleratorAPIService.insertAcceleratorInfo(acceleratorVO);
        if (cnt > 0) {
            response.put("resultState", "OK");
            response.put("resultMessage","insert success");
        } else {
            response.put("resultState", "FAIL");
            response.put("resultMessage","insert fail");
        }
        return ResponseEntity.ok(response);
    }

    @Operation(summary = "가속도계 정보 삭제", description = "가속도계 정보를 삭제합니다.")
    @DeleteMapping("/acl/deleteAcceleratorInfo.do")
    public ResponseEntity<Map<String, Object>> deleteAcceleratorInfo(AcceleratorAPIVO acceleratorVO) {
        Map<String, Object> response = new HashMap<>();
        int cnt = egovAcceleratorAPIService.deleteAcceleratorInfo(acceleratorVO);
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
