package egovframework.hyb.mbl.fms.service;

import java.io.Serializable;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Getter;
import lombok.Setter;

/**
 * Face Mesh API VO (얼굴 1명 = 1행, faceGroupId로 동일 검출 묶음)
 */
@Schema(description = "얼굴 메시 API VO")
@Getter
@Setter
public class FaceMeshAPIVO implements Serializable {

	private static final long serialVersionUID = 1L;

	@Schema(description = "일련번호")
	private int sn;

	@Schema(description = "기기UUID")
	private String uuid;

	@Schema(description = "사용여부")
	private String useYn;

	@Schema(description = "감지시각")
	private String timestamp;

	@Schema(description = "얼굴그룹ID")
	private String faceGroupId;

	@Schema(description = "입력소스 (camera|gallery)")
	private String source;

	@Schema(description = "이미지경로")
	private String imagePath;

	@Schema(description = "이미지너비")
	private String imageWidth;

	@Schema(description = "이미지높이")
	private String imageHeight;

	@Schema(description = "얼굴수")
	private String faceCount;

	@Schema(description = "얼굴순번")
	private String faceIndex;

	@Schema(description = "트래킹ID")
	private String trackingId;

	@Schema(description = "얼굴영역(좌)")
	private String bboxLeft;

	@Schema(description = "얼굴영역(상)")
	private String bboxTop;

	@Schema(description = "얼굴영역(우)")
	private String bboxRight;

	@Schema(description = "얼굴영역(하)")
	private String bboxBottom;

	@Schema(description = "랜드마크수")
	private String landmarkCount;

	@Schema(description = "신뢰도")
	private String meshScore;

	@Schema(description = "홍채포함 (Y/N)")
	private String hasIris;

	@Schema(description = "양안거리(정규화)")
	private String iodNorm;

	@Schema(description = "코끝X")
	private String noseTipX;

	@Schema(description = "코끝Y")
	private String noseTipY;

	@Schema(description = "왼쪽눈X")
	private String leftEyeX;

	@Schema(description = "왼쪽눈Y")
	private String leftEyeY;

	@Schema(description = "오른쪽눈X")
	private String rightEyeX;

	@Schema(description = "오른쪽눈Y")
	private String rightEyeY;

	@Schema(description = "입중앙X")
	private String mouthCenterX;

	@Schema(description = "입중앙Y")
	private String mouthCenterY;

	@Schema(description = "머리끄덕임")
	private String headEulerX;

	@Schema(description = "좌우회전")
	private String headEulerY;

	@Schema(description = "머리기울기")
	private String headEulerZ;

}
