package egovframework.hyb.mbl.ctt.web;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;

import egovframework.hyb.mbl.ctt.service.ContactsAPIVO;
import egovframework.hyb.mbl.ctt.service.EgovContactsAPIService;
import egovframework.hyb.utils.DeviceUuidCheck;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.annotation.Resource;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.DeleteMapping;

@Controller
@Tag(name = "03. Contacts Guide Program Service", description = "연락처 API 관리")
public class EgovContactsAPIController {

    @Resource(name = "EgovContactsAPIService")
    private EgovContactsAPIService egovContactsAPIService;

    @Operation(summary = "연락처 정보 목록 조회", description = "연락처 정보 목록을 조회합니다.")
    @GetMapping("/ctt/selectContactInfoList.do")
    public ResponseEntity<Map<String, Object>> selectContactInfoList(ContactsAPIVO searchVO)
            throws Exception {
        if (DeviceUuidCheck.isBlank(searchVO.getUuid())) {
            return DeviceUuidCheck.requiredResponse();
        }
        Map<String, Object> response = new HashMap<>();
        List<ContactsAPIVO> contactInfoList = egovContactsAPIService.selectContactsInfoList(searchVO);
        response.put("contactInfoList", contactInfoList);
        response.put("resultState", "OK");
        return ResponseEntity.ok(response);
    }

    @Operation(summary = "연락처 정보 등록", description = "연락처 정보를 등록합니다.")
    @PostMapping("/ctt/insertContactInfo.do")
    public ResponseEntity<Map<String, Object>> insertContactInfo(ContactsAPIVO contactsVO) throws Exception {
        if (DeviceUuidCheck.isBlank(contactsVO.getUuid())) {
            return DeviceUuidCheck.requiredResponse();
        }
        Map<String, Object> response = new HashMap<>();
        int cnt = egovContactsAPIService.insertContactsInfo(contactsVO);
        if (cnt > 0) {
            response.put("resultState", "OK");
            response.put("resultMessage", "insert success");
        } else {
            response.put("resultState", "FAIL");
            response.put("resultMessage", "insert fail");
        }
        return ResponseEntity.ok(response);
    }

    @Operation(summary = "연락처 정보 삭제", description = "연락처 정보를 논리 삭제(USEYN='N')합니다.")
    @DeleteMapping("/ctt/deleteContactInfo.do")
    public ResponseEntity<Map<String, Object>> deleteContactInfo(ContactsAPIVO contactsVO) throws Exception {
        if (DeviceUuidCheck.isBlank(contactsVO.getUuid())) {
            return DeviceUuidCheck.requiredResponse();
        }
        if (contactsVO.getSn() <= 0) {
            Map<String, Object> response = new HashMap<>();
            response.put("resultState", "FAIL");
            response.put("resultMessage", "sn is required");
            return ResponseEntity.badRequest().body(response);
        }

        Map<String, Object> response = new HashMap<>();
        int cnt = egovContactsAPIService.deleteContactsInfo(contactsVO);
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
