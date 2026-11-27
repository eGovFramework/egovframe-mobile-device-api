package egovframework.hyb.mbl.aic.web;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import egovframework.hyb.mbl.aic.service.EgovAiRagDocumentStore;
import io.swagger.v3.oas.annotations.Hidden;
import jakarta.annotation.Resource;

/**
 * RAG 문서 업로드·재인덱싱 관리 화면.
 * Flutter 앱이 아니라 device-api-web 메인에서 진입한다.
 */
@Controller
@Hidden
public class EgovAiChatAdminController {

	@Resource
	private EgovAiRagDocumentStore egovAiRagDocumentStore;

	@Value("${spring.servlet.multipart.max-file-size:100MB}")
	private String maxFileSize;

	@GetMapping("/ai-chat")
	public String aiChatAdminPage(Model model) {
		model.addAttribute("storedPath", egovAiRagDocumentStore.resolvedStorePath());
		model.addAttribute("allowedFileExtensions", egovAiRagDocumentStore.allowedFileExtensions());
		model.addAttribute("maxFileSize", maxFileSize);
		return "ai-chat";
	}
}
