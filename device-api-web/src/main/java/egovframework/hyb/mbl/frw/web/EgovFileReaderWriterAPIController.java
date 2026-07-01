package egovframework.hyb.mbl.frw.web;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
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
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.support.SessionStatus;
import org.springframework.web.multipart.MultipartFile;

import egovframework.hyb.mbl.frw.service.EgovFileReaderWriterAPIService;
import egovframework.hyb.mbl.frw.service.FileReaderWriterAPIVO;
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
 * 통합 FileReaderWriter API Controller
 */
@Controller
@Tag(name = "06. FileReaderWriter Guide Program Service", description = "파일 읽기/쓰기 API 관리")
public class EgovFileReaderWriterAPIController {

    @Resource(name = "EgovFileReaderWriterAPIService")
    private EgovFileReaderWriterAPIService egovFileReaderWriterAPIService;

    @Resource(name = "propertiesService")
    protected EgovPropertyService propertiesService;
    
    @Resource(name = "egovFileMngUtil")
    private EgovFileMngUtil fileMngUtil;

    @Resource(name = "EgovFileService")
    private EgovFileService fileService;

    @Operation(summary = "파일 읽기/쓰기 정보 목록 조회", description = "파일 읽기/쓰기 정보 목록을 조회합니다.")
    @RequestMapping(value = "/frw/selectFileReaderWriterInfoList.do", method = RequestMethod.GET)
    public ResponseEntity<?> selectFileReaderWriterInfoList(@ModelAttribute("searchVO") FileReaderWriterAPIVO searchVO, ModelMap model) throws Exception {
        Map<String, Object> response = new HashMap<>();
        List<?> fileReaderWriterInfoList = egovFileReaderWriterAPIService.selectFileReaderWriterInfoList(searchVO);
        response.put("fileReaderWriterInfoList", fileReaderWriterInfoList);
        response.put("resultState", "OK");
        return ResponseEntity.ok(response);
    }

    @Operation(summary = "파일 읽기/쓰기 정보 등록", description = "파일 읽기/쓰기 정보를 등록합니다.")
    @RequestMapping(value = "/frw/insertFileReaderWriterInfo.do", method = RequestMethod.POST)
    public ResponseEntity<?> insertFileReaderWriterInfo(FileReaderWriterAPIVO fileReaderWriterVO, BindingResult bindingResult, Model model, SessionStatus status) throws Exception {
        Map<String, Object> response = new HashMap<>();

        String uuid = fileReaderWriterVO.getUuid();
        int fileSn = fileReaderWriterVO.getFileSn();

        if (uuid == null || uuid.isBlank()) {
            response.put("resultState", "FAIL");
            response.put("resultMessage", "기기 식별코드가 필요합니다.");
            return ResponseEntity.ok(response);
        }

        if (fileService.selectFileDetailInfo(fileSn) == null) {
            response.put("resultState", "FAIL");
            response.put("resultMessage", "존재하지 않는 파일입니다.");
            return ResponseEntity.ok(response);
        }

        if (fileService.isFileOwnedByUuid(fileSn, uuid)) {
            response.put("resultState", "OK");
            response.put("resultMessage", "insert success");
            return ResponseEntity.ok(response);
        }

        if (fileService.isFileRegistered(fileSn)) {
            response.put("resultState", "FAIL");
            response.put("resultMessage", "다른 기기에 등록된 파일입니다.");
            return ResponseEntity.ok(response);
        }

        response.put("resultState", "FAIL");
        response.put("resultMessage", "파일 업로드 후 등록이 필요합니다.");
        return ResponseEntity.ok(response);
    }

    @Operation(summary = "파일 읽기/쓰기 정보 삭제", description = "파일 읽기/쓰기 정보를 삭제합니다.")
    @RequestMapping(value = "/frw/deleteFileReaderWriterInfo.do", method = RequestMethod.DELETE)
    public ResponseEntity<?> deleteFileReaderWriterInfo(FileReaderWriterAPIVO fileReaderWriterVO, BindingResult bindingResult, Model model, SessionStatus status) throws Exception {
        Map<String, Object> response = new HashMap<>();
        int cnt = egovFileReaderWriterAPIService.deleteFileReaderWriterInfo(fileReaderWriterVO);
        if(cnt > 0) {
			response.put("resultState","OK");
			response.put("resultMessage","delete success");
		} else {
			response.put("resultState","FAIL");
			response.put("resultMessage","delete fail");
		}
        return ResponseEntity.ok(response);
    }
    
    @Operation(summary = "파일 업로드", description = "파일을 업로드합니다. (단일 또는 여러 파일 지원, 확장자 제한 없음)")
    @RequestMapping(value="/frw/fileupload.do", method = RequestMethod.POST)
    public ResponseEntity<?> uploadFile(
            @Parameter(description = "업로드할 파일") @RequestParam("files") MultipartFile[] files,
            @Parameter(description = "기기 식별코드") @RequestParam("uuid") String uuid,
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
            
            // 일괄 업로드 처리 (확장자 제한 없음)
            List<FileVO> uploadedFiles = fileMngUtil.writeUploadedFile(fileList, false);

            for (FileVO fileVO : uploadedFiles) {
                registerUploadedFile(uuid, fileVO);
            }
            
            // 단일 파일인 경우 기존 형식과 호환되도록 응답 구성
            if (uploadedFiles.size() == 1) {
                FileVO fileVO = uploadedFiles.get(0);
                response.put("resultState", "OK");
                response.put("fileVO", fileVO);
                response.put("fileSn", fileVO.getFileSn());
            } else {
                // 여러 파일인 경우
                List<Map<String, Object>> fileResults = new ArrayList<>();
                for (FileVO fileVO : uploadedFiles) {
                    Map<String, Object> result = new LinkedHashMap<>();
                    result.put("fileSn", fileVO.getFileSn());
                    result.put("fileName", fileVO.getOrignlFileNm());
                    result.put("fileSize", fileVO.getFileSize());
                    result.put("fileExtsn", fileVO.getFileExtsn());
                    fileResults.add(result);
                }
                
                response.put("resultState", "OK");
                response.put("totalFiles", uploadedFiles.size());
                response.put("fileResults", fileResults);
            }
            
        } catch (Exception e) {
            response.put("resultState", "FAIL");
            response.put("resultMessage", "업로드 실패: " + e.getMessage());
        }
        
        return ResponseEntity.ok(response);
    }

    private void registerUploadedFile(String uuid, FileVO fileVO) throws Exception {
        FileReaderWriterAPIVO vo = new FileReaderWriterAPIVO();
        vo.setUuid(uuid);
        vo.setFileSn(fileVO.getFileSn());
        vo.setFileNm(fileVO.getOrignlFileNm());
        vo.setFileStreCours(fileVO.getFileStreCours());
        vo.setFileType(fileVO.getFileExtsn());
        vo.setFileSize(fileVO.getFileSize());
        vo.setUseYn("Y");
        egovFileReaderWriterAPIService.insertFileReaderWriterInfo(vo);
    }

    @Operation(summary = "파일 다운로드", description = "기기 UUID 소유권을 검증한 뒤 파일을 다운로드합니다.")
    @RequestMapping(value = "/frw/fileDownload.do", method = RequestMethod.GET)
    public void fileDownload(
            @Parameter(description = "기기 식별코드") @RequestParam("uuid") String uuid,
            @Parameter(description = "파일 일련번호") @RequestParam("fileSn") int fileSn,
            HttpServletResponse response) throws Exception {
        try {
            byte[] fileData = fileMngUtil.fileDownload(response, fileSn, uuid);
            response.setContentType("application/octet-stream");
            response.setContentLength(fileData.length);
            response.getOutputStream().write(fileData);
            response.getOutputStream().flush();
        } catch (SecurityException e) {
            response.setStatus(HttpServletResponse.SC_FORBIDDEN);
            response.getWriter().write("파일 접근 권한이 없습니다.");
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_NOT_FOUND);
            response.getWriter().write("파일을 찾을 수 없습니다.");
        }
    }

}
