package egovframework.hyb.mbl.fop.service;

import java.io.Serializable;

import org.apache.commons.lang3.builder.ToStringBuilder;

/**  
 * @Class Name : VibratorAPIDefaultVO.java
 * @Description : VibratorAPIDefaultVO Class
 * @Modification Information  
 * @
 * @  수정일       수정자                 수정내용
 * @ ---------   ---------   -------------------------------
 * @ 2016.07.14   장성                최초생성
 * 
 * @author 디바이스 API 실행환경 개발팀
 * @since 2016. 07. 18
 * @version 1.0
 * @see
 * 
 *  Copyright (C) by MOPAS All right reserved.
 */
public class FileOpenerDeviceAPIDefaultVO implements Serializable {

	private static final long serialVersionUID = 5092636432930504508L;

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
    
    public String getAppId() {
		return appId;
	}
	public void setAppId(String appId) {
		this.appId = appId;
	}
	public String getOsType() {
		return osType;
	}
	public void setOsType(String osType) {
		this.osType = osType;
	}
	/** 앱의 고유 ID , iOS=bundle identifier, Android=packeage name */
    private String appId = "";

    /** OS 구분  */
    private String osType;

    /** 첫번째 페이지를반환 한다. */    
	public int getFirstIndex() {
		return firstIndex;
	}
	/** 첫번째 페이지를 설정한다. */
	public void setFirstIndex(int firstIndex) {
		this.firstIndex = firstIndex;
	}
	/** 마지막 페이지를 반환한다. */
	public int getLastIndex() {
		return lastIndex;
	}
	/** 마지막 페이지를 설정한다. */
	public void setLastIndex(int lastIndex) {
		this.lastIndex = lastIndex;
	}
	/** 페이지의 게시물 건수를 반환한다. */
	public int getRecordCountPerPage() {
		return recordCountPerPage;
	}
	/** 페이지의 게시물 건수를 설정한다. */
	public void setRecordCountPerPage(int recordCountPerPage) {
		this.recordCountPerPage = recordCountPerPage;
	}
	/** 검색조건을 반환한다. */
	public String getSearchCondition() {
        return searchCondition;
    }
	/** 검색조건 을 설정한다.*/
    public void setSearchCondition(String searchCondition) {
        this.searchCondition = searchCondition;
    }
    /** 검색어를 반환한다. */
    public String getSearchKeyword() {
        return searchKeyword;
    }
    /** 검색어를 설정한다. */
    public void setSearchKeyword(String searchKeyword) {
        this.searchKeyword = searchKeyword;
    }
    /** 검색 사용여부를 반환한다. */
    public String getSearchUseYn() {
        return searchUseYn;
    }
    /** 검색 사용여부를 설정한다. */
    public void setSearchUseYn(String searchUseYn) {
        this.searchUseYn = searchUseYn;
    }
    /** 현재 페이지를 반환한다. */
    public int getPageIndex() {
        return pageIndex;
    }
    /** 현재 페이지를 설정한다. */
    public void setPageIndex(int pageIndex) {
        this.pageIndex = pageIndex;
    }
    /** 페이지 유닛을 반환한다. */
    public int getPageUnit() {
        return pageUnit;
    }
    /** 페이지 유닛을 설정한다. */
    public void setPageUnit(int pageUnit) {
        this.pageUnit = pageUnit;
    }
    /** 페이지 사이즈를 반환한다.*/
    public int getPageSize() {
        return pageSize;
    }
    /** 페이지 사이즈를 설정한다. */
    public void setPageSize(int pageSize) {
        this.pageSize = pageSize;
    }
    /** String 타입의 값을 반환한다. */
    public String toString() {
        return ToStringBuilder.reflectionToString(this);
    }
    
}
