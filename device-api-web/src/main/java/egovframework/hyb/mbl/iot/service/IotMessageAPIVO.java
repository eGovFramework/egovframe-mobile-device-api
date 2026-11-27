package egovframework.hyb.mbl.iot.service;

import java.io.Serializable;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Getter;
import lombok.Setter;

@Schema(description = "IoT MQTT 메시지 API VO")
@Getter
@Setter
public class IotMessageAPIVO implements Serializable {

    private static final long serialVersionUID = 1L;

    private int sn;
    private String uuid;
    private String topic;
    private String payload;
    private String direction;
    private String messageType;
    private String timestamp;
    private String useYn;

}
