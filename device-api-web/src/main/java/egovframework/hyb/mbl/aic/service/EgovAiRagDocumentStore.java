package egovframework.hyb.mbl.aic.service;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.stereotype.Component;
import org.springframework.util.FileCopyUtils;
import org.springframework.util.unit.DataSize;
import org.springframework.web.multipart.MultipartFile;

import egovframework.hyb.utils.EgovWebUtil;
import jakarta.annotation.Resource;

/**
 * RAG 공통 문서를 {@code ai-rag.fileStorePath}에 저장한다.
 * 인덱싱(임베딩)은 하지 않고, 저장 후 ai-rag 재인덱싱을 호출하는 쪽에서 처리한다.
 */
@Component
public class EgovAiRagDocumentStore {

	private static final Logger LOGGER = LoggerFactory.getLogger(EgovAiRagDocumentStore.class);

	@Value("${ai-rag.fileStorePath}")
	private String fileStorePath;

	@Value("${ai-rag.allowedFileExtensions}")
	private String allowedFileExtensions;

	@Value("${Globals.dangerousFileExtensions}")
	private String dangerousFileExtensions;

	@Value("${spring.servlet.multipart.max-file-size:100MB}")
	private String maxFileSize;

	@Resource
	private MessageSourceAccessor messageSourceAccessor;

	private String msg(String code, Object... args) {
		return messageSourceAccessor.getMessage(code, args);
	}

	public String allowedFileExtensions() {
		return allowedFileExtensions == null ? "" : allowedFileExtensions.trim();
	}

	public String resolvedStorePath() {
		if (fileStorePath == null) {
			return "";
		}
		return fileStorePath.trim();
	}

	public List<Map<String, Object>> save(List<MultipartFile> files) throws Exception {
		if (files == null || files.isEmpty()) {
			throw new IllegalArgumentException(msg("aic.msg.uploadEmpty"));
		}

		File storeDir = storeDirectory();
		long maxSize = getMaxFileSizeInBytes();
		for (MultipartFile file : files) {
			String filename = originalFilename(file);
			if (isDangerousFileExtension(filename)) {
				throw new SecurityException(msg("aic.error.dangerous", filename));
			}
			if (!isAllowedFileExtension(filename)) {
				throw new IllegalArgumentException(msg("aic.error.notAllowed", allowedFileExtensions, filename));
			}
			if (file.getSize() > maxSize) {
				throw new IllegalArgumentException(msg("aic.error.tooLarge", maxFileSize, filename));
			}
		}

		if (!storeDir.exists() && !storeDir.mkdirs()) {
			throw new IOException(msg("aic.error.mkdir", storeDir.getAbsolutePath()));
		}

		List<Map<String, Object>> saved = new ArrayList<>();
		for (MultipartFile file : files) {
			String filename = originalFilename(file);
			File dest = new File(storeDir, filename);
			if (!dest.getCanonicalPath().startsWith(storeDir.getCanonicalPath() + File.separator)) {
				throw new SecurityException(msg("aic.error.path", filename));
			}
			try (InputStream in = file.getInputStream(); OutputStream out = Files.newOutputStream(dest.toPath())) {
				FileCopyUtils.copy(in, out);
			}
			Map<String, Object> item = new LinkedHashMap<>();
			item.put("fileName", filename);
			item.put("fileSize", file.getSize());
			saved.add(item);
			LOGGER.info("ai-rag document saved: {}", dest.getAbsolutePath());
		}
		return saved;
	}

	public List<String> listStoredFileNames() {
		File storeDir = new File(EgovWebUtil.filePathBlackList(resolvedStorePath()));
		if (!storeDir.isDirectory()) {
			return List.of();
		}
		File[] children = storeDir.listFiles(File::isFile);
		if (children == null || children.length == 0) {
			return List.of();
		}
		List<String> names = new ArrayList<>();
		for (File child : children) {
			if (isAllowedFileExtension(child.getName())) {
				names.add(child.getName());
			}
		}
		names.sort(String.CASE_INSENSITIVE_ORDER);
		return names;
	}

	private File storeDirectory() {
		String path = resolvedStorePath();
		if (path.isEmpty() || "/".equals(path) || File.separator.equals(path)) {
			throw new SecurityException(msg("aic.error.storePath"));
		}
		return new File(EgovWebUtil.filePathBlackList(path));
	}

	private String originalFilename(MultipartFile file) {
		String raw = file.getOriginalFilename();
		if (raw == null || raw.isBlank()) {
			throw new IllegalArgumentException(msg("aic.error.noFilename"));
		}
		Path name = Paths.get(raw).getFileName();
		if (name == null) {
			throw new IllegalArgumentException(msg("aic.error.noFilename"));
		}
		String filename = name.toString().trim();
		if (filename.isEmpty() || filename.contains("..") || filename.contains("/") || filename.contains("\\")) {
			throw new SecurityException(msg("aic.error.badFilename", raw));
		}
		return filename;
	}

	private boolean isAllowedFileExtension(String filename) {
		return matchesExtensionList(filename, allowedFileExtensions);
	}

	private boolean isDangerousFileExtension(String filename) {
		return matchesExtensionList(filename, dangerousFileExtensions);
	}

	private boolean matchesExtensionList(String filename, String csv) {
		if (filename == null || filename.isEmpty() || csv == null || csv.isBlank()) {
			return false;
		}
		String extension = fileExtension(filename).toLowerCase(Locale.ROOT);
		if (extension.isEmpty()) {
			return false;
		}
		for (String token : csv.split(",")) {
			String allowed = token.trim().toLowerCase(Locale.ROOT);
			if (!allowed.isEmpty() && extension.equals(allowed)) {
				return true;
			}
		}
		return false;
	}

	private String fileExtension(String filename) {
		int dot = filename.lastIndexOf('.');
		if (dot < 0) {
			return "";
		}
		return filename.substring(dot);
	}

	private long getMaxFileSizeInBytes() {
		return DataSize.parse(maxFileSize).toBytes();
	}
}
