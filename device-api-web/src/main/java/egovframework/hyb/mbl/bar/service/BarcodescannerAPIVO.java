package egovframework.hyb.mbl.bar.service;

import java.io.Serializable;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Getter;
import lombok.Setter;

/**
 * BarcodescannerAPIVO
 *
 * 수정이력
 * 2016.07.26 신성학 최초생성
 * 2020.07.29 신용호 Swagger 적용
 */

@Schema(description = "바코드 스캐너 API VO")
@Getter
@Setter
public class BarcodescannerAPIVO implements Serializable {

	 private static final long serialVersionUID = 1L;
	 
	 /** 일련번호 */
	 @Schema(description = "일련번호")
	 private int sn;
	
	 /** 바코드 타입 */
	 @Schema(description = "바코드 타입")
	 private String codeType;
	 
	 /** 바코드 내용 */
	 @Schema(description = "바코드 내용")
	 private String codeText;
	 
	 /** 사용여부  */
	 @Schema(description = "사용여부")
	 private String useYn;
	 	 
	 /** 저장 일시  */
	 @Schema(description = "저장 일시")
	 private String sndDt;

	 /** 디바이스 UUID */
	 @Schema(description = "디바이스 UUID")
	 private String uuid;
	
	 /** * @return  sn을 반환한다	 */
	/** * @param 파라미터 sn를 변수 sn에 설정한다. */
	 
	 /** * @return  codeType을 반환한다	 */
	 /** * @param 파라미터 codeType를 변수 codeType에 설정한다. */
	 
	 /** * @return  codeText을 반환한다	 */
	 /** * @param 파라미터 codeText를 변수 codeText에 설정한다. */
	 
	 /** * @param sndDt을 반환한다. */
	 /** * @param 파라미터 sndDt를 변수 sndDt에 설정한다. */
		/** * @param useYn을 반환한다. */		
		/** * @param 파라미터 useYn를 변수 useYn에 설정한다. */		
		public void setCodeDt(String codeDt) {
			this.sndDt = codeDt;
		}

		public String getCodeDt() {
			return sndDt;
		}

}
