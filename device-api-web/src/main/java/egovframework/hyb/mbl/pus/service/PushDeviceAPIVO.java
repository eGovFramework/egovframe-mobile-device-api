/*
 * Copyright 2008-2009 the original author or authors.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package egovframework.hyb.mbl.pus.service;

import java.io.Serializable;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotBlank;
import lombok.Getter;
import lombok.Setter;

/**
 * PushDeviceAPIVO
 *
 * 수정이력
 * 2016.06.20 신성학 최초생성
 * 2020.07.29 신용호 Swagger 적용
 */
@Schema(description = "푸시 디바이스 API VO")
@Getter
@Setter
public class PushDeviceAPIVO implements Serializable {

	private static final long serialVersionUID = 1L;

	/** 일련번호 */
    @Schema(description = "일련번호")
    private int sn;
    
    /** 기기식별 */
    @Schema(description = "기기식별코드")
	@NotBlank(message="uuid를 입력하세요")
    private String uuid;
    
	/** 네트워크 디바이스 정보  */
    @Schema(description = "네트워크 디바이스 정보")
    private String ntwrkDeviceInfo;
    
    /** 디바이스 명  */
    @Schema(description = "디바이스 명")
    private String deviceNm;

    /** OS 버전  */
    @Schema(description = "OS 버전")
    private String osVer;
    
    /** 사용여부  */
    @Schema(description = "사용여부")
    private String useYn;
    
    /** OS 구분  */
    @Schema(description = "OS 구분")
    private String osType;
    
    /** 디바이스 토큰 ID  */
    @Schema(description = "디바이스 토큰 ID")
    private String tokenId;
    
    /** Push 발송 메시지  */
    @Schema(description = "Push 발송 메시지")
    private String message;

	/** Push 발송 일시  */
    @Schema(description = "Push 발송 일시")
    private String sndDt;

    /** 같은 발송에 포함된 기기 수 */
    @Schema(description = "같은 발송에 포함된 기기 수")
    private int deviceCount;

	/** 현재페이지 (1부터 시작, 0 이하면 페이징 미적용) */
	@Schema(description = "현재페이지", example = "1")
	private int pageIndex = 0;

	/** 페이지당 레코드 수 */
	@Schema(description = "페이지당 레코드 수", example = "10")
	private int pageUnit = 10;

	/** 페이지 리스트에 표시할 페이지 수 */
	@Schema(description = "페이지 사이즈", example = "10")
	private int pageSize = 10;

	/** 조회 시작 인덱스 (OFFSET) */
	@Schema(hidden = true)
	private int firstIndex = 0;

	/** 조회 종료 인덱스 */
	@Schema(hidden = true)
	private int lastIndex = 0;

	/** LIMIT 건수 (0 이하면 LIMIT 미적용) */
	@Schema(hidden = true)
	private int recordCountPerPage = 0;

}
