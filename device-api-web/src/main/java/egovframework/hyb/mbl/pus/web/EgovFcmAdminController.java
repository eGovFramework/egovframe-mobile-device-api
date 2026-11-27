package egovframework.hyb.mbl.pus.web;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

import io.swagger.v3.oas.annotations.Hidden;

/**
 * FCM 푸시 발송 관리 웹 화면
 */
@Controller
@Hidden
public class EgovFcmAdminController {

    @GetMapping("/fcm")
    public String fcmAdminPage() {
        return "fcm";
    }
}
