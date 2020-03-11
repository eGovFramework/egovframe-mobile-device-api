package egovframework.hyb.mbl.fop.service;

import org.apache.commons.lang3.builder.ToStringBuilder;

/**  
 * @Class Name : FileOpenerDeviceAPIVO.java
 * @Description : FileOpenerDeviceAPIVO Class
 * @Modification Information  
 * @
 * @  수정일       수정자                 수정내용
 * @ ---------   ---------   -------------------------------
 * @ 2016.07.14  장성호                 최초생성
 * 
 * @author 디바이스 API 실행환경 개발팀
 * @since 2016. 07. 14
 * @version 1.0
 * @see
 * 
 *  Copyright (C) by MOPAS All right reserved.
 */
public class FileOpenerDeviceAPIVO extends FileOpenerDeviceAPIDefaultVO {
    
    
	private static final long serialVersionUID = 5257330538525734667L;
	
	private String sn = "";
    private String streFileNm = "";
    private String orignlFileNm = "";
    private String updDt = "";
    private String fileSize = "";
  	
	public String getSn() {
		return sn;
	}

	public void setSn(String sn) {
		this.sn = sn;
	}

	public String getStreFileNm() {
		return streFileNm;
	}

	public void setStreFileNm(String streFileNm) {
		this.streFileNm = streFileNm;
	}

	public String getOrignlFileNm() {
		return orignlFileNm;
	}

	public void setOrignlFileNm(String orignlFileNm) {
		this.orignlFileNm = orignlFileNm;
	}

	public String getUpdDt() {
		return updDt;
	}

	public void setUpdDt(String updDt) {
		this.updDt = updDt;
	}

	public String getFileSize() {
		return fileSize;
	}

	public void setFileSize(String fileSize) {
		this.fileSize = fileSize;
	}

	/** String 타입의 값을 반환한다. */
    public String toString() {
        return ToStringBuilder.reflectionToString(this);
    }

    
}
