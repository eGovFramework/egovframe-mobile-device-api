package egovframework.hyb.mbl.mda.web;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import org.egovframe.rte.fdl.property.EgovPropertyService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.support.SessionStatus;
import org.springframework.web.multipart.MultipartFile;

import egovframework.hyb.mbl.mda.service.EgovMediaAPIService;
import egovframework.hyb.mbl.mda.service.MediaAPIVO;
import egovframework.hyb.utils.EgovFileMngUtil;
import egovframework.hyb.utils.EgovFileService;
import egovframework.hyb.utils.FileVO;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.annotation.Resource;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * 통합 Media API Controller
 */
@Controller
@Tag(name = "09. Media Guide Program Service", description = "미디어 API 관리")
public class EgovMediaAPIController {

    private static final Logger LOGGER = LoggerFactory.getLogger(EgovMediaAPIController.class);

    @Resource(name = "EgovMediaAPIService")
    private EgovMediaAPIService egovMediaAPIService;
    
    @Resource(name = "EgovFileService")
    private EgovFileService egovFileService;

    @Resource(name = "egovFileMngUtil")
    private EgovFileMngUtil fileMngUtil;

    @Resource(name = "propertiesService")
    protected EgovPropertyService propertiesService;

    @Operation(summary = "미디어 정보 목록 조회", description = "미디어 정보 목록을 조회합니다.")
    @RequestMapping(value = "/mda/selectMediaInfoList.do", method = RequestMethod.GET)
    public ResponseEntity<?> selectMediaInfoList(@ModelAttribute("searchVO") MediaAPIVO searchVO, ModelMap model) throws Exception {
        Map<String, Object> response = new HashMap<>();
        List<?> mediaInfoList = egovMediaAPIService.selectMediaInfoList(searchVO);
        //List<?> mediaInfoList = egovMediaAPIService.selectMediaInfoList(searchVO);
        response.put("mediaInfoList", mediaInfoList);
        LOGGER.debug("Media info list retrieved: {} items", mediaInfoList != null ? mediaInfoList.size() : 0);
        response.put("resultState", "OK");
        return ResponseEntity.ok(response);
    }

    @Operation(summary = "미디어 정보 등록", description = "미디어 정보를 등록합니다.")
    @RequestMapping(value = "/mda/insertMediaInfo.do", method = RequestMethod.POST)
    public ResponseEntity<?> insertMediaInfo(MediaAPIVO mediaVO, BindingResult bindingResult, Model model, SessionStatus status) throws Exception {
        Map<String, Object> response = new HashMap<>();
        mediaVO.setMdCode("MLT03");
        mediaVO.setUseyn("Y");
        mediaVO.setRevivCo("0");
        int cnt = egovMediaAPIService.insertMediaInfo(mediaVO);
        if(cnt > 0) {
			response.put("resultState","OK");
			response.put("resultMessage","insert success");
		} else {
			response.put("resultState","FAIL");
			response.put("resultMessage","insert fail");
		}
        return ResponseEntity.ok(response);
    }

    @Operation(summary = "미디어 정보 삭제", description = "미디어 정보를 삭제합니다.")
    @RequestMapping(value = "/mda/deleteMediaInfo.do", method = RequestMethod.DELETE)
    public ResponseEntity<?> deleteMediaInfo(MediaAPIVO mediaVO, BindingResult bindingResult, Model model, SessionStatus status) throws Exception {
        Map<String, Object> response = new HashMap<>();
        int cnt = egovMediaAPIService.deleteMediaInfo(mediaVO);
        if(cnt > 0) {
			response.put("resultState","OK");
			response.put("resultMessage","delete success");
		} else {
			response.put("resultState","FAIL");
			response.put("resultMessage","delete fail");
		}
        return ResponseEntity.ok(response);
    }

    @Operation(summary = "미디어 파일 업로드", description = "미디어 파일을 업로드합니다. (단일 또는 여러 파일 지원)")
    @RequestMapping(value = "/mda/uploadMediaFile.do", method = RequestMethod.POST)
    public ResponseEntity<?> uploadMediaFile(
            @Parameter(description = "업로드할 파일(들)") @RequestParam("files") MultipartFile[] files,
            @Parameter(description = "기기 식별코드") @RequestParam("uuid") String uuid,
            @Parameter(description = "시작 SN") @RequestParam(value = "startSn", required = false, defaultValue = "1") int startSn,
            HttpServletRequest request) throws Exception {
       
        Map<String, Object> response = new HashMap<>();
        
        try {
            if (files == null || files.length == 0) {
                response.put("resultState", "FAIL");
                response.put("resultMessage", "업로드할 파일이 없습니다.");
                return ResponseEntity.ok(response);
            }
            
            // MultipartFile 배열을 List로 변환
            List<MultipartFile> fileList = new ArrayList<>();
            for (MultipartFile file : files) {
                if (file != null && !file.isEmpty()) {
                    fileList.add(file);
                }
            }
            
            if (fileList.isEmpty()) {
                response.put("resultState", "FAIL");
                response.put("resultMessage", "유효한 파일이 없습니다.");
                return ResponseEntity.ok(response);
            }
            
            // 일괄 업로드 처리 (미디어 파일 확장자 검증 포함)
            List<FileVO> uploadedFiles = fileMngUtil.writeUploadedFile(fileList, true);
            
            // 각 파일에 대해 미디어 정보 등록
            List<Map<String, Object>> fileResults = new ArrayList<>();
            int currentSn = startSn;
            int successCount = 0;
            int failCount = 0;
            
            for (FileVO fileVO : uploadedFiles) {
                try {
                    MediaAPIVO mediaVO = new MediaAPIVO();
                    mediaVO.setSn(currentSn);
                    mediaVO.setUuid(uuid);
                    mediaVO.setFileSn(fileVO.getFileSn());
                    mediaVO.setMdSj(fileVO.getOrignlFileNm());
                    mediaVO.setMdCode("MLT03");
                    mediaVO.setUseyn("Y");
                    mediaVO.setRevivCo("0");
                    
                    int cnt = egovMediaAPIService.insertMediaInfo(mediaVO);
                    if (cnt > 0) {
                        successCount++;
                        Map<String, Object> result = new LinkedHashMap<>();
                        result.put("fileSn", fileVO.getFileSn());
                        result.put("fileName", fileVO.getOrignlFileNm());
                        result.put("status", "SUCCESS");
                        fileResults.add(result);
                    } else {
                        failCount++;
                        Map<String, Object> result = new LinkedHashMap<>();
                        result.put("fileSn", fileVO.getFileSn());
                        result.put("fileName", fileVO.getOrignlFileNm());
                        result.put("status", "FAIL");
                        result.put("message", "미디어 정보 등록 실패");
                        fileResults.add(result);
                    }
                    currentSn++;
                } catch (Exception e) {
                    failCount++;
                    Map<String, Object> result = new LinkedHashMap<>();
                    result.put("fileSn", fileVO.getFileSn());
                    result.put("fileName", fileVO.getOrignlFileNm());
                    result.put("status", "FAIL");
                    result.put("message", "오류: " + e.getMessage());
                    fileResults.add(result);
                }
            }
            
            // 단일 파일인 경우 기존 형식과 호환되도록 응답 구성
            if (uploadedFiles.size() == 1 && successCount == 1) {
                FileVO fileVO = uploadedFiles.get(0);
                response.put("resultState", "OK");
                response.put("fileVO", fileVO);
                response.put("fileSn", fileVO.getFileSn());
            } else {
                response.put("resultState", failCount == 0 ? "OK" : "PARTIAL");
                response.put("totalFiles", uploadedFiles.size());
                response.put("successCount", successCount);
                response.put("failCount", failCount);
                response.put("fileResults", fileResults);
            }
            
        } catch (Exception e) {
            response.put("resultState", "FAIL");
            response.put("resultMessage", "업로드 실패: " + e.getMessage());
        }
        
        return ResponseEntity.ok(response);
    }

    @Operation(summary = "미디어 파일 다운로드", description = "미디어 파일을 다운로드합니다.")
    @RequestMapping(value = "/mda/downloadMediaFile.do", method = RequestMethod.GET)
    public void downloadMediaFile(@Parameter(description = "파일 일련번호") @RequestParam("fileSn") int fileSn, HttpServletResponse response) throws Exception {
    	
    	
        try {
        	byte[] fileData = fileMngUtil.fileDownload(response, fileSn);
             
            // MIME 타입은 fileDownload 메서드 내부에서 설정
            if (response.getContentType() == null) {
                response.setContentType("application/octet-stream");
            }
            response.setContentLength(fileData.length);
            
            response.getOutputStream().write(fileData);
            response.getOutputStream().flush();
            
        } catch (IOException e) {
            response.setStatus(HttpServletResponse.SC_NOT_FOUND);
            response.getWriter().write("파일을 찾을 수 없습니다.");
        }
    }

    // 파일 확장자 추출
    private String getFileExtension(String filename) {
        if (filename == null || filename.lastIndexOf(".") == -1) {
            return "";
        }
        return filename.substring(filename.lastIndexOf("."));
    }

}
