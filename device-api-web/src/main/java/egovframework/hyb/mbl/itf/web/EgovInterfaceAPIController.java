package egovframework.hyb.mbl.itf.web;

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

import egovframework.hyb.mbl.itf.service.EgovInterfaceAPIService;
import egovframework.hyb.mbl.itf.service.InterfaceAPIVO;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.annotation.Resource;

/**
 * 통합 Interface API Controller
 */
@Controller
@Tag(name = "08. Interface Guide Program Service", description = "인터페이스 API 관리")
public class EgovInterfaceAPIController {

    @Resource(name = "EgovInterfaceAPIService")
    private EgovInterfaceAPIService egovInterfaceAPIService;

    @Resource(name = "propertiesService")
    protected EgovPropertyService propertiesService;

    @Operation(summary = "인터페이스 정보 목록 조회", description = "인터페이스 정보 목록을 조회합니다.")
    @RequestMapping(value = "/itf/selectInterfaceInfoList.do", method = RequestMethod.GET)
    public ResponseEntity<?> selectInterfaceInfoList(@ModelAttribute("searchVO") InterfaceAPIVO searchVO, ModelMap model) throws Exception {
        Map<String, Object> response = new HashMap<>();
        List<?> interfaceInfoList = egovInterfaceAPIService.selectInterfaceInfoList(searchVO);
        response.put("interfaceInfoList", interfaceInfoList);
        response.put("resultState", "OK");
        return ResponseEntity.ok(response);
    }
    
    @Operation(summary = "인터페이스 로그인 조회", description = "인터페이스 로그인을 한다.")
    @RequestMapping(value= "/itf/loginInterfaceInfo.do", method = RequestMethod.POST)
    public ResponseEntity<?> loginInterfaceInfo(@ModelAttribute("searchVO") InterfaceAPIVO searchVO, ModelMap model) throws Exception {
    	Map<String, Object> response = new HashMap<>();
    	InterfaceAPIVO vo = new InterfaceAPIVO();
    	vo = egovInterfaceAPIService.selectInterfaceInfo(searchVO);
    	if(vo == null) {
    		int cnt = egovInterfaceAPIService.selectInterfaceInfoListTotCnt(searchVO);
    		if(cnt > 0) {
    			response.put("resultState","FAIL");
    			response.put("resultMessage","패스워드가 일치하지 않습니다.");
    		} else {
    			response.put("resultState","FAIL");
    			response.put("resultMessage","아이디가 존재하지 않습니다.");
    		}
    	}else {
    		response.put("resultState","OK");
			response.put("resultMessage","로그인에 성공하였습니다.");
    	}
    	
    	return ResponseEntity.ok(response);
    }
    
    @Operation(summary = "인터페이스 정보 조회", description = "인터페이스 정보를 조회한다.")
    @RequestMapping(value= "/itf/selectInterfaceInfo.do", method = RequestMethod.POST)
    public ResponseEntity<?> selectInterfaceInfo(@ModelAttribute("searchVO") InterfaceAPIVO searchVO, ModelMap model) throws Exception {
    	Map<String, Object> response = new HashMap<>();
    	searchVO = egovInterfaceAPIService.selectInterfaceInfo(searchVO);
        response.put("interfaceInfo", searchVO);
        response.put("resultState", "OK");

    	return ResponseEntity.ok(response);
    }

    @Operation(summary = "인터페이스 정보 등록", description = "인터페이스 정보를 등록합니다.")
    @RequestMapping(value = "/itf/insertInterfaceInfo.do", method = RequestMethod.POST)
    public ResponseEntity<?> insertInterfaceInfo(InterfaceAPIVO interfaceVO, BindingResult bindingResult, Model model, SessionStatus status) throws Exception {
        Map<String, Object> response = new HashMap<>();
        int cnt = egovInterfaceAPIService.insertInterfaceInfo(interfaceVO);
        if(cnt > 0) {
			response.put("resultState","OK");
			response.put("resultMessage","insert success");
		} else {
			response.put("resultState","FAIL");
			response.put("resultMessage","insert fail");
		}
        return ResponseEntity.ok(response);
    }

    @Operation(summary = "인터페이스 정보 삭제", description = "인터페이스 정보를 삭제합니다. (회원탈퇴) ")
    @RequestMapping(value = "/itf/deleteInterfaceInfo.do", method = RequestMethod.DELETE)
    public ResponseEntity<?> deleteInterfaceInfo(InterfaceAPIVO interfaceVO, BindingResult bindingResult, Model model, SessionStatus status) throws Exception {
        Map<String, Object> response = new HashMap<>();
        int cnt = egovInterfaceAPIService.deleteInterfaceInfo(interfaceVO);
        if(cnt > 0) {
			response.put("resultState","OK");
			response.put("resultMessage","탈퇴에 성공하였습니다.");
		} else {
			response.put("resultState","FAIL");
			response.put("resultMessage","탈퇴에 실패하였습니다.l");
		}
		return ResponseEntity.ok(response);
    }

}
