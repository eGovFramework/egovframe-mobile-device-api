package kr.go.egovframework.hyb.plugin;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.PluginResult;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import android.content.Context;
import android.content.IntentSender.SendIntentException;
import android.telephony.TelephonyManager;
import android.util.Log;
import android.app.AlertDialog;
import android.content.DialogInterface;


public class CustomPlugin extends CordovaPlugin  {

	private final String ACTION_ECHO = "echo";
    private final String ACTION_GET_MESSAGE = "getMessage";
    private final String ACTION_RUN_JAVASCRIPT_FUNCTION = "runJavaScriptFunction";

    @Override
    public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {
        if (action.equals(ACTION_ECHO)) {
            String message = args.getString(0);
            this.echo(message, callbackContext);
            return true;
        } else if (action.equals(ACTION_GET_MESSAGE)){
            this.getMessage(callbackContext);
        } else if (action.equals(ACTION_RUN_JAVASCRIPT_FUNCTION)){
            String functionName;
            if (args.length() == 0)
            	functionName = "args없음";
            else
            	functionName = args.getString(0);
            this.runJavaScriptFunction(functionName, callbackContext);
        }
        return false;
    }

    private void echo(String message, CallbackContext callbackContext) {
        if (message != null && message.length() > 0) {

            AlertDialog.Builder builder = new AlertDialog.Builder(this.cordova.getActivity());
            builder.setMessage(message).setPositiveButton("확인", new DialogInterface.OnClickListener() {
                @Override
                public void onClick(DialogInterface dialogInterface, int i) {

                }
            });

            AlertDialog dialog = builder.create();
            dialog.show();

            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK, message));
            callbackContext.success(message);
        } else {
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.ERROR, "Expected one non-empty string argument."));
            callbackContext.error("Expected one non-empty string argument.");
        }
    }

    private void getMessage(CallbackContext callbackContext) throws JSONException {
        JSONObject jsonObject = new JSONObject();
        jsonObject.put("name", "Android native에서 생성된 메세지");

        callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK, jsonObject));
    }

    private void runJavaScriptFunction(String functionName, final CallbackContext callbackContext) throws JSONException {
        JSONObject jsonObject = new JSONObject();
        jsonObject.put("name", "Android native에서 JavaScript 함수 호출, args="+functionName);

        final String javascriptString = "print_message(" + jsonObject.toString() + ")";

        Log.d(this.getClass().getSimpleName(), "=>>> print_message : " + javascriptString);
        
        this.webView.sendJavascript(javascriptString);

        callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK));

    }
	
	/*
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
    }*/

}
