package egovframework.hyb.mbl.itf.web;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.support.SessionStatus;

import egovframework.hyb.mbl.itf.service.EgovInterfaceAPIService;
import egovframework.hyb.mbl.itf.service.InterfaceAPIVO;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

/**
 * 통합 Interface API Controller
 */
@Controller
@RequiredArgsConstructor
@Slf4j
@Tag(name = "08. Interface Guide Program Service", description = "인터페이스 API 관리")
public class EgovInterfaceAPIController {

    private final EgovInterfaceAPIService egovInterfaceAPIService;

    @Operation(summary = "인터페이스 정보 목록 조회", description = "인터페이스 정보 목록을 조회합니다.")
    @GetMapping("/itf/selectInterfaceInfoList.do")
    public ResponseEntity<Map<String, Object>> selectInterfaceInfoList(InterfaceAPIVO searchVO) {
        log.debug("userId={}", searchVO.getUserId());
        Map<String, Object> response = new HashMap<>();
        List<InterfaceAPIVO> interfaceInfoList = egovInterfaceAPIService.selectInterfaceInfoList(searchVO);
        response.put("interfaceInfoList", interfaceInfoList);
        response.put("resultState", "OK");
        return ResponseEntity.ok(response);
    }
    
    @Operation(summary = "인터페이스 로그인 조회", description = "인터페이스 로그인을 한다.")
    @PostMapping("/itf/loginInterfaceInfo.do")
    public ResponseEntity<Map<String, Object>> loginInterfaceInfo(
            @Valid InterfaceAPIVO searchVO,
            BindingResult bindingResult) {
    	Map<String, Object> response = new HashMap<>();
    	if (bindingResult.hasErrors()) {
    		return ResponseEntity.ok(validationErrorResponse(bindingResult));
    	}
    	InterfaceAPIVO vo = egovInterfaceAPIService.selectInterfaceInfo(searchVO);
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
    @PostMapping("/itf/selectInterfaceInfo.do")
    public ResponseEntity<Map<String, Object>> selectInterfaceInfo(
            @Valid InterfaceAPIVO searchVO,
            BindingResult bindingResult) {
    	Map<String, Object> response = new HashMap<>();
    	if (bindingResult.hasErrors()) {
    		return ResponseEntity.ok(validationErrorResponse(bindingResult));
    	}
    	InterfaceAPIVO result = egovInterfaceAPIService.selectInterfaceInfo(searchVO);
    	if (result != null) {
    		result.setUserPw(null);
    	}
        response.put("interfaceInfo", result);
        response.put("resultState", "OK");

    	return ResponseEntity.ok(response);
    }

    @Operation(summary = "인터페이스 정보 등록", description = "인터페이스 정보를 등록합니다.")
    @PostMapping("/itf/insertInterfaceInfo.do")
    public ResponseEntity<Map<String, Object>> insertInterfaceInfo(
            @Valid @ModelAttribute("interfaceVO") InterfaceAPIVO interfaceVO,
            BindingResult bindingResult,
            Model model,
            SessionStatus status) {
        Map<String, Object> response = new HashMap<>();
        if (bindingResult.hasErrors()) {
            return ResponseEntity.ok(validationErrorResponse(bindingResult));
        }
        if (interfaceVO.getEmails() == null || interfaceVO.getEmails().isBlank()) {
            response.put("resultState", "FAIL");
            response.put("resultMessage", "이메일은 필수 입력값입니다.");
            return ResponseEntity.ok(response);
        }
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
    @DeleteMapping("/itf/deleteInterfaceInfo.do")
    public ResponseEntity<Map<String, Object>> deleteInterfaceInfo(
            @Valid InterfaceAPIVO interfaceVO,
            BindingResult bindingResult) {
        Map<String, Object> response = new HashMap<>();
        if (bindingResult.hasErrors()) {
            return ResponseEntity.ok(validationErrorResponse(bindingResult));
        }
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

    private Map<String, Object> validationErrorResponse(BindingResult bindingResult) {
        Map<String, Object> response = new HashMap<>();
        response.put("resultState", "FAIL");
        if (!bindingResult.getFieldErrors().isEmpty()) {
            response.put("resultMessage", bindingResult.getFieldErrors().get(0).getDefaultMessage());
        } else {
            response.put("resultMessage", "입력값이 올바르지 않습니다.");
        }
        return response;
    }

}
