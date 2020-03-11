package egovframework.hyb.add.ctt.service;

import java.io.Serializable;

import org.apache.commons.lang3.builder.ToStringBuilder;

/**  
 * @Class Name : ContactsAndroidAPIDefalutVO.java
 * @Description : ContactsAndroidAPIDefalutVO Class
 * @Modification Information  
 * @
 * @  수정일                 수정자                 수정내용
 * @ ---------   ---------   -------------------------------
 * @ 2012.08.13    나신일                  최초생성
 * 
 * @author Device API 실행환경팀
 * @since 2012. 08. 13
 * @version 1.0
 * @see
 * 
 */
public class ContactsAndroidAPIDefalutVO implements Serializable {

	private static final long serialVersionUID = -4658455706248212075L;

	/** 검색조건 */
    private String searchCondition = "";

    /** 검색Keyword */
    private String searchKeyword = "";

    /** 검색사용여부 */
    private String searchUseYn = "";

    /** 현재페이지 */
    private int pageIndex = 1;

    /** 페이지갯수 */
    private int pageUnit = 10;

    /** 페이지사이즈 */
    private int pageSize = 10;

    /** firstIndex */
    private int firstIndex = 0;

    /** lastIndex */
    private int lastIndex = 1;

    /** recordCountPerPage */
    private int recordCountPerPage = 10;

    /** 첫번째 페이지를반환 한다. */
    public int getFirstIndex() {
        return firstIndex;
    }

    /** 첫번째 페이지를 설정한다. */
    public void setFirstIndex(final int firstIndex) {
        this.firstIndex = firstIndex;
    }

    /** 마지막 페이지를 반환한다. */
    public int getLastIndex() {
        return lastIndex;
    }

    /** 마지막 페이지를 설정한다. */
    public void setLastIndex(final int lastIndex) {
        this.lastIndex = lastIndex;
    }

    /** 페이지의 게시물 건수를 반환한다. */
    public int getRecordCountPerPage() {
        return recordCountPerPage;
    }

    /** 페이지의 게시물 건수를 설정한다. */
    public void setRecordCountPerPage(final int recordCountPerPage) {
        this.recordCountPerPage = recordCountPerPage;
    }

    /** 검색조건을 반환한다. */
    public String getSearchCondition() {
        return searchCondition;
    }

    /** 검색조건 을 설정한다. */
    public void setSearchCondition(final String searchCondition) {
        this.searchCondition = searchCondition;
    }

    /** 검색어를 반환한다. */
    public String getSearchKeyword() {
        return searchKeyword;
    }

    /** 검색어를 설정한다. */
    public void setSearchKeyword(final String searchKeyword) {
        this.searchKeyword = searchKeyword;
    }

    /** 검색 사용여부를 반환한다. */
    public String getSearchUseYn() {
        return searchUseYn;
    }

    /** 검색 사용여부를 설정한다. */
    public void setSearchUseYn(final String searchUseYn) {
        this.searchUseYn = searchUseYn;
    }

    /** 현재 페이지를 반환한다. */
    public int getPageIndex() {
        return pageIndex;
    }

    /** 현재 페이지를 설정한다. */
    public void setPageIndex(final int pageIndex) {
        this.pageIndex = pageIndex;
    }

    /** 페이지 유닛을 반환한다. */
    public int getPageUnit() {
        return pageUnit;
    }

    /** 페이지 유닛을 설정한다. */
    public void setPageUnit(final int pageUnit) {
        this.pageUnit = pageUnit;
    }

    /** 페이지 사이즈를 반환한다. */
    public int getPageSize() {
        return pageSize;
    }

    /** 페이지 사이즈를 설정한다. */
    public void setPageSize(final int pageSize) {
        this.pageSize = pageSize;
    }

    /** String 타입의 값을 반환한다. */
    public String toString() {
        return ToStringBuilder.reflectionToString(this);
    }
}
