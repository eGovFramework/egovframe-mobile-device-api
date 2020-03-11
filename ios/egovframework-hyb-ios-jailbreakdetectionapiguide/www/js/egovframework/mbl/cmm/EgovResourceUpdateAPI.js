/***************************************************************************
 파일명 : EgovResourceUpdateAPI.js
 설  명 : 모바일 전자정부 하이브리드 앱 실행환경 공통 JavaScript
 수정일         수정자		Version			Function 명
 ----------		------		-------			--------------------------------
 2012.06.24		신용호		1.0				최초 생성
 **************************************************************************/



/*********************************************************
 * EgovResourceUpdateAPI 플러그인
 *********************************************************/

/**
 * Native 함수를 호출하여 외부 서버와 통신하는 function.
 */
var EgovResourceUpdate = {
	update: function(url, params, success, fail) {
        url = url+"?orignlFileNm="+params["orignlFileNm"]+"&streFileNm="+params["streFileNm"];
        var types = [params, url];
		return cordova.exec(success, fail, "EgovResourceUpdate", "update", types);
	},
    getAppId: function(success, fail) {
        var types = [];
        return cordova.exec(success, fail, "EgovResourceUpdate", "getAppId", types);
    },
    getAppVersion: function(success, fail) {
        var types = [];
        return cordova.exec(success, fail, "EgovResourceUpdate", "getAppVersion", types);
    },
    getResourceVersion: function(success, fail) {
        var types = [];
        return cordova.exec(success, fail, "EgovResourceUpdate", "getResourceVersion", types);
    }
    
}


if(!window.plugins) {
    window.plugins = {};
}

if (!window.plugins.EgovResourceUpdate) {
    window.plugins.EgovResourceUpdate = EgovResourceUpdate;
}

