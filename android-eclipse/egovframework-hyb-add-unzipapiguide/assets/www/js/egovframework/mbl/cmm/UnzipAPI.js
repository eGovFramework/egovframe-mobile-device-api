/************************************************************************
   파일명 : UnZipAPI.js
   설  명 : 모바일 전자정부 하이브리드 앱 실행환경 공통 JavaScript
   수정일       수정자        Version        Function 명
  -------      ----------      ----------     -----------------
  2016.07.27   장성호         1.0              최초 생성

************************************************************************/


/**********************************************************
 * Unzip API setting
 **********************************************************/ 

var EgovZip = function() {
};

/**
 * Http GET Method function.
 * @returns GET Method 수행 결과
 * @type
*/
EgovZip.prototype.zip = function(sourcePath, targetDir, successCallback, failCallback) {
	
    var types = [sourcePath, targetDir];
	
	return cordova.exec(    
			successCallback,    						//Success callback from the plugin
			failCallback,     //Error callback from the plugin
			'EgovZip',  					//Tell PhoneGap to run "EgovInterfacePlugin" Plugin
			'zip',              						//Tell plugin, which action we want to perform
			types);        			//Passing list of args to the plugin
};

EgovZip.prototype.unzip = function(sourcePath, targetDir, successCallback, failCallback) {
	
	var types = [sourcePath, targetDir];
	
	return cordova.exec(    
			successCallback,    						//Success callback from the plugin
			failCallback,     //Error callback from the plugin
			'EgovZip',  					//Tell PhoneGap to run "EgovInterfacePlugin" Plugin
			'unzip',              						//Tell plugin, which action we want to perform
			types);        			//Passing list of args to the plugin
};



if(!window.plugins) {
    window.plugins = {};
}
if (!window.plugins.EgovZip) {
    window.plugins.EgovZip = new EgovZip();
}

