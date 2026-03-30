package egovframework.hyb.mbl.acl.web;

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

import egovframework.hyb.mbl.acl.service.AcceleratorAPIVO;
import egovframework.hyb.mbl.acl.service.EgovAcceleratorAPIService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.annotation.Resource;

/**
 * 통합 Accelerator API Controller
 */
@Controller
@Tag(name = "01. Accelerator Guide Program Service", description = "가속도계 API 관리")
public class EgovAcceleratorAPIController {

    @Resource(name = "EgovAcceleratorAPIService")
    private EgovAcceleratorAPIService egovAcceleratorAPIService;

    @Resource(name = "propertiesService")
    protected EgovPropertyService propertiesService;

    @Operation(summary = "가속도계 정보 목록 조회", description = "가속도계 정보 목록을 조회합니다.")
    @RequestMapping(value = "/acl/selectAcceleratorInfoList.do", method = RequestMethod.GET)
    public ResponseEntity<?> selectAcceleratorInfoList(@ModelAttribute("searchVO") AcceleratorAPIVO searchVO, ModelMap model) throws Exception {
    	Map<String, Object> response = new HashMap<>();
    	List<?> acceleratorInfoList = egovAcceleratorAPIService.selectAcceleratorInfoList(searchVO);
        response.put("acceleratorInfoList", acceleratorInfoList);
        response.put("resultState", "OK");
        return ResponseEntity.ok(response);
    }

    @Operation(summary = "가속도계 정보 등록", description = "가속도계 정보를 등록합니다.")
    @RequestMapping(value = "/acl/insertAcceleratorInfo.do", method = RequestMethod.POST)
    public ResponseEntity<?> insertAcceleratorInfo(AcceleratorAPIVO acceleratorVO, BindingResult bindingResult, Model model, SessionStatus status) throws Exception {
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
    @RequestMapping(value = "/acl/deleteAcceleratorInfo.do", method = RequestMethod.DELETE)
    public ResponseEntity<?> deleteAcceleratorInfo(AcceleratorAPIVO acceleratorVO, BindingResult bindingResult, Model model, SessionStatus status) throws Exception {
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
