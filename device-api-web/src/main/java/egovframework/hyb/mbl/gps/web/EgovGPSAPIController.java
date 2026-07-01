package egovframework.hyb.mbl.gps.web;

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

import egovframework.hyb.mbl.gps.service.EgovGPSAPIService;
import egovframework.hyb.mbl.gps.service.GPSAPIVO;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.annotation.Resource;

/**
 * 통합 GPS API Controller
 */
@Controller
@Tag(name = "07. GPS Guide Program Service", description = "GPS API 관리")
public class EgovGPSAPIController {

    @Resource(name = "EgovGPSAPIService")
    private EgovGPSAPIService egovGPSAPIService;

    @Resource(name = "propertiesService")
    protected EgovPropertyService propertiesService;

    @Operation(summary = "GPS 정보 목록 조회", description = "GPS 정보 목록을 조회합니다.")
    @RequestMapping(value = "/gps/selectGPSInfoList.do", method = RequestMethod.GET)
    public ResponseEntity<?> selectGPSInfoList(@ModelAttribute("searchVO") GPSAPIVO searchVO, ModelMap model) throws Exception {
        Map<String, Object> response = new HashMap<>();
        List<?> gpsInfoList = egovGPSAPIService.selectGPSInfoList(searchVO);
        response.put("gpsInfoList", gpsInfoList);
        response.put("resultState", "OK");
        return ResponseEntity.ok(response);
    }

    @Operation(summary = "GPS 정보 등록", description = "GPS 정보를 등록합니다.")
    @RequestMapping(value = "/gps/insertGPSInfo.do", method = RequestMethod.POST)
    public ResponseEntity<?> insertGPSInfo(GPSAPIVO gpsVO, BindingResult bindingResult, Model model, SessionStatus status) throws Exception {
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
    @RequestMapping(value = "/gps/deleteGPSInfo.do", method = RequestMethod.DELETE)
    public ResponseEntity<?> deleteGPSInfo(GPSAPIVO sampleVO, @ModelAttribute("searchVO") GPSAPIVO searchVO, SessionStatus status) throws Exception {
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
