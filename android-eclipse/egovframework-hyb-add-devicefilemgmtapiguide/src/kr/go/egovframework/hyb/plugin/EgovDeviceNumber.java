package kr.go.egovframework.hyb.plugin;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaPlugin;
import org.json.JSONArray;

import android.content.Context;
import android.telephony.TelephonyManager;

/**
 * @Class Name : EgovDeviceNumber.java
 * @Description : EgovDeviceNumber.java Class
 * @Modification Information  
 * @
 * @  수정일       수정자                 수정내용
 * @ ---------   ---------   -------------------------------
 * @ 2012.08.22   서형주                 최초생성
 *
 *  Copyright (C) by MOPAS All right reserved.
 */

public class EgovDeviceNumber extends CordovaPlugin  {

    public boolean execute(String action, JSONArray args, CallbackContext callbackContext) {
        if ("deviceNumber".equals(action)) {

            TelephonyManager telManager = (TelephonyManager) ((Context) cordova.getActivity())
                    .getSystemService(Context.TELEPHONY_SERVICE);
            String result = telManager.getLine1Number();

            if (result != null && result.length() > 0) {
            	callbackContext.success(result);
                return true;
            } else {
            	callbackContext.error("Expected one non-empty string argument.");
                return true;
            }
        } else {
            return false;
        }
    }

}
