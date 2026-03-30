/**
 * 
 */
package egovframework.hyb.utils;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;

import org.apache.commons.io.FilenameUtils;
import org.apache.commons.lang3.StringUtils;
import org.egovframe.rte.fdl.cmmn.EgovAbstractServiceImpl;
import org.egovframe.rte.fdl.idgnr.EgovIdGnrService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.multipart.MultipartFile;

import jakarta.annotation.Resource;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * @Class Name : EgovFileTransfer.java
 * @Description : EgovFileTransfer
 *  == 개정이력(Modification Information) ==
 *
 *   수정일      수정자           수정내용
 *  -------    --------    ---------------------------
 * 2012. 7. 10.  서준식        최초생성 
 * 2017.02. 27.  최두영        시큐어코딩(ES)-36. 부적절한 예외 처리[CWE253,CWE-440, CWE-754]
 * 2026.03. 17.  이현지        KISA 보안취약점 조치(filePathBlackList)
 * 
 * 
 * @author 디바이스 API 실행환경 개발팀
 * @since 2012. 7. 10.
 * @version 1.0
 * @see
 * 
 *      Copyright (C) by MOPAS All right reserved.
 */
@Service("egovFileMngUtil")
public class EgovFileMngUtil extends EgovAbstractServiceImpl {

	/** Logger */
	private static final Logger LOGGER = LoggerFactory.getLogger(EgovFileMngUtil.class);

	/** EgovIdGnrService */
	@Resource(name = "egovFileIdGnrService")
	private EgovIdGnrService egovFileIdGnrService;

	/** EgovFileService */
	@Resource(name = "EgovFileService")
	private EgovFileService fileService;
	
	/** 파일 저장 경로 */
	@Value("${Globals.fileStorePath}")
	String filePath;
	
	/** 파일 최대 사이즈 */
	@Value("${spring.servlet.multipart.maxFileSize}")
	private String maxFileSize;
	
	/** 파일 확장자 목록 (위험/차단) */
	@Value("${Globals.dangerousFileExtensions}")
	private String dangerousFileExtensions;
	
	/** 파일 확장자 목록 (허용) */
	@Value("${Globals.allowedMediaExtensions}")
	private String allowedMediaExtensions;
	

	/**
	 * 사용자가 전송한 파일을 업로드 한다. 
	 * 
	 * @param files - 업로드할 파일 목록
	 * @param checkMediaFileExtension - 미디어 파일 확장자 검증 여부 (true: 미디어 파일만, false: 확장자 제한 없음)
	 * @return List<FileVO> - 업로드된 파일 정보 목록
	 * @exception Exception
	 */
	public List<FileVO> writeUploadedFile(List<MultipartFile> files, boolean checkMediaFileExtension) throws Exception {
		List<FileVO> result = new ArrayList<FileVO>();
		long maxSize = getMaxFileSizeInBytes();
		
		// 모든 파일 사전 검증
		for (MultipartFile file : files) {
			String originFileName = file.getOriginalFilename();
			if (StringUtils.isEmpty(originFileName)) {
				continue;
			}
			
			// 보안 검증: 위험한 파일 확장자 차단
			if (isDangerousFileExtension(originFileName)) {
				LOGGER.warn("Dangerous file extension detected: {}", originFileName);
				throw new SecurityException("위험한 파일 확장자는 업로드할 수 없습니다: " + originFileName);
			}
			
			// 보안 검증: 파일 크기 제한
			if (!isValidFileSize(file.getSize(), maxSize)) {
				LOGGER.warn("File size exceeds limit: {} bytes (max: {} bytes) - {}", 
						file.getSize(), maxSize, originFileName);
				throw new IllegalArgumentException(
						"파일 크기는 " + maxFileSize + "를 초과할 수 없습니다: " + originFileName);
			}
			
			// 보안 검증: 미디어 파일 타입 검증 (옵션)
			if (checkMediaFileExtension && !isValidMediaFile(originFileName)) {
				LOGGER.warn("Invalid media file type: {}", originFileName);
				throw new IllegalArgumentException(
						"미디어 파일만 업로드 가능합니다: " + originFileName);
			}
		}
		
		// 검증 통과 후 일괄 처리
		int fileKey = 1;
		for (MultipartFile file : files) {
			String originFileName = file.getOriginalFilename();
			if (StringUtils.isEmpty(originFileName)) {
				continue;
			}
			
			// 2022.11.11 시큐어코딩 처리 - FilenameUtils 사용
			String fileExt = "";
			if (StringUtils.isNotEmpty(originFileName)) {
				fileExt = FilenameUtils.getExtension(originFileName);
			}
			String newName = "File_" + getTimeStamp() + "_" + fileKey;
			
			FileVO fileVO = new FileVO();
			fileVO.setFileStreCours(filePath);
			fileVO.setOrignlFileNm(originFileName);
			fileVO.setStreFileNm(newName);
			fileVO.setFileExtsn(fileExt);
			fileVO.setFileSize(Long.toString(file.getSize()));
			fileVO.setFileSn(egovFileIdGnrService.getNextIntegerId());
			
			if (!file.isEmpty()) {
				File cFile = new File(EgovWebUtil.filePathBlackList(filePath));
				if (!cFile.isDirectory()) {
					if (cFile.mkdirs()) {
						LOGGER.debug("[file.mkdirs] saveFolder : Creation Success ");
					} else {
						LOGGER.error("[file.mkdirs] saveFolder : Creation Fail ");
						throw new IOException("Directory creation Failed ");
					}
				}
				
				String writeFilePath = EgovWebUtil
						.filePathBlackList(filePath + File.separator + newName + "." + fileExt);
				
				try (InputStream stream = file.getInputStream(); 
						OutputStream bos = new FileOutputStream(writeFilePath);) {
					FileCopyUtils.copy(stream, bos);
				}
			}
			
			// DB에 파일 정보 저장
			int dbResult = fileService.insertFileDetailInfo(fileVO);
			if (dbResult > 0) {
				result.add(fileVO);
			} else {
				LOGGER.warn("Failed to save file info to DB: {}", originFileName);
				// DB 저장 실패해도 파일은 저장되었으므로 결과에 포함
				result.add(fileVO);
			}
			
			fileKey++;
		}
		
		return result;
	}


	/**
	 * 선택된 파일에 대한 다운로드 기능을 처리한다.
	 * 
	 * @param response - HttpServletResponse
	 * @param fileSn   - 파일 일련번호
	 * @return byte[]
	 * @exception Exception
	 */
	public byte[] fileDownload(HttpServletResponse response, int fileSn) throws Exception {
		
		FileVO fileVO = new FileVO();
		fileVO = fileService.selectFileDetailInfo(fileSn);
		if (fileVO == null) {
			throw new FileNotFoundException("File not found for fileSn: " + fileSn);
		}
		
		// 2022.11.11 시큐어코딩 처리 - 경로 검증 추가
		String downloadFilePath = EgovWebUtil.filePathBlackList(
				filePath + File.separator + fileVO.getStreFileNm() + "." + fileVO.getFileExtsn());
		File file = new File(downloadFilePath);
		byte[] buffer = null;
		
		try (FileInputStream fis = new FileInputStream(file)) {
			
			if (!file.exists()) {
				throw new FileNotFoundException(fileVO.getStreFileNm());
			}
			if (!file.isFile()) {
				throw new FileNotFoundException(fileVO.getStreFileNm());
			}
			
			// MIME 타입 설정
			if (response != null) {
				String originalFileName = fileVO.getOrignlFileNm();
				response.setContentType("application/octet-stream");
				
				// 파일명 인코딩
				String encodedFileName = URLEncoder.encode(originalFileName, StandardCharsets.UTF_8).replace("+", "%20");
				response.setHeader("Content-Disposition", 
						"attachment; filename=\"" + originalFileName.replace("\"", "\\\"") + "\"; filename*=UTF-8''" + encodedFileName);
			}
			
			buffer = new byte[(int) file.length()];
			fis.read(buffer);
			return buffer;
			
		} catch (Exception e) {
			LOGGER.error("File download error: {}", e.getMessage());
			throw e;
		}
	}

	/**
	 * 선택된 파일에 대한 삭제 기능을 처리한다. (기존 코드 호환성)
	 * 
	 * @param fileVO - 파일 정보가 담긴 FileVO
	 * @exception Exception
	 */
	public void deleteFile(FileVO fileVO) throws Exception {

		// 2022.11.11 시큐어코딩 처리 - 경로 검증 추가
		String deleteFilePath = EgovWebUtil.filePathBlackList(filePath + File.separator + fileVO.getStreFileNm());
		File file = new File(deleteFilePath);

		if (!file.exists()) {
			LOGGER.info("There is no file to remove.");
			return;
		}
		if (!file.isFile()) {
			LOGGER.info("This is not file.");
			return;
		}

		boolean result = file.delete();

		if (!result) {
			LOGGER.info("Fail to remove file.");
		}
	}

	/**
	 * 위험한 파일 확장자 차단 검증
	 * 
	 * @param filename 파일명
	 * @return true: 위험한 확장자, false: 안전한 확장자
	 */
	private boolean isDangerousFileExtension(String filename) {
		if (filename == null || filename.isEmpty()) {
			return true;
		}
		
		String extension = getFileExtension(filename).toLowerCase();
		
		// application.properties에서 위험한 확장자 목록 읽어오기
		if (dangerousFileExtensions == null || dangerousFileExtensions.isEmpty()) {
			LOGGER.warn("dangerousFileExtensions is not configured, using default list");
			return false;
		}
		
		String[] dangerousExtensions = dangerousFileExtensions.split(",");
		for (String dangerousExt : dangerousExtensions) {
			String trimmedExt = dangerousExt.trim().toLowerCase();
			if (!trimmedExt.isEmpty() && extension.equals(trimmedExt)) {
				return true;
			}
		}
		
		return false;
	}


	/**
	 * 파일 확장자 추출 
	 */
	private String getFileExtension(String filename) {
		if (filename == null || filename.lastIndexOf(".") == -1) {
			return "";
		}
		return filename.substring(filename.lastIndexOf("."));
	}

	/**
	 * 파일 크기 검증 
	 */
	public boolean isValidFileSize(long fileSize, long maxSize) {
		return fileSize <= maxSize;
	}

	/**
	 * 미디어 파일 타입 검증
	 * 
	 * @param filename 파일명
	 * @return true: 허용된 미디어 파일, false: 허용되지 않은 파일
	 */
	public boolean isValidMediaFile(String filename) {
		if (filename == null || filename.isEmpty()) {
			return false;
		}
		
		String extension = getFileExtension(filename).toLowerCase();
		
		// application.properties에서 허용된 미디어 확장자 목록 읽어오기
		if (allowedMediaExtensions == null || allowedMediaExtensions.isEmpty()) {
			LOGGER.warn("allowedMediaExtensions is not configured, using default list");
			return false;
		}
		
		// properties에서 읽어온 확장자 목록 파싱
		String[] allowedExtensions = allowedMediaExtensions.split(",");
		for (String allowedExt : allowedExtensions) {
			String trimmedExt = allowedExt.trim().toLowerCase();
			if (!trimmedExt.isEmpty() && extension.equals(trimmedExt)) {
				return true;
			}
		}
		
		return false;
	}

	/**
	 * 공통 컴포넌트 utl.fcc 패키지와 Dependency 제거를 위해 내부 메서드로 추가 정의함 응용어플리케이션에서 고유값을 사용하기 위해
	 * 시스템에서 17자리의 TIMESTAMP값을 구하는 기능
	 *
	 * @param
	 * @return Timestamp 값
	 * @see
	 */
	private String getTimeStamp() {

		String rtnStr = null;

		// 문자열로 변환하기 위한 패턴 설정(연도-월-일 시:분:초)
		String pattern = "yyyyMMddhhmmss";

		SimpleDateFormat sdfCurrent = new SimpleDateFormat(pattern, Locale.KOREA);
		Timestamp ts = new Timestamp(System.currentTimeMillis());

		rtnStr = sdfCurrent.format(ts.getTime());

		return rtnStr;
	}
	
	/**
	 * application.properties의 maxFileSize 문자열을 바이트로 변환
	 * 
	 * @return 최대 파일 크기 (바이트)
	 */
	private long getMaxFileSizeInBytes() {
		if (maxFileSize == null || maxFileSize.isEmpty()) {
			return 20 * 1024 * 1024; // 기본값 20MB
		}
		
		String sizeStr = maxFileSize.trim().toUpperCase();
		long multiplier = 1;
		
		if (sizeStr.endsWith("KB")) {
			multiplier = 1024;
			sizeStr = sizeStr.substring(0, sizeStr.length() - 2);
		} else if (sizeStr.endsWith("MB")) {
			multiplier = 1024 * 1024;
			sizeStr = sizeStr.substring(0, sizeStr.length() - 2);
		} else if (sizeStr.endsWith("GB")) {
			multiplier = 1024 * 1024 * 1024;
			sizeStr = sizeStr.substring(0, sizeStr.length() - 2);
		} else if (sizeStr.endsWith("B")) {
			multiplier = 1;
			sizeStr = sizeStr.substring(0, sizeStr.length() - 1);
		}
		
		try {
			return Long.parseLong(sizeStr.trim()) * multiplier;
		} catch (NumberFormatException e) {
			LOGGER.warn("Invalid maxFileSize format: {}, using default 20MB", maxFileSize);
			return 20 * 1024 * 1024; // 기본값 20MB
		}
	}
}
