package egovframework.hyb.mbl.pus.web;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Pattern;

import org.egovframe.rte.fdl.property.EgovPropertyService;
import org.egovframe.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import org.springdoc.core.annotations.ParameterObject;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.server.ResponseStatusException;

import egovframework.hyb.pagination.EgovKrdsPaginationRenderer;
import egovframework.hyb.mbl.pus.service.EgovPushDeviceAPIService;
import egovframework.hyb.utils.DeviceUuidCheck;
import egovframework.hyb.mbl.pus.service.PushDeviceAPIVO;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.annotation.Resource;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.DeleteMapping;

@Controller
@Tag(name = "10. PushNotifications Guide Program Service", description = "푸시 알림 API 관리")
public class EgovPushDeviceAPIController {

    /** 페이징 HTML onclick에 들어가므로 JS 식별자만 허용(XSS 방지) */
    private static final Pattern JS_FUNCTION_NAME = Pattern.compile("[A-Za-z_$][A-Za-z0-9_$]{0,49}");

    /** 한 페이지 최대 건수(과도한 조회 방지) */
    private static final int MAX_PAGE_UNIT = 100;

    @Resource(name = "EgovPushDeviceAPIService")
    private EgovPushDeviceAPIService egovPushDeviceAPIService;

    @Resource(name = "propertiesService")
    protected EgovPropertyService propertiesService;

    @Resource
    private EgovKrdsPaginationRenderer egovKrdsPaginationRenderer;

    @Operation(summary = "푸시 디바이스 목록 조회", description = "푸시 디바이스 목록을 조회합니다. pageIndex>0 이면 페이징을 적용합니다.")
    @GetMapping("/pus/selectPushDeviceList.do")
    public ResponseEntity<Map<String, Object>> selectPushDeviceList(PushDeviceAPIVO searchVO,
            @RequestParam(value = "pageLinkFunction", required = false, defaultValue = "linkDevicePage") String pageLinkFunction) throws Exception {
        if (DeviceUuidCheck.isBlank(searchVO.getUuid())) {
            return DeviceUuidCheck.requiredResponse();
        }
        Map<String, Object> response = new HashMap<>();
        applyPagination(searchVO, pageLinkFunction, response, true, false, false);
        List<PushDeviceAPIVO> pushDeviceList = egovPushDeviceAPIService.selectPushDeviceList(searchVO);
        response.put("pushDeviceList", pushDeviceList);
        response.put("resultState", "OK");
        return ResponseEntity.ok(response);
    }

    @Operation(summary = "등록된 전체 푸시 디바이스 목록 조회", description = "USEYN=Y 인 등록 기기를 UUID 없이 조회합니다. /fcm 관리 화면용입니다. 앱은 UUID가 필요한 /pus/selectPushDeviceList.do 를 사용합니다.")
    @GetMapping("/pus/selectAllPushDeviceList.do")
    public ResponseEntity<Map<String, Object>> selectAllPushDeviceList(PushDeviceAPIVO searchVO,
            @RequestParam(value = "pageLinkFunction", required = false, defaultValue = "linkDevicePage") String pageLinkFunction) throws Exception {
        Map<String, Object> response = new HashMap<>();
        applyPagination(searchVO, pageLinkFunction, response, true, true, false);
        List<PushDeviceAPIVO> pushDeviceList = egovPushDeviceAPIService.selectAllPushDeviceList(searchVO);
        response.put("pushDeviceList", pushDeviceList);
        response.put("resultState", "OK");
        return ResponseEntity.ok(response);
    }

    @Operation(summary = "푸시 디바이스 등록", description = "푸시 디바이스 정보를 등록합니다.")
    @PostMapping("/pus/insertPushDevice.do")
    public ResponseEntity<Map<String, Object>> insertPushDevice(@ParameterObject PushDeviceAPIVO sampleVO) throws Exception {
        if (DeviceUuidCheck.isBlank(sampleVO.getUuid())) {
            return DeviceUuidCheck.requiredResponse();
        }
        Map<String, Object> response = new HashMap<>();
        int cnt = egovPushDeviceAPIService.insertPushDevice(sampleVO);
        if (cnt > 0) {
            response.put("resultState", "OK");
            response.put("resultMessage", "insert success");
        } else {
            response.put("resultState", "FAIL");
            response.put("resultMessage", "insert fail");
        }
        return ResponseEntity.ok(response);
    }

    @Operation(summary = "푸시 디바이스 삭제", description = "UUID 기준 푸시 디바이스 정보를 삭제합니다.")
    @DeleteMapping("/pus/deletePushDevice.do")
    public ResponseEntity<Map<String, Object>> deletePushDevice(PushDeviceAPIVO sampleVO) throws Exception {
        if (DeviceUuidCheck.isBlank(sampleVO.getUuid())) {
            return DeviceUuidCheck.requiredResponse();
        }
        Map<String, Object> response = new HashMap<>();
        int cnt = egovPushDeviceAPIService.deletePushDevice(sampleVO);
        if (cnt > 0) {
            response.put("resultState", "OK");
            response.put("resultMessage", "delete success");
        } else {
            response.put("resultState", "FAIL");
            response.put("resultMessage", "delete fail");
        }
        return ResponseEntity.ok(response);
    }

    @Operation(summary = "푸시 발송 메시지 목록 조회", description = "PUSH_MESSAGE 테이블에 저장된 발송 이력을 조회합니다. pageIndex>0 이면 페이징을 적용합니다.")
    @GetMapping("/pus/selectPushMessageList.do")
    public ResponseEntity<Map<String, Object>> selectPushMessageList(PushDeviceAPIVO searchVO,
            @RequestParam(value = "pageLinkFunction", required = false, defaultValue = "linkHistoryPage") String pageLinkFunction) throws Exception {
        if (DeviceUuidCheck.isBlank(searchVO.getUuid())) {
            return DeviceUuidCheck.requiredResponse();
        }
        Map<String, Object> response = new HashMap<>();
        applyPagination(searchVO, pageLinkFunction, response, false, false, false);
        List<PushDeviceAPIVO> pushMessageList = egovPushDeviceAPIService.selectPushMessageList(searchVO);
        response.put("pushMessageList", pushMessageList);
        response.put("resultState", "OK");
        return ResponseEntity.ok(response);
    }

    @Operation(summary = "전체 푸시 발송 이력 조회", description = "발송 이력을 UUID 없이 조회합니다. 같은 메시지와 발송 시각은 한 건으로 묶고, deviceCount에 기기 수를 담습니다. uuid 값이 있으면 그 발송의 UUID 또는 메시지에 대한 검색어로 좁힙니다. /fcm 관리 화면용입니다.")
    @GetMapping("/pus/selectAllPushMessageList.do")
    public ResponseEntity<Map<String, Object>> selectAllPushMessageList(PushDeviceAPIVO searchVO,
            @RequestParam(value = "pageLinkFunction", required = false, defaultValue = "linkHistoryPage") String pageLinkFunction) throws Exception {
        Map<String, Object> response = new HashMap<>();
        applyPagination(searchVO, pageLinkFunction, response, false, false, true);
        List<PushDeviceAPIVO> pushMessageList = egovPushDeviceAPIService.selectAllPushMessageList(searchVO);
        response.put("pushMessageList", pushMessageList);
        response.put("resultState", "OK");
        return ResponseEntity.ok(response);
    }

    @Operation(summary = "푸시 메시지 발송", description = "등록된 디바이스의 FCM 등록 토큰으로 푸시 메시지를 발송합니다.")
    @PostMapping("/pus/requestPushInfo.do")
    public ResponseEntity<Map<String, Object>> requestPushInfo(PushDeviceAPIVO sampleVO) throws Exception {
        if (DeviceUuidCheck.isBlank(sampleVO.getUuid())) {
            return DeviceUuidCheck.requiredResponse();
        }
        Map<String, Object> response = new HashMap<>();
        int fcmResult = egovPushDeviceAPIService.sendPushNotification(sampleVO);
        int cnt = egovPushDeviceAPIService.insertPushMessage(sampleVO);
        if (cnt > 0) {
            response.put("resultState", fcmResult == 0 ? "OK" : "FAIL");
            response.put("resultMessage",
                    fcmResult == 0 ? "push send success" : describePushFail(fcmResult));
        } else {
            response.put("resultState", "FAIL");
            response.put("resultMessage", "push message save fail");
        }
        return ResponseEntity.ok(response);
    }

    private String describePushFail(int fcmResult) {
        switch (fcmResult) {
        case 1:
            return "push send fail: FCM HTTP 응답 오류 (error code: 1)";
        case 2:
            return "push send fail: FCM 서비스 계정 JSON 파일을 찾을 수 없습니다 (error code: 2). "
                    + "classpath 또는 실행 디렉터리에 Globals.fcmSdk 파일을 두세요.";
        case 3:
            return "push send fail: FCM 인증/IO 오류 (error code: 3)";
        case 4:
            return "push send fail: FCM 요청 예외 (error code: 4). 토큰·프로젝트·네트워크를 확인하세요.";
        default:
            return "push send fail (FCM error code: " + fcmResult + ")";
        }
    }

    /**
     * PaginationInfo 설정 및 KRDS 페이징 HTML 생성.
     * pageIndex &lt;= 0 이면 기존 앱 호출 호환을 위해 전체 목록을 반환한다.
     */
    private void applyPagination(PushDeviceAPIVO searchVO, String pageLinkFunction, Map<String, Object> response,
            boolean isDeviceList, boolean allDevices, boolean allMessages) throws Exception {
        if (searchVO.getPageIndex() <= 0) {
            searchVO.setRecordCountPerPage(0);
            response.put("pagination", "");
            response.put("totalCount", -1);
            return;
        }

        if (!JS_FUNCTION_NAME.matcher(pageLinkFunction).matches()) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "invalid pageLinkFunction");
        }
        int pageUnit = searchVO.getPageUnit() > 0 ? Math.min(searchVO.getPageUnit(), MAX_PAGE_UNIT)
                : propertiesService.getInt("pageUnit");
        int pageSize = searchVO.getPageSize() > 0 ? Math.min(searchVO.getPageSize(), MAX_PAGE_UNIT)
                : propertiesService.getInt("pageSize");

        PaginationInfo paginationInfo = new PaginationInfo();
        paginationInfo.setCurrentPageNo(searchVO.getPageIndex());
        paginationInfo.setRecordCountPerPage(pageUnit);
        paginationInfo.setPageSize(pageSize);

        searchVO.setFirstIndex(paginationInfo.getFirstRecordIndex());
        searchVO.setLastIndex(paginationInfo.getLastRecordIndex());
        searchVO.setRecordCountPerPage(paginationInfo.getRecordCountPerPage());

        int totCnt = allDevices ? egovPushDeviceAPIService.selectAllPushDeviceCount(searchVO)
                : (allMessages ? egovPushDeviceAPIService.selectAllPushMessageCount(searchVO)
                        : (isDeviceList ? egovPushDeviceAPIService.selectPushDeviceCount(searchVO)
                                : egovPushDeviceAPIService.selectPushMessageCount(searchVO)));
        paginationInfo.setTotalRecordCount(totCnt);

        String pagination = totCnt > 0
                ? egovKrdsPaginationRenderer.renderPagination(paginationInfo, pageLinkFunction)
                : "";

        response.put("pagination", pagination);
        response.put("totalCount", totCnt);
        response.put("pageIndex", searchVO.getPageIndex());
        response.put("pageUnit", pageUnit);
    }
}
