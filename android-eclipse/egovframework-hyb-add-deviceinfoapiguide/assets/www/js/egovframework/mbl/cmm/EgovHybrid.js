/************************************************************************
   파일명 : EgovHybrid.js
   설  명 : 모바일 전자정부 하이브리드 앱 실행환경 공통 JavaScript
   수정일       수정자        Version        Function 명
  -------      ----------      ----------     -----------------
  2012.07.17   서형주         1.0              최초 생성
************************************************************************/

/**********************************************************
 * 공통 함수 Setting
 **********************************************************/

/**
 * Back key 를 통해 APP 이 종료될 수 있도록 세팅
 * @returns
 * @type
 */
function backKeyDown(e) {
	console.log('### Back Button Click');
	if ($.mobile.activePage.is('#intro') || $.mobile.activePage.is('#main')) {
		e.preventDefault();
		navigator.app.exitApp();
	} else if ($.mobile.activePage.is('#deviceInfo') || $.mobile.activePage.is('#deviceInfoList') || $.mobile.activePage.is('#deviceInfoDetail')) {
        location.href = 'DeviceInfoAPI.html';
	} else {
		navigator.app.backHistory();
	}
}

/**
 * 스크립트 진행을 잠시 멈추기 위한 function 
 * @returns
 * @type
 */
function sleep(num){
   var now = new Date();
   var stop = now.getTime() + num;
   while(true){
     now = new Date();
     if(now.getTime() > stop)return;
   }
 }

/**
 * APP 동작 시 3G 망 일경우 과금 부과 확인 호출
 * @returns
 * @type
 */
function fn_Confirm3G(index){
	var networkState = navigator.connection.type;
	if(networkState != Connection.WIFI){	
		jConfirm('Wi Fi 망이 아닐경우 추가적인 비용이 발생 할 수 있습니다. \n계속 하시겠습니까?.', '알림', 'c', function(r) {
			if (r == true) {
				location.href=index;
			} else {
				navigator.app.exitApp();	
			}
		});
	}else location.href=index;
}

/** 3G망 체크 여부 */
var isNetworkCheck = false;

/**
 * 네트웍 이용시 wifi 체크
 * @returns wifi 연결 여부
 * @type boolean
*/

function fn_egov_network_check(doCheck){
	var networkState = navigator.connection.type;   
    if (networkState == Connection.UNKNOWN || networkState == Connection.NONE)
    {
        jAlert("네트워크가 연결되어 있지 않습니다.", "알림", "b");
        return false;
    }
    
	if(networkState != Connection.WIFI){
		if(!doCheck) {
			if(isNetworkCheck) {
				return true;
			}
		}
		
		if(confirm('Wi Fi 망이 아닐경우 추가적인 비용이 발생 할 수 있습니다. \n계속 하시겠습니까?')) {		
			isNetworkCheck = true;
			return true;
		} else {		
			isNetworkCheck = false;
			return false;
		}		
	} else {		
		return true;
	}
}
 
 /**********************************************************
  * iScroll setting
  **********************************************************/ 
var myScroll;
function loaded() {
	myScroll = new iScroll('wrapper', {
//iScroll 설정 추가
//		useTransform : true,
		onBeforeScrollStart : function(e) {
			var target = e.target;
			while (target.nodeType != 1)
				target = target.parentNode;

			if (target.tagName != 'SELECT' && target.tagName != 'INPUT'
					&& target.tagName != 'TEXTAREA')
				e.preventDefault();
		}
	});

	document.addEventListener('touchmove', function(e) {
		e.preventDefault();
	}, false);
	// Use this for high compatibility (iDevice + Android) 단일 페이지 일 경우 사용
	document.addEventListener('DOMContentLoaded', function() {
		setTimeout(loaded, 200);
	}, false);
}

/**********************************************************
 * 인터페이스 API setting
 **********************************************************/ 
/** 
 * RestService를 담당할 EgovInterface 객체 생성
 * @type 
*/
var EgovInterface = function() {
};

/**
 * Http GET Method function.
 * @returns GET Method 수행 결과
 * @type
*/
EgovInterface.prototype.get = function(url, accept_type, param, successCallback) {
	if(param == null)
		param = {};
	
	return cordova.exec(    
			successCallback,    						//Success callback from the plugin
			function(e){console.log('DeviceAPIGuide EgovInterface.get request Fail');jAlert(e);},     //Error callback from the plugin
			'EgovInterfacePlugin',  					//Tell PhoneGap to run "EgovInterfacePlugin" Plugin
			'GET',              						//Tell plugin, which action we want to perform
			[url,accept_type,param]);        			//Passing list of args to the plugin
};
 
/**
 * Http POST Method function.
 * @returns POST Method 수행 결과
 * @type
*/
EgovInterface.prototype.post = function(url, accept_type, param, successCallback) {
	if(param == null)
		param = {};
	
    return cordova.exec(    
    		successCallback,    						//Success callback from the plugin
    		function(e){console.log('DeviceAPIGuide EgovInterface.post request Fail');jAlert(e);},     //Error callback from the plugin
    		'EgovInterfacePlugin',  					//Tell PhoneGap to run "EgovInterfacePlugin" Plugin
    		'POST',              						//Tell plugin, which action we want to perform
    		[url,accept_type,param]);        			//Passing list of args to the plugin
};

/**
 * GET URL function.
 * @returns SERVER URL
 * @type
*/
EgovInterface.prototype.geturl = function(successCallback) {	
    return cordova.exec(    successCallback,    		//Success callback from the plugin
    		function(e){console.log('DeviceAPIGuide EgovInterface.geturl Fail');jAlert(e);},     //Error callback from the plugin
	      'EgovInterfacePlugin',  						//Tell PhoneGap to run "DirectoryListingPlugin" Plugin
	      'URL',              							//Tell plugin, which action we want to perform
	      []);        									//Passing list of args to the plugin
};

if(!window.plugins) {
    window.plugins = {};
}
if (!window.plugins.EgovInterface) {
    window.plugins.EgovInterface = new EgovInterface();
}

/*********************************************************
 * Custom Plug-In
 *********************************************************/

/**
 * Storgae 정보 조회 플러그인 자바스크립트
 * @returns
 * @type
 */
var StorageInfo = {
    totalFileSystemSize: function(success, fail, types) {
    	
        return cordova.exec(success, fail, "StorageInfoPlugin", "fileSystemSize", types);
    }
}

/**
 * Device Number 정보 조회 플러그인 자바스크립트
 * @returns
 * @type
 */
var DeviceNumber = {
    getDeviceNumber: function(success, fail, types) {
    	
        return cordova.exec(success, fail, "DeviceNumberPlugin", "deviceNumber", types);
    }
}