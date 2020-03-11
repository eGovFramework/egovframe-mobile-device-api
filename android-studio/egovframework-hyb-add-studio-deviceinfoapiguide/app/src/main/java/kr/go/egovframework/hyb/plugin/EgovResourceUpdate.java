package kr.go.egovframework.hyb.plugin;

import java.io.BufferedInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.URL;
import java.net.URLConnection;
import java.text.SimpleDateFormat;
import java.util.Date;

import kr.go.egovframework.hyb.deviceinfoapp.R;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.PluginResult;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import android.annotation.SuppressLint;
import android.app.ProgressDialog;
import android.content.Context;
import android.content.SharedPreferences;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager.NameNotFoundException;
import android.os.AsyncTask;
import android.util.Log;

/**  
 * @Class Name : EgovResourceUpdate
 * @Description : EgovResourceUpdate Class
 * @Modification Information  
 * @
 * @  수정일       수정자                  수정내용
 * @ ---------   ---------   -------------------------------
 * @ 2016.06.27    신용호                  최초 작성
 * 
 * @author 디바이스 API 실행환경 개발팀
 * @since 2016. 06. 27
 * @version 1.0
 * @see
 * 
 *  Copyright (C) by MOI All right reserved.
 */

@SuppressLint("NewApi")
public class EgovResourceUpdate extends CordovaPlugin  {

	private final String ACTION_GET_APP_ID = "getAppId";
    private final String ACTION_UPDATE = "update";
    private final String ACTION_GET_APP_VERSION = "getAppVersion";
    private final String ACTION_GET_RESOURCE_VERSION = "getResourceVersion";
    
	private CallbackContext mCallbackContext;
	
    public boolean execute(String action, JSONArray data, CallbackContext callbackContext) {

    	Log.d(this.getClass().getSimpleName(),">>>>> action = "+ action);
    	if (action.equals(ACTION_GET_APP_ID)) {
    		
    		actionGetAppId(callbackContext);

    	} else if (action.equals(ACTION_GET_APP_VERSION)) {
        	
        	actionGetAppVersion(callbackContext);

    	} else if (action.equals(ACTION_GET_RESOURCE_VERSION)) {
        	
    		Context context = (Context) cordova.getActivity();
    		SharedPreferences settings = context.getSharedPreferences("plist", 0);
    		String resVersion = settings.getString("resVersion","");
    		String resDistDt = settings.getString("resDistDt","");
    		String resInstallDt = settings.getString("resInstallDt","");
    		
    		
    		JSONObject jsonObject = new JSONObject();
    		try {
    			
    			//리소스 버전이 resVersion = null인 경우, appVersion으로 초기화
        		if(resVersion.equals(null) || resVersion.equals("")){
        			PackageInfo i = context.getPackageManager().getPackageInfo(context.getPackageName(), 0);
        			resVersion = i.versionName;
        			Log.d(this.getClass().getSimpleName(),">>>>> resVersion 초기화 : "+ resVersion);
        		}
        		
        		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        		
        		//리소스 배포 날짜 resDistDt = null인 경우, 앱설치 날짜로 초기화
        		/*if(resDistDt.equals(null) || resDistDt.equals("")){        			        			
        			resDistDt = sdf.format(new Date(context.getPackageManager().getPackageInfo(context.getPackageName(), 0).firstInstallTime));
        			Log.d(this.getClass().getSimpleName(),">>>>> resDistDt 초기화 : "+ resDistDt);
        		}*/
        		//리소스 버전 설치 날짜 resInstallDt = null인 경우, , 앱설치 날짜로 초기화
        		if(resInstallDt.equals(null) || resInstallDt.equals("")){        			
        			resInstallDt = sdf.format(new Date(context.getPackageManager().getPackageInfo(context.getPackageName(), 0).firstInstallTime));
        			Log.d(this.getClass().getSimpleName(),">>>>> resInstallDt 초기화 : "+ resInstallDt);
        		}
        		
    			jsonObject.put("resVersion", resVersion);
    			jsonObject.put("resDistDt", resDistDt);
    			jsonObject.put("resInstallDt", resInstallDt);
    			
    		} catch (JSONException e1) {
    			// TODO Auto-generated catch block
    			e1.printStackTrace();
    		} catch (NameNotFoundException e) {}
    		
    		callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK, jsonObject));
        	
    	} else if (action.equals(ACTION_UPDATE)) {

    		actionUpdate(data, callbackContext);
    	}
    	
 
        return true;

    }

	private void actionGetAppVersion(CallbackContext callbackContext) {
		Context context = (Context) cordova.getActivity();
		String versionName = "";
		String versionCode = "";
		try {
			PackageInfo i = context.getPackageManager().getPackageInfo(context.getPackageName(), 0);
			versionName = i.versionName;
			versionCode = ""+i.versionCode;
		} catch(NameNotFoundException e) { }

		JSONObject jsonObject = new JSONObject();
		try {
			jsonObject.put("appVersion", versionName);
			jsonObject.put("appVersionCode", versionCode);
		} catch (JSONException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}
		callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK, jsonObject));
	}

	private void actionGetAppId(CallbackContext callbackContext) {
		Context context = (Context) cordova.getActivity();
		String appId = context.getPackageName();
		Log.d(this.getClass().getSimpleName(),">>>getPackageName = "+appId);
		
		JSONObject jsonObject = new JSONObject();
		try {
			jsonObject.put("appId", appId);
		} catch (JSONException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}
		callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK, jsonObject));
	}

	private void actionUpdate(JSONArray data, CallbackContext callbackContext) {
		mCallbackContext = callbackContext;
        Context context = (Context) cordova.getActivity();

    	JSONObject params = null;
    	String url = "";
        String streFileNm = "";
        String orignlFileNm = "";
        String targetPath = "";
        String resLastestVersion = "";
        String resVersionUpdDt = "";
        
    	try {
			params = data.getJSONObject(1);
			url = data.getString(0);

	        streFileNm = params.getString("streFileNm");
	        orignlFileNm = params.getString("orignlFileNm");
	        targetPath = params.getString("targetPath");
	        resLastestVersion = params.getString("resLastestVersion");
	        resVersionUpdDt = params.getString("resVersionUpdDt");

		} catch (JSONException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();

	        // Cordova 콜백 처리
			requestCallBackContext(callbackContext, 1, "");
		}
    	
        Log.d(this.getClass().getSimpleName(),"url : "+ url);
        
        Log.d(this.getClass().getSimpleName(),"streFileNm : "+ streFileNm);
        Log.d(this.getClass().getSimpleName(),"orignlFileNm : "+ orignlFileNm);
        Log.d(this.getClass().getSimpleName(),"targetPath : "+ targetPath);
        Log.d(this.getClass().getSimpleName(),"resLastestVersion : "+ resLastestVersion);
        Log.d(this.getClass().getSimpleName(),"resVersionUpdDt : "+ resVersionUpdDt);

        
        if (targetPath==null || targetPath.equals("null")) {
        	targetPath = context.getFilesDir().toString()+"/www";
        }
    	String downloadLocalPath = context.getCacheDir().toString()+"/"+orignlFileNm;
        Log.d(this.getClass().getSimpleName(),"targetPath2 : "+ targetPath);
        Log.d(this.getClass().getSimpleName(),"downloadLocalPath : "+ downloadLocalPath);

        
    	Log.d(this.getClass().getSimpleName()," >>>>> INIT EgovResourceUpdate");
        String SERVER_URL = context.getString(R.string.SERVER_URL);

    	//new InterfaceCommTask().execute(action,url,data,callbackContext);
	    //String url2 = "http://192.168.100.120:8080/Template-DeviceAPI-Total_Web/upd/ResourceUpdatefileDownload.do?orignlFileNm=UPDATE_IMAGE_20160626.zip&streFileNm=FILE_201606301111.zip";
	    String downloadAssetFileUrl = SERVER_URL+url;
        
        new UpdateZipAssetFileAsync(context).execute(downloadAssetFileUrl, downloadLocalPath, targetPath, resLastestVersion, resVersionUpdDt);
	}
    
    public class UpdateZipAssetFileAsync extends AsyncTask<String, String, String> {

    	private ProgressDialog mDlg;
    	private Context mContext;
    	private String mDownloadLocalPath;
    	private String mResVersion;
    	private String mResVersionUpdDt;
    	private String mResInstallDt;
    	
    	
    	public UpdateZipAssetFileAsync(Context context) {
    		mContext = context;
    	}

    	@Override
    	protected void onPreExecute() {
    		mDlg = new ProgressDialog(mContext);
    		mDlg.setProgressStyle(ProgressDialog.STYLE_HORIZONTAL);
    		mDlg.setMessage("리소스 파일을 다운로드 중입니다.");
    		mDlg.show();
    		mDlg.setMax(100);

    		super.onPreExecute();
    	}

    	@Override
    	protected String doInBackground(String... params) {

    		int count = 0;
    		
    		try {
    			Thread.sleep(100);
    			URL url = new URL(params[0].toString());
    			URLConnection connection = url.openConnection();

    			String paramDownloadLocalPath = params[1].toString();
    			String paramTargetPath = params[2].toString();
    			mResVersion = params[3].toString();
    			mResVersionUpdDt = params[4].toString();
    			
    			Log.d(this.getClass().getSimpleName(), ">>> : paramDownloadLocalPath" + paramDownloadLocalPath);
    			Log.d(this.getClass().getSimpleName(), ">>> : paramTargetPath" + paramTargetPath);
    			mDownloadLocalPath = paramDownloadLocalPath;
    			
    			connection.connect();

    			int lenghtOfFile = connection.getContentLength();
    			Log.d("ANDRO_ASYNC", "Lenght of file: " + lenghtOfFile);

    			InputStream input = new BufferedInputStream(url.openStream());
    			OutputStream output = new FileOutputStream(paramDownloadLocalPath);

    			byte data[] = new byte[1024];

    			long total = 0;

    			while ((count = input.read(data)) != -1) {
    				total += count;
    				publishProgress("" + (int) ((total * 100) / lenghtOfFile));
    				output.write(data, 0, count);
    			}

    			output.flush();
    			output.close();
    			input.close();
    			
    			//publishProgress("progress", 1, "Task " + 1 + " number");
    			
    		} catch (InterruptedException e) {
    			e.printStackTrace();
    	        // Cordova 콜백 처리
    			requestCallBackContext(mCallbackContext, 3, e.getMessage());
    		} catch (IOException e) {
    			e.printStackTrace();
    	        // Cordova 콜백 처리
    			requestCallBackContext(mCallbackContext, 3, e.getMessage());
    		}

    		return null;
    	}

    	@Override
    	protected void onProgressUpdate(String... progress) {
    		//Log.d(this.getClass().getSimpleName(), "progress >>> "+progress[0]);
			mDlg.setProgress(Integer.parseInt(progress[0]));
    	}

    	@SuppressWarnings("deprecation")
    	@Override
    	protected void onPostExecute(String unused) {
    		
    		Log.d(this.getClass().getSimpleName(),"Asset file unzip & Update");
    		try {
				EgovZip.unzip(mDownloadLocalPath, mContext.getFilesDir().toString()+"/www", false);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
				Log.d(this.getClass().getSimpleName(),"ERROR : unzip error!");
		        // Cordova 콜백 처리
				requestCallBackContext(mCallbackContext, 9, "");
			}
    		
    		mDlg.dismiss();
                		
    		// resVersion 저장 
    		SharedPreferences settings = mContext.getSharedPreferences("plist", 0);
    		SharedPreferences.Editor editor = settings.edit();    		
    		editor.putString("resVersion", mResVersion);
    		editor.putString("resDistDt", mResVersionUpdDt);
    		mResInstallDt = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date()).toString();
    		editor.putString("resInstallDt", mResInstallDt);
    		editor.commit();
    		
    		
    		// Cordova 콜백 처리
    		requestCallBackContext(mCallbackContext, 0, "");
    		
    		//Toast.makeText(mContext, Integer.toString(result) + " total sum",
    				//Toast.LENGTH_SHORT).show();
    	}
    }
    
    private void requestCallBackContext(CallbackContext callbackContext, int errCode, String addMessage) {
    	
    	String errMessage = "";
    	switch(errCode) {
    	case 0:
    		errMessage = "업데이트가 성공적으로 반영되었습니다.";
    		break;
    	case 1:
    		errMessage = "파라미터에 오류가 있습니다.";
    		break;
    	case 2:
    		errMessage = "서버연결 실패";
    		break;
    	case 3:
    		errMessage = "통신오류 : ";
    		break;
    	case 9:
    		errMessage = "압축풀기 작업중 오류가 발생했습니다.";
    		break;
    	default:
    		errMessage = "기타 예외오류가 발생했습니다.";
    		break;
    	}
    	
		JSONObject jsonObject = new JSONObject();
        try {
			jsonObject.put("resultCode", ""+errCode);
			jsonObject.put("resultMsg", errMessage+addMessage);
			
			Context context = (Context) cordova.getActivity();
			SharedPreferences settings = context.getSharedPreferences("plist", 0);
			jsonObject.put("resVersion", settings.getString("resVersion", ""));
			jsonObject.put("resDistDt", settings.getString("resDistDt", ""));
			jsonObject.put("resInstallDt", settings.getString("resInstallDt", ""));
			
		} catch (JSONException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}
        callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK, jsonObject));
    }
    
}
