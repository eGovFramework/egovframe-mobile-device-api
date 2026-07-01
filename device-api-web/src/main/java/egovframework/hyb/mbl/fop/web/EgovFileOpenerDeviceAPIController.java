package egovframework.hyb.mbl.fop.web;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import egovframework.hyb.mbl.fop.service.EgovFileOpenerDeviceAPIService;
import egovframework.hyb.mbl.fop.service.FileOpenerDeviceAPIVO;
import egovframework.hyb.utils.EgovFileMngUtil;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.annotation.Resource;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * 통합 File Opener API Controller
 */
@Controller
@Tag(name = "13. FileOpener Guide Program Service", description = "파일 오프너 API 관리")
public class EgovFileOpenerDeviceAPIController {

	private final Logger log = LoggerFactory.getLogger(EgovFileOpenerDeviceAPIController.class);

    @Resource(name = "EgovFileOpenerDeviceAPIService")
    private EgovFileOpenerDeviceAPIService egovFileOpenerDeviceAPIService;

	@Resource(name = "egovFileMngUtil")
	private EgovFileMngUtil egovFileMngUtil;

	@Operation(summary = "파일 오프너 정보 목록 조회", description = "기기 UUID에 해당하는 파일 오프너 정보 목록을 조회합니다.")
    @RequestMapping(value = "/fop/selectFileOpenerList.do", method = RequestMethod.GET)
    public ResponseEntity<?> selectFileOpenerList(
    		@Parameter(description = "기기 식별코드") @ModelAttribute("fileOpenerDviceAPIVO") FileOpenerDeviceAPIVO searchVO,
    		ModelMap model) throws Exception {
		Map<String, Object> response = new HashMap<>();
		List<?> fileOpenerDeviceAPIVO = egovFileOpenerDeviceAPIService.selectFileOpenerList(searchVO);
		response.put("resultSet", fileOpenerDeviceAPIVO);
		response.put("resultState","OK");
		return ResponseEntity.ok(response);
    }

	/**
	 * 선택된 파일을 클라이언트로 전송한다.
	 * @param request -  HttpServletRequest 
	 * @param response - HttpServletResponse 
	 * @param fileVO - 전송할 파일 정보가 담긴 ResourceUpdateDeviceAPIVO 
	 * @return ModelAndView
	 * @exception Exception
	 */
    @Operation(summary = "파일 오프너 파일 다운로드", description = "기기 UUID 소유권을 검증한 뒤 파일을 다운로드합니다.")
    @RequestMapping(value = "/fop/fileDownload.do", method = RequestMethod.GET)
	public void fileDownload(
			@Parameter(description = "기기 식별코드") @RequestParam("uuid") String uuid,
			@Parameter(description = "파일 일련번호") @RequestParam("fileSn") int fileSn,
			HttpServletRequest request,
			HttpServletResponse response) throws Exception {
        try {
      	byte[] fildData = egovFileMngUtil.fileDownload(response, fileSn, uuid);
           
          response.setContentType("application/octet-stream");
          response.setContentLength(fildData.length);
          
          response.getOutputStream().write(fildData);
          response.getOutputStream().flush();
          
      } catch (SecurityException e) {
          response.setStatus(HttpServletResponse.SC_FORBIDDEN);
          response.getWriter().write("파일 접근 권한이 없습니다.");
      } catch (IOException e) {
          response.setStatus(HttpServletResponse.SC_NOT_FOUND);
          response.getWriter().write("파일을 찾을 수 없습니다.");
      }
	}


}
