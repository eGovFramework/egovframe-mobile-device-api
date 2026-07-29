package egovframework.hyb.mbl.fop.service;

import java.io.Serializable;

import org.apache.commons.lang3.builder.ToStringBuilder;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Getter;
import lombok.Setter;

/**  
 * @Class Name : FileOpenerDeviceAPIVO.java
 * @Description : FileOpenerDeviceAPIVO Class
 * @Modification Information  
 * @
 * @ 수정일               수정자              수정내용
 * @ ----------   ---------   -------------------------------
 *   2016.07.14   장성호             최초생성
 *   2020.07.29   신용호             Swagger 적용
 * 
 * @author 디바이스 API 실행환경 개발팀
 * @since 2016. 07. 14
 * @version 1.0
 * @see
 * 
 *  Copyright (C) by MOPAS All right reserved.
 */
@Getter
@Setter
@Schema(description = "파일 오프너 디바이스 API VO")
public class FileOpenerDeviceAPIVO implements Serializable {

	private static final long serialVersionUID = 5257330538525734667L;
	
	@Schema(description = "일련번호")
	private String sn = "";

	@Schema(description = "기기 식별코드")
	private String uuid = "";
	
	@Schema(description = "저장파일명")
    private String streFileNm = "";
	
	@Schema(description = "원파일명")
    private String orignlFileNm = "";
	
	@Schema(description = "업데이트날짜")
    private String updDt = "";
	
	@Schema(description = "파일크기")
    private String fileSize = "";
	
	@Schema(description = "파일번호")
    private int fileSn = 0;

	/** String 타입의 값을 반환한다. */
    public String toString() {
        return ToStringBuilder.reflectionToString(this);
    }

}
