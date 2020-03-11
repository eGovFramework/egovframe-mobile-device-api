package kr.go.egovframework.hyb.plugin;

import java.net.URLEncoder;
import java.nio.charset.Charset;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Iterator;
import java.util.List;

import kr.go.egovframework.hyb.deviceinfoapp.R;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaPlugin;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.http.converter.StringHttpMessageConverter;
import org.springframework.web.client.RestClientException;
import org.springframework.web.client.RestTemplate;

import android.content.Context;
import android.os.AsyncTask;
import android.util.Log;


/**  
 * @Class Name : EgovInterfacePlugin
 * @Description : EgovInterfacePlugin Class
 * @Modification Information  
 * @
 * @  수정일       수정자                  수정내용
 * @ ---------   ---------   -------------------------------
 * @ 2012.07.02    나신일                  최초 작성
 * 
 * @author 디바이스 API 실행환경 개발팀
 * @since 2012. 07. 02
 * @version 1.0
 * @see
 * 
 *  Copyright (C) by MOPAS All right reserved.
 */
public class EgovInterfacePlugin extends CordovaPlugin  {

    public static final String HTTP_METHOD_GET = "GET";
    public static final String HTTP_METHOD_POST = "POST";
    public static final String GET_SERVER_URL = "URL";
    public static final String ERROR_MESSAGE_JSON = "Json Parsing Error";
    public static final String ERROR_MESSAGE_IO = "IO Error";
    public static final String ERROR_MESSAGE_ACTION = "Action Input Error";
    public static final String ERROR_MESSAGE_PARAM = "Parameter Input Error";

    /*
     * (non-Javadoc)
     * 
     * @see org.apache.cordova.api.Plugin#execute(java.lang.String,
     * org.json.JSONArray, java.lang.String)
     */
    
    public boolean execute(String action, JSONArray data, CallbackContext callbackContext) {

        Context context = (Context) cordova.getActivity();

    	Log.d(this.getClass().getSimpleName()," >>>>> INIT");
        String url = context.getString(R.string.SERVER_URL);

    	new InterfaceCommTask().execute(action,url,data,callbackContext);
 
        return true;

    }

    private static String parseParameter(Object obj) {
        StringBuffer sb = new StringBuffer();
        try {
            if (obj != null) {

                JSONObject requestMap = (JSONObject) obj;

                Iterator<?> iterator = requestMap.keys();

                int paramSize = requestMap.length();
                int cnt = 1;
                while (iterator.hasNext()) {
                    String key = (String) iterator.next();

                    sb.append(key);
                    sb.append("=");
                    sb.append(URLEncoder.encode(requestMap.get(key).toString(),
                            "utf-8"));

                    if (paramSize > cnt) {
                        sb.append("&");
                    }
                    cnt++;
                }

            }

        } catch (Exception e) {
            return "";
        }

        return sb.toString();

    }
    
	public class InterfaceCommTask extends AsyncTask<Object, Integer, String> {

		String action;
		String url;
		JSONArray data;
		CallbackContext callbackContext;		
		
		@Override
		protected void onPreExecute() {
		
			super.onPreExecute();
		}	

		@Override
		protected String doInBackground(Object... params) {
			
			action = (String)params[0];
			url = (String)params[1];
			data = (JSONArray)params[2];
			callbackContext = (CallbackContext)params[3];
			
			if (action.equals(HTTP_METHOD_GET)) {
	            try {

	            	String uri = data.getString(0);
	                JSONObject param = data.getJSONObject(2);
	                Log.d(this.getClass().getSimpleName()," $$$$$ : "+uri);
	                Log.d(this.getClass().getSimpleName()," $$$$$ : "+param.toString());
	                Log.d(this.getClass().getSimpleName()," $$$$$ : "+data.getString(1));

	                
	                HttpHeaders requestHeaders = new HttpHeaders();
	                requestHeaders
	                        .setContentType(MediaType.APPLICATION_FORM_URLENCODED);
	                if ("json".equals(data.getString(1))) {
	                    requestHeaders.setAccept(Collections
	                            .singletonList(MediaType.APPLICATION_JSON));
	                } else if ("xml".equals(data.getString(1))) {
	                    requestHeaders.setAccept(Collections
	                            .singletonList(MediaType.APPLICATION_XML));
	                    List<Charset> charset = new ArrayList<Charset>(Charset
	                            .availableCharsets().values());
	                    charset.add(Charset.forName("UTF-8"));
	                    requestHeaders.setAcceptCharset(charset);
	                } else {
	                	callbackContext.error(ERROR_MESSAGE_PARAM);
	                    return null;
	                }
	                HttpEntity<String> requestEntity = new HttpEntity<String>("",
	                        requestHeaders);

	                // Create a new RestTemplate instance
	                RestTemplate restTemplate = new RestTemplate();

	                // Add the String message converter
	                restTemplate.getMessageConverters().add(
	                        new StringHttpMessageConverter());

	                if (url == null) {
	                    url = "";
	                }

	                if (uri == null) {
	                    uri = "";
	                }
	                
	                // Make the HTTP GET request, marshaling the response to a
	                // String
	                ResponseEntity<String> responseEntity = restTemplate.exchange(
	                        url + uri + "?" + parseParameter(param),
	                        HttpMethod.GET, requestEntity, String.class);

	                String result = responseEntity.getBody();
	                Log.d(this.getClass().getSimpleName(),">>> result = "+result);

	                callbackContext.success(result);
	            } catch (RestClientException e) {   
	            	callbackContext.error(e.getLocalizedMessage());
	            } catch (JSONException e) {            	
	            	callbackContext.error(ERROR_MESSAGE_JSON);
	            } catch (Exception e) {
	            	callbackContext.error(ERROR_MESSAGE_IO);
	            }

	        } else if (action.equals(HTTP_METHOD_POST)) {
	            try {

	                String uri = data.getString(0);
	                JSONObject param = data.getJSONObject(2);
	            	
	                HttpHeaders requestHeaders = new HttpHeaders();
	                requestHeaders
	                        .setContentType(MediaType.APPLICATION_FORM_URLENCODED);
	                if ("json".equals(data.getString(1))) {
	                    requestHeaders.setAccept(Collections
	                            .singletonList(MediaType.APPLICATION_JSON));
	                } else if ("xml".equals(data.getString(1))) {
	                    requestHeaders.setAccept(Collections
	                            .singletonList(MediaType.APPLICATION_XML));
	                    List<Charset> charset = new ArrayList<Charset>(Charset
	                            .availableCharsets().values());
	                    charset.add(Charset.forName("UTF-8"));
	                    requestHeaders.setAcceptCharset(charset);
	                } else {
	                	callbackContext.error(ERROR_MESSAGE_PARAM);
	                    return null;
	                }

	                HttpEntity<String> requestEntity = new HttpEntity<String>(
	                        parseParameter(param), requestHeaders);

	                // Create a new RestTemplate instance
	                RestTemplate restTemplate = new RestTemplate();

	                // Add the String message converter
	                restTemplate.getMessageConverters().add(
	                        new StringHttpMessageConverter());

	                // Make the HTTP POST request, marshaling the response to a
	                // String
	                ResponseEntity<String> responseEntity = restTemplate
	                        .exchange(url + uri, HttpMethod.POST, requestEntity,
	                                String.class);

	                String result = responseEntity.getBody();
	                
	                callbackContext.success(result);
	                
	            } catch (RestClientException e) {            	
	            	callbackContext.error(e.getLocalizedMessage());
	            } catch (JSONException e) {            	
	            	callbackContext.error(ERROR_MESSAGE_JSON);
	            } catch (Exception e) {
	            	callbackContext.error(ERROR_MESSAGE_IO);
	            }
	        } else if (action.equals(GET_SERVER_URL)) {
	            try {
	                
	                callbackContext.success(url);

	            } catch (Exception e) {
	            	callbackContext.error(ERROR_MESSAGE_IO);
	            }
	        } else {
	        	callbackContext.error(ERROR_MESSAGE_ACTION);
	        }
			
			return null;
		}
		
		protected void onProgressUpdate(Integer... progress) {
			Log.d(this.getClass().getSimpleName(),"onProgressUpdate:["+progress[0]+"]");
		}

		@Override
		protected void onPostExecute(String result) {
			
			super.onPostExecute(result);
		}

		@Override
		protected void onCancelled() {
			// TODO Auto-generated method stub
			super.onCancelled();
		}  

		
	}

}
