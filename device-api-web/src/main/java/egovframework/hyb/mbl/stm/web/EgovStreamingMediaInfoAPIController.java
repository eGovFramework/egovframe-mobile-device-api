package egovframework.hyb.mbl.stm.web;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import egovframework.hyb.mbl.mda.service.EgovMediaAPIService;
import egovframework.hyb.mbl.mda.service.MediaAPIVO;
import egovframework.hyb.mbl.stm.service.EgovStreamingMediaInfoAPIService;
import egovframework.hyb.mbl.stm.service.StreamingMediaAPIVO;
import egovframework.hyb.utils.DeviceUuidCheck;
import egovframework.hyb.utils.EgovFileMngUtil;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.annotation.Resource;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.DeleteMapping;

@Controller
@Tag(name = "13. StreamingMedia Guide Program Service", description = "스트리밍 미디어 REST API 관리")
public class EgovStreamingMediaInfoAPIController {

    @Resource(name = "EgovStreamingMediaInfoAPIService")
    private EgovStreamingMediaInfoAPIService egovStreamingMediaInfoAPIService;

    @Resource(name = "EgovMediaAPIService")
    private EgovMediaAPIService egovMediaAPIService;

    @Resource(name = "egovFileMngUtil")
    private EgovFileMngUtil fileMngUtil;

    @Operation(summary = "스트리밍 미디어 목록 조회", description = "스트리밍 미디어 목록을 조회합니다.")
    @GetMapping("/stm/selectStreamingMediaInfoList.do")
    public ResponseEntity<Map<String, Object>> selectStreamingMediaInfoList(StreamingMediaAPIVO searchVO) throws Exception {
        if (DeviceUuidCheck.isBlank(searchVO.getUuid())) {
            return DeviceUuidCheck.requiredResponse();
        }
        Map<String, Object> response = new HashMap<>();
        List<StreamingMediaAPIVO> streamingMediaInfoList = egovStreamingMediaInfoAPIService.selectStreamingMediaInfoList(searchVO);
        response.put("streamingMediaInfoList", streamingMediaInfoList);
        response.put("resultState", "OK");
        return ResponseEntity.ok(response);
    }

    @Operation(summary = "스트리밍 미디어 등록", description = "스트리밍 미디어 메타데이터를 등록합니다.")
    @PostMapping("/stm/insertStreamingMediaInfo.do")
    public ResponseEntity<Map<String, Object>> insertStreamingMediaInfo(StreamingMediaAPIVO vo) throws Exception {
        if (DeviceUuidCheck.isBlank(vo.getUuid())) {
            return DeviceUuidCheck.requiredResponse();
        }
        Map<String, Object> response = new HashMap<>();
        int cnt = egovStreamingMediaInfoAPIService.insertStreamingMediaInfo(vo);
        if (cnt > 0) {
            response.put("resultState", "OK");
            response.put("resultMessage", "insert success");
        } else {
            response.put("resultState", "FAIL");
            response.put("resultMessage", "insert fail");
        }
        return ResponseEntity.ok(response);
    }

    @Operation(summary = "스트리밍 미디어 삭제", description = "sn·uuid 기준 스트리밍 미디어 정보를 논리 삭제(USEYN='N')합니다.")
    @DeleteMapping("/stm/deleteStreamingMediaInfo.do")
    public ResponseEntity<Map<String, Object>> deleteStreamingMediaInfo(StreamingMediaAPIVO vo) throws Exception {
        if (DeviceUuidCheck.isBlank(vo.getUuid())) {
            return DeviceUuidCheck.requiredResponse();
        }
        if (vo.getSn() <= 0) {
            Map<String, Object> response = new HashMap<>();
            response.put("resultState", "FAIL");
            response.put("resultMessage", "sn is required");
            return ResponseEntity.badRequest().body(response);
        }

        Map<String, Object> response = new HashMap<>();
        int cnt = egovStreamingMediaInfoAPIService.deleteStreamingMediaInfo(vo);
        if (cnt > 0) {
            response.put("resultState", "OK");
            response.put("resultMessage", "delete success");
        } else {
            response.put("resultState", "FAIL");
            response.put("resultMessage", "delete fail");
        }
        return ResponseEntity.ok(response);
    }

    @Operation(summary = "가이드: 멀티미디어 목록 조회", description = "하이브리드 가이드 호환 mediaInfoList.do")
    @RequestMapping(value = "/stm/mediaInfoList.do", method = {RequestMethod.GET, RequestMethod.POST})
    public ResponseEntity<Map<String, Object>> mediaInfoList(MediaAPIVO searchVO) throws Exception {
        if (DeviceUuidCheck.isBlank(searchVO.getUuid())) {
            return DeviceUuidCheck.requiredResponse();
        }
        Map<String, Object> response = new HashMap<>();
        List<MediaAPIVO> resultSet = egovMediaAPIService.selectMediaInfoList(searchVO);
        response.put("resultState", "OK");
        response.put("resultSet", resultSet);
        return ResponseEntity.ok(response);
    }

    @Operation(summary = "가이드: 멀티미디어 스트리밍", description = "하이브리드 가이드 호환 getMediaStreaming.do")
    @RequestMapping(value = "/stm/getMediaStreaming.do", method = {RequestMethod.GET, RequestMethod.POST})
    public void getMediaStreaming(
            @Parameter(description = "미디어 일련번호") @RequestParam("sn") int sn,
            @Parameter(description = "기기 식별코드") @RequestParam("uuid") String uuid,
            HttpServletResponse response) throws Exception {
        if (DeviceUuidCheck.isBlank(uuid)) {
            fileMngUtil.writeDownloadError(response, HttpServletResponse.SC_BAD_REQUEST, "uuid is required");
            return;
        }

        MediaAPIVO searchVO = new MediaAPIVO();
        searchVO.setSn(sn);
        searchVO.setUuid(uuid);
        int fileSn = egovMediaAPIService.selectMediaFileSnBySn(searchVO);
        if (fileSn <= 0) {
            fileMngUtil.writeDownloadError(response, HttpServletResponse.SC_NOT_FOUND, "미디어 파일을 찾을 수 없습니다.");
            return;
        }

        try {
            fileMngUtil.streamMediaFile(response, fileSn, uuid);
        } catch (SecurityException e) {
            fileMngUtil.writeDownloadError(response, HttpServletResponse.SC_FORBIDDEN, "파일 접근 권한이 없습니다.");
        } catch (IOException e) {
            fileMngUtil.writeDownloadError(response, HttpServletResponse.SC_NOT_FOUND, "스트리밍 파일을 찾을 수 없습니다.");
        }
    }

    @Operation(summary = "가이드: 재생횟수 업데이트", description = "하이브리드 가이드 호환 updateMediaInfoRevivCo.do")
    @RequestMapping(value = "/stm/updateMediaInfoRevivCo.do", method = {RequestMethod.GET, RequestMethod.POST})
    public ResponseEntity<Map<String, Object>> updateMediaInfoRevivCo(
            @RequestParam(value = "sn", required = false) Integer sn,
            MediaAPIVO mediaVO) throws Exception {
        if (DeviceUuidCheck.isBlank(mediaVO.getUuid())) {
            return DeviceUuidCheck.requiredResponse();
        }
        Map<String, Object> response = new HashMap<>();
        int targetSn = sn != null ? sn : mediaVO.getSn();
        if (targetSn <= 0) {
            response.put("resultState", "FAIL");
            response.put("resultMessage", "invalid sn");
            return ResponseEntity.ok(response);
        }

        MediaAPIVO vo = new MediaAPIVO();
        vo.setSn(targetSn);
        vo.setUuid(mediaVO.getUuid());
        int cnt = egovMediaAPIService.updateMediaInfoRevivCo(vo);
        if (cnt > 0) {
            response.put("resultState", "OK");
        } else {
            response.put("resultState", "FAIL");
        }
        return ResponseEntity.ok(response);
    }
}
