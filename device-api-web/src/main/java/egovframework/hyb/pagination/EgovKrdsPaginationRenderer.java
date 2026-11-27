package egovframework.hyb.pagination;

import org.egovframe.rte.ptl.mvc.tags.ui.pagination.AbstractKrdsPaginationRenderer;
import org.springframework.stereotype.Component;

import jakarta.annotation.PostConstruct;

/**
 * EgovBoard KRDS 페이징 렌더러 참조 구현.
 */
@Component
public class EgovKrdsPaginationRenderer extends AbstractKrdsPaginationRenderer {

	@PostConstruct
	public void initVariables() {
		previousPageLabel = "<a onclick=\"{0}({1}); return false;\" class=\"page-navi prev\" href=\"#\" data-page=\"{1}\" data-nav=\"prev\">이전</a>";
		previousPageDisabledLabel = "<span class=\"page-navi prev disabled\" aria-disabled=\"true\">이전</span>";
		firstPageLabel = "<a onclick=\"{0}({1}); return false;\" class=\"page-link\" href=\"#\" data-page=\"{1}\">{2}</a>";
		currentPageLabel = "<a class=\"page-link active\" href=\"#\" data-page=\"{0}\" aria-current=\"page\" onclick=\"return false;\">{0}</a>";
		otherPageLabel = "<a onclick=\"{0}({1}); return false;\" class=\"page-link\" href=\"#\" data-page=\"{1}\">{2}</a>";
		nextPageLabel = "<a onclick=\"{0}({1}); return false;\" class=\"page-navi next\" href=\"#\" data-page=\"{1}\" data-nav=\"next\">다음</a>";
		nextPageDisabledLabel = "<span class=\"page-navi next disabled\" aria-disabled=\"true\">다음</span>";
		lastPageLabel = "<a onclick=\"{0}({1}); return false;\" class=\"page-link\" href=\"#\" data-page=\"{1}\">{2}</a>";
		dotPageLabel = "<span class=\"page-link link-dot\" aria-hidden=\"true\"></span>";
	}
}