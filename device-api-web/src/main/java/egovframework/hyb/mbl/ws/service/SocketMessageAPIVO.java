package egovframework.hyb.mbl.ws.service;

import java.io.Serializable;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Getter;
import lombok.Setter;

@Schema(description = "SocketIO 메시지 API VO")
@Getter
@Setter
public class SocketMessageAPIVO implements Serializable {

    private static final long serialVersionUID = 1L;

    private int sn;
    private String uuid;
    private String message;
    private String sender;
    private String timestamp;
    private String useYn;

}
