package egovframework.hyb.mbl.ws.web;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;

import egovframework.hyb.mbl.ws.service.EgovSocketMessageAPIService;
import egovframework.hyb.mbl.ws.service.SocketMessageAPIVO;
import egovframework.hyb.mbl.ws.service.SocketMessageLimits;
import egovframework.hyb.utils.DeviceUuidCheck;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.annotation.Resource;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.DeleteMapping;

@Controller
@Tag(name = "12. SocketIO Guide Program Service", description = "SocketIO REST API 관리")
public class EgovSocketMessageAPIController {

    @Resource(name = "EgovSocketMessageAPIService")
    private EgovSocketMessageAPIService egovSocketMessageAPIService;

    @Operation(summary = "Socket 메시지 목록 조회", description = "Socket 메시지 목록을 조회합니다.")
    @GetMapping("/ws/selectSocketMessageInfoList.do")
    public ResponseEntity<Map<String, Object>> selectSocketMessageInfoList(SocketMessageAPIVO searchVO) throws Exception {
        if (DeviceUuidCheck.isBlank(searchVO.getUuid())) {
            return DeviceUuidCheck.requiredResponse();
        }
        Map<String, Object> response = new HashMap<>();
        List<SocketMessageAPIVO> socketMessageInfoList = egovSocketMessageAPIService.selectSocketMessageInfoList(searchVO);
        response.put("socketMessageInfoList", socketMessageInfoList);
        response.put("resultState", "OK");
        return ResponseEntity.ok(response);
    }

    @Operation(summary = "Socket 메시지 등록", description = "Socket 메시지를 등록합니다.")
    @PostMapping("/ws/insertSocketMessageInfo.do")
    public ResponseEntity<Map<String, Object>> insertSocketMessageInfo(SocketMessageAPIVO vo) throws Exception {
        if (DeviceUuidCheck.isBlank(vo.getUuid())) {
            return DeviceUuidCheck.requiredResponse();
        }
        Map<String, Object> response = new HashMap<>();
        if (!SocketMessageLimits.within(vo.getSender(), SocketMessageLimits.MAX_SENDER_LENGTH)
                || !SocketMessageLimits.within(vo.getMessage(), SocketMessageLimits.MAX_MESSAGE_LENGTH)) {
            response.put("resultState", "FAIL");
            response.put("resultMessage", "message length exceeded");
            return ResponseEntity.ok(response);
        }
        int cnt = egovSocketMessageAPIService.insertSocketMessageInfo(vo);
        if (cnt > 0) {
            response.put("resultState", "OK");
            response.put("sn", vo.getSn());
            response.put("resultMessage", "insert success");
        } else {
            response.put("resultState", "FAIL");
            response.put("resultMessage", "insert fail");
        }
        return ResponseEntity.ok(response);
    }

    @Operation(summary = "Socket 메시지 삭제", description = "UUID 기준 Socket 메시지를 삭제합니다.")
    @DeleteMapping("/ws/deleteSocketMessageInfo.do")
    public ResponseEntity<Map<String, Object>> deleteSocketMessageInfo(SocketMessageAPIVO vo) throws Exception {
        if (DeviceUuidCheck.isBlank(vo.getUuid())) {
            return DeviceUuidCheck.requiredResponse();
        }
        Map<String, Object> response = new HashMap<>();
        int cnt = egovSocketMessageAPIService.deleteSocketMessageInfo(vo);
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
