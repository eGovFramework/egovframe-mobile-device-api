package egovframework.hyb.mbl.iot.web;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;

import egovframework.hyb.mbl.iot.service.EgovIotMessageAPIService;
import egovframework.hyb.mbl.iot.service.IotMessageAPIVO;
import egovframework.hyb.utils.DeviceUuidCheck;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.annotation.Resource;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.DeleteMapping;

@Controller
@Tag(name = "16. IoT MQTT Guide Program Service", description = "IoT MQTT 메시지 REST API 관리")
public class EgovIotMessageAPIController {

    @Resource(name = "EgovIotMessageAPIService")
    private EgovIotMessageAPIService egovIotMessageAPIService;

    @Value("${mqtt.enabled:false}")
    private boolean mqttEnabled;

    @Value("${mqtt.host:}")
    private String mqttHost;

    @Value("${mqtt.port:1883}")
    private int mqttPort;

    @Value("${mqtt.username:}")
    private String mqttUsername;

    @Value("${mqtt.password:}")
    private String mqttPassword;

    @Value("${mqtt.device-id:device01}")
    private String mqttDeviceId;

    @Operation(summary = "MQTT 접속 설정 조회", description = "application.properties 의 MQTT 접속 값을 반환합니다. 서버는 브로커에 연결하지 않습니다.")
    @GetMapping("/iot/mqttConfig.do")
    public ResponseEntity<Map<String, Object>> mqttConfig() {
        Map<String, Object> response = new HashMap<>();
        boolean enabled = mqttEnabled && mqttHost != null && !mqttHost.isBlank();
        response.put("resultState", "OK");
        response.put("enabled", enabled);
        response.put("host", enabled ? mqttHost : "");
        response.put("port", mqttPort);
        response.put("username", enabled ? mqttUsername : "");
        response.put("password", enabled ? mqttPassword : "");
        response.put("deviceId", mqttDeviceId);
        return ResponseEntity.ok(response);
    }

    @Operation(summary = "IoT 메시지 목록 조회", description = "IoT MQTT 메시지 목록을 조회합니다.")
    @GetMapping("/iot/selectIotMessageInfoList.do")
    public ResponseEntity<Map<String, Object>> selectIotMessageInfoList(IotMessageAPIVO searchVO) throws Exception {
        if (DeviceUuidCheck.isBlank(searchVO.getUuid())) {
            return DeviceUuidCheck.requiredResponse();
        }
        Map<String, Object> response = new HashMap<>();
        List<IotMessageAPIVO> iotMessageInfoList = egovIotMessageAPIService.selectIotMessageInfoList(searchVO);
        response.put("iotMessageInfoList", iotMessageInfoList);
        response.put("resultState", "OK");
        return ResponseEntity.ok(response);
    }

    @Operation(summary = "IoT 메시지 등록", description = "IoT MQTT 메시지를 등록합니다.")
    @PostMapping("/iot/insertIotMessageInfo.do")
    public ResponseEntity<Map<String, Object>> insertIotMessageInfo(IotMessageAPIVO vo) throws Exception {
        if (DeviceUuidCheck.isBlank(vo.getUuid())) {
            return DeviceUuidCheck.requiredResponse();
        }
        Map<String, Object> response = new HashMap<>();
        int cnt = egovIotMessageAPIService.insertIotMessageInfo(vo);
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

    @Operation(summary = "IoT 메시지 삭제", description = "UUID 기준 IoT 메시지를 삭제합니다.")
    @DeleteMapping("/iot/deleteIotMessageInfo.do")
    public ResponseEntity<Map<String, Object>> deleteIotMessageInfo(IotMessageAPIVO vo) throws Exception {
        if (DeviceUuidCheck.isBlank(vo.getUuid())) {
            return DeviceUuidCheck.requiredResponse();
        }
        Map<String, Object> response = new HashMap<>();
        int cnt = egovIotMessageAPIService.deleteIotMessageInfo(vo);
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
