package egovframework.hyb.mbl.stm.service;

import java.io.Serializable;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Getter;
import lombok.Setter;

@Schema(description = "StreamingMedia API VO")
@Getter
@Setter
public class StreamingMediaAPIVO implements Serializable {

    private static final long serialVersionUID = 1L;

    private int sn;
    private String uuid;
    private String mediaType;
    private String filePath;
    private String duration;
    private String useYn;
    private String timestamp;

}
