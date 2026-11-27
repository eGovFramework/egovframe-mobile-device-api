package egovframework.hyb.utils;

import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;
import java.util.UUID;
import java.util.regex.Pattern;

import org.apache.commons.io.FilenameUtils;
import org.egovframe.rte.fdl.cmmn.EgovAbstractServiceImpl;
import org.egovframe.rte.fdl.idgnr.EgovIdGnrService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.ContentDisposition;
import org.springframework.http.HttpHeaders;
import org.springframework.stereotype.Service;
import org.springframework.util.FileCopyUtils;
import org.springframework.util.unit.DataSize;
import org.springframework.web.multipart.MultipartFile;

import jakarta.annotation.Resource;
import jakarta.servlet.http.HttpServletResponse;

/**
 * 업로드 파일 저장, 다운로드, 스트리밍, 삭제
 *
 * 수정이력
 * 2012.07.10 서준식 최초생성
 * 2017.02.27 최두영 시큐어코딩(ES)-36 부적절한 예외 처리
 * 2026.03.17 이현지 KISA 보안취약점 조치(filePathBlackList)
 */
@Service("egovFileMngUtil")
public class EgovFileMngUtil extends EgovAbstractServiceImpl {

	private static final Logger LOGGER = LoggerFactory.getLogger(EgovFileMngUtil.class);

	/** 저장 확장자는 영숫자만 허용(FILE_EXTSN 컬럼 길이 20) */
	private static final Pattern SAFE_EXTENSION = Pattern.compile("[A-Za-z0-9]{1,20}");

	@Resource(name = "egovFileIdGnrService")
	private EgovIdGnrService egovFileIdGnrService;

	@Resource(name = "EgovFileService")
	private EgovFileService fileService;

	@Value("${Globals.fileStorePath}")
	private String filePath;

	@Value("${spring.servlet.multipart.max-file-size}")
	private String maxFileSize;

	@Value("${Globals.dangerousFileExtensions}")
	private String dangerousFileExtensions;

	@Value("${Globals.allowedMediaExtensions}")
	private String allowedMediaExtensions;

	/**
	 * 업로드 파일을 검증 후 저장하고 파일 정보를 등록한다.
	 *
	 * @param files 업로드 파일 목록
	 * @param checkMediaFileExtension true면 미디어 확장자만 허용
	 */
	public List<FileVO> writeUploadedFile(List<MultipartFile> files, boolean checkMediaFileExtension) throws Exception {
		long maxSize = DataSize.parse(maxFileSize).toBytes();

		// 저장 전에 전체 파일을 검증한다.
		for (MultipartFile file : files) {
			String originFileName = originalFileName(file);
			if (originFileName.isEmpty()) {
				continue;
			}
			String extension = extensionOf(originFileName);
			if (matchesExtension(extension, dangerousFileExtensions)) {
				LOGGER.warn("Dangerous file extension detected: {}", originFileName);
				throw new SecurityException("위험한 파일 확장자는 업로드할 수 없습니다: " + originFileName);
			}
			if (file.getSize() > maxSize) {
				LOGGER.warn("File size exceeds limit: {} bytes (max: {} bytes) - {}", file.getSize(), maxSize, originFileName);
				throw new IllegalArgumentException("파일 크기는 " + maxFileSize + "를 초과할 수 없습니다: " + originFileName);
			}
			if (checkMediaFileExtension && !matchesExtension(extension, allowedMediaExtensions)) {
				LOGGER.warn("Invalid media file type: {}", originFileName);
				throw new IllegalArgumentException("미디어 파일만 업로드 가능합니다: " + originFileName);
			}
		}

		File saveDir = new File(EgovWebUtil.filePathBlackList(filePath));
		if (!saveDir.isDirectory() && !saveDir.mkdirs()) {
			LOGGER.error("[file.mkdirs] saveFolder : Creation Fail");
			throw new IOException("Directory creation Failed");
		}

		List<FileVO> result = new ArrayList<>();
		for (MultipartFile file : files) {
			String originFileName = originalFileName(file);
			if (originFileName.isEmpty()) {
				continue;
			}
			String fileExt = extensionOf(originFileName);
			// 동시 업로드 시 덮어쓰지 않도록 저장명은 UUID로 만든다.
			String newName = "File_" + UUID.randomUUID().toString().replace("-", "");

			FileVO fileVO = new FileVO();
			fileVO.setFileStreCours(filePath);
			fileVO.setOrignlFileNm(originFileName);
			fileVO.setStreFileNm(newName);
			fileVO.setFileExtsn(fileExt);
			fileVO.setFileSize(Long.toString(file.getSize()));
			fileVO.setFileSn(egovFileIdGnrService.getNextIntegerId());

			if (!file.isEmpty()) {
				try (InputStream stream = file.getInputStream();
						OutputStream bos = new FileOutputStream(storedFile(fileVO))) {
					FileCopyUtils.copy(stream, bos);
				}
			}

			if (fileService.insertFileDetailInfo(fileVO) <= 0) {
				LOGGER.warn("Failed to save file info to DB: {}", originFileName);
			}
			result.add(fileVO);
		}
		return result;
	}

	/** UUID 소유권 검증 후 파일을 첨부로 내려준다. */
	public void fileDownload(HttpServletResponse response, int fileSn, String uuid) throws IOException {
		if (!fileService.isFileOwnedByUuid(fileSn, uuid)) {
			throw new SecurityException("파일 접근 권한이 없습니다.");
		}
		FileVO fileVO = selectFile(fileSn);
		File file = existingFile(fileVO);

		String originalFileName = fileVO.getOrignlFileNm() == null ? "" : EgovWebUtil.removeCRLF(fileVO.getOrignlFileNm());
		if (originalFileName.isEmpty()) {
			originalFileName = "download";
		}
		response.setContentType("application/octet-stream");
		response.setContentLengthLong(file.length());
		response.setHeader(HttpHeaders.CONTENT_DISPOSITION,
				ContentDisposition.attachment().filename(originalFileName, StandardCharsets.UTF_8).build().toString());
		copyToResponse(file, response);
	}

	/** 다운로드 실패 응답. 본문이 이미 전송됐으면 아무것도 하지 않는다. */
	public void writeDownloadError(HttpServletResponse response, int status, String message) throws IOException {
		if (response.isCommitted()) {
			return;
		}
		response.resetBuffer();
		response.setStatus(status);
		if (message == null) {
			return;
		}
		response.setContentType("text/plain;charset=UTF-8");
		response.getWriter().write(message);
	}

	/** UUID 소유권 검증 후 미디어 파일을 재생용(inline)으로 전송한다. */
	public void streamMediaFile(HttpServletResponse response, int fileSn, String uuid) throws IOException {
		if (!fileService.isFileOwnedByUuid(fileSn, uuid)) {
			throw new SecurityException("파일 접근 권한이 없습니다.");
		}
		FileVO fileVO = selectFile(fileSn);
		File file = existingFile(fileVO);

		response.setContentType(resolveVideoContentType(fileVO.getFileExtsn()));
		response.setContentLengthLong(file.length());
		copyToResponse(file, response);
	}

	/** 저장된 실제 파일을 삭제한다. */
	public void deleteFile(FileVO fileVO) {
		File file = storedFile(fileVO);
		if (!file.isFile()) {
			LOGGER.info("There is no file to remove.");
			return;
		}
		if (!file.delete()) {
			LOGGER.info("Fail to remove file.");
		}
	}

	private FileVO selectFile(int fileSn) throws FileNotFoundException {
		FileVO fileVO = fileService.selectFileDetailInfo(fileSn);
		if (fileVO == null) {
			throw new FileNotFoundException("File not found for fileSn: " + fileSn);
		}
		return fileVO;
	}

	private File existingFile(FileVO fileVO) throws FileNotFoundException {
		File file = storedFile(fileVO);
		if (!file.isFile()) {
			throw new FileNotFoundException(fileVO.getStreFileNm());
		}
		return file;
	}

	/** 저장 경로 + 저장명 + 확장자. 경로 조작 문자열은 제거한다. */
	private File storedFile(FileVO fileVO) {
		return new File(EgovWebUtil.filePathBlackList(
				filePath + File.separator + fileVO.getStreFileNm() + "." + fileVO.getFileExtsn()));
	}

	private void copyToResponse(File file, HttpServletResponse response) throws IOException {
		try (InputStream in = new BufferedInputStream(new FileInputStream(file));
				OutputStream out = response.getOutputStream()) {
			FileCopyUtils.copy(in, out);
		}
	}

	private String originalFileName(MultipartFile file) {
		String name = file.getOriginalFilename();
		return name == null ? "" : EgovWebUtil.removeCRLF(name).trim();
	}

	/** 소문자 확장자. 영숫자가 아니면 빈 문자열 */
	private String extensionOf(String fileName) {
		String ext = FilenameUtils.getExtension(fileName.replace('\\', '/'));
		return SAFE_EXTENSION.matcher(ext).matches() ? ext.toLowerCase(Locale.ROOT) : "";
	}

	/** csv 예: .jpg,.png */
	private boolean matchesExtension(String extension, String csv) {
		if (extension.isEmpty() || csv == null || csv.isBlank()) {
			return false;
		}
		for (String token : csv.split(",")) {
			if (token.trim().equalsIgnoreCase("." + extension)) {
				return true;
			}
		}
		return false;
	}

	private String resolveVideoContentType(String fileExtsn) {
		if (fileExtsn == null) {
			return "video/mp4";
		}
		return switch (fileExtsn.toLowerCase(Locale.ROOT)) {
			case "mp4" -> "video/mp4";
			case "webm" -> "video/webm";
			case "mov" -> "video/quicktime";
			case "avi" -> "video/x-msvideo";
			case "mkv" -> "video/x-matroska";
			case "3gp" -> "video/3gpp";
			default -> "application/octet-stream";
		};
	}
}
