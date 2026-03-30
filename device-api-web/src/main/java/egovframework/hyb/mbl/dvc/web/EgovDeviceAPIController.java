package egovframework.hyb.mbl.dvc.web;

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

import egovframework.hyb.mbl.dvc.service.DeviceAPIVO;
import egovframework.hyb.mbl.dvc.service.EgovDeviceAPIService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.annotation.Resource;

/**
 * 통합 Device API Controller
 */
@Controller
@Tag(name = "05. DeviceInfo Guide Program Service", description = "디바이스 API 관리")
public class EgovDeviceAPIController {

    @Resource(name = "EgovDeviceAPIService")
    private EgovDeviceAPIService egovDeviceAPIService;

    @Resource(name = "propertiesService")
    protected EgovPropertyService propertiesService;

    @Operation(summary = "디바이스 정보 목록 조회", description = "디바이스 정보 목록을 조회합니다.")
    @RequestMapping(value = "/dvc/selectDeviceInfoList.do", method = RequestMethod.GET)
    public ResponseEntity<?> selectDeviceInfoList(@ModelAttribute("searchVO") DeviceAPIVO searchVO, ModelMap model) throws Exception {
        Map<String, Object> response = new HashMap<>();
        List<?> deviceInfoList = egovDeviceAPIService.selectDeviceInfoList(searchVO);
        response.put("deviceInfoList", deviceInfoList);
        response.put("resultState", "OK");
        return ResponseEntity.ok(response);
    }
    
    @Operation(summary = "디바이스 정보 상세 조회", description = "디바이스 정보를 조회합니다.")
    @RequestMapping(value = "/dvc/selectDeviceInfo.do", method = RequestMethod.GET)
    public ResponseEntity<?> selectDeviceInfo(@ModelAttribute("searchVO") DeviceAPIVO searchVO, ModelMap model) throws Exception {
        Map<String, Object> response = new HashMap<>();
        searchVO = egovDeviceAPIService.selectDeviceInfo(searchVO);
        response.put("deviceInfo", searchVO);
        response.put("resultState", "OK");
        return ResponseEntity.ok(response);
    }

    @Operation(summary = "디바이스 정보 등록", description = "디바이스 정보를 등록합니다.")
    @RequestMapping(value = "/dvc/insertDeviceInfo.do", method = RequestMethod.POST)
    public ResponseEntity<?> insertDeviceInfo(DeviceAPIVO deviceVO, BindingResult bindingResult, Model model, SessionStatus status) throws Exception {
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
    @RequestMapping(value = "/dvc/deleteDeviceInfo.do", method = RequestMethod.DELETE)
    public ResponseEntity<?> deleteDeviceInfo(DeviceAPIVO deviceVO, BindingResult bindingResult, Model model, SessionStatus status) throws Exception {
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
