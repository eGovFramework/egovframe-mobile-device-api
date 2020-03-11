/***************************************************************************
 파일명 : InterfaceAPI.js
 설  명 : 모바일 전자정부 하이브리드 앱 실행환경 공통 JavaScript
 수정일         수정자		Version			Function 명
 ----------		------		-------			--------------------------------
 2012.07.04		이한철		1.0				최초 생성
 2012.08.09		서준식		1.0				스토리지 정보 조회 플러그인 추가
 2012.08.10		서준식		1.0				네트워크 상태 조회 함수 추가
 2015.06.13		신용호		1.0				geturl 추가 
 **************************************************************************/



/*********************************************************
 * EgovInterfaceAPI 플러그인
 *********************************************************/

/**
 * Native 함수를 호출하여 외부 서버와 통신하는 function.
 */
var EgovInterface = {
	submitAsynchronous: function(types, success, fail) {
		return cordova.exec(success, fail, "InterfaceAPI", "submitAsynchronous", types);
	},

	geturl: function(success) {
		return cordova.exec(success,
				function(e){console.log('DeviceAPIGuide EgovInterface.geturl Fail');jAlert(e);},     //Error callback from the plugin
				"InterfaceAPI",
				"geturl",
				[]);
	},
	echo : function(message){
		cordova.exec(null, null, "InterfaceAPI", "echo", [message]);
	}
}

/*********************************************************
 * EgovStorageInfo 플러그인
 *********************************************************/


/**
 * Storgae 정보 조회 플러그인 자바스크립트
 * @returns
 * @type
 */
var StorageInfo = {
	totalFileSystemSize: function(success, fail, types) {
		console.log("totalFileSystemSize : ");
		return Cordova.exec(success, fail, "StorageInfoAPI", "fileSystemSize", types);
	},

	freeFileSystemSize: function() {
		console.log("freeFileSystemSize : ");
		return Cordova.exec(success, fail, "StorageInfoAPI", "fileSystemSize", types);
	}
}



/*********************************************************
 * 디바이스의 네트워크 체크 
 *********************************************************/


/**
 * 디바이스의 네트워크 정보 알림 함수
 * @returns
 * @type
 */
function fn_egov_network_notification(){
	if(navigator.connection.type != Connection.WIFI){
		navigator.notification.alert("3G망을 사용할 경우 과금이 발생할 수 있습니다.", null, 'Info');
	}
}


/** 네트워크를 한번만 체크하기 위한 구분 변수 */
var  isNetworkCheck = false;


/**
 * 네트웍 이용시 wifi 체크
 * @param doCheck 항상체크 여부
 * @returns wifi 연결 여부
 * @type boolean
 */
function fn_egov_network_check(doCheck){

	console.log('DeviceAPIGuide fn_egov_network_check');
	var networkState = navigator.connection.type;

	if (networkState == Connection.UNKNOWN || networkState == Connection.NONE) {
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