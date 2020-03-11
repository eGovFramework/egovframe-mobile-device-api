/************************************************************************
   파일명 : EgovResourceUpdateAPI.js
   설  명 : 모바일 전자정부 하이브리드 앱 실행환경 공통 JavaScript
   수정일       수정자        Version        Function 명
  -------      ----------      ----------     -----------------
  2016.06.27   신용호         1.0              최초 생성

************************************************************************/


/**********************************************************
 * ResourceUpdate API setting
 **********************************************************/ 
/** 
 * RestService를 담당할 EgovInterface 객체 생성
 * @type 
*/
var EgovResourceUpdate = function() {
};

/**
 * Http GET Method function.
 * @returns GET Method 수행 결과
 * @type
*/
EgovResourceUpdate.prototype.update = function(url, params, successCallback, failCallback) {
	
	if(params == null)
		params = {};
    url = url+"?orignlFileNm="+params["orignlFileNm"]+"&streFileNm="+params["streFileNm"];
    var types = [url, params];
	
	return cordova.exec(    
			successCallback,    						//Success callback from the plugin
			failCallback,     //Error callback from the plugin
			'EgovResourceUpdate',  					//Tell PhoneGap to run "EgovInterfacePlugin" Plugin
			'update',              						//Tell plugin, which action we want to perform
			types);        			//Passing list of args to the plugin
};

EgovResourceUpdate.prototype.getAppId = function(successCallback, failCallback) {
	
	var types = [];
	return cordova.exec(    
			successCallback,    						//Success callback from the plugin
			failCallback,     //Error callback from the plugin
			'EgovResourceUpdate',  					//Tell PhoneGap to run "EgovInterfacePlugin" Plugin
			'getAppId',              						//Tell plugin, which action we want to perform
			types);        			//Passing list of args to the plugin
};

EgovResourceUpdate.prototype.getAppVersion = function(successCallback, failCallback) {
	
	var types = [];
	return cordova.exec(    
			successCallback,    						//Success callback from the plugin
			failCallback,     //Error callback from the plugin
			'EgovResourceUpdate',  					//Tell PhoneGap to run "EgovInterfacePlugin" Plugin
			'getAppVersion',              						//Tell plugin, which action we want to perform
			types);        			//Passing list of args to the plugin
};

EgovResourceUpdate.prototype.getResourceVersion = function(successCallback, failCallback) {
	
	var types = [];
	return cordova.exec(    
			successCallback,    						//Success callback from the plugin
			failCallback,     //Error callback from the plugin
			'EgovResourceUpdate',  					//Tell PhoneGap to run "EgovInterfacePlugin" Plugin
			'getResourceVersion',              						//Tell plugin, which action we want to perform
			types);        			//Passing list of args to the plugin
};

if(!window.plugins) {
    window.plugins = {};
}
if (!window.plugins.EgovResourceUpdate) {
    window.plugins.EgovResourceUpdate = new EgovResourceUpdate();
}

