/***************************************************************************
 파일명 : EgovZipAPI.js
 설  명 : 모바일 전자정부 하이브리드 앱 실행환경 공통 JavaScript
 수정일         수정자		Version			Function 명
 ----------		------		-------			--------------------------------
 2012.06.24		신용호		1.0				최초 생성
 **************************************************************************/



/*********************************************************
 * EgovZipAPI 플러그인
 *********************************************************/

/**
 * Native 함수를 호출하여 외부 서버와 통신하는 function.
 */
var EgovZip = {
submitAsynchronous: function(types, success, fail) {
    return cordova.exec(success, fail, "InterfaceAPI", "submitAsynchronous", types);
},
request: function(url, params, success, fail) {
    alert("start!");
    var types = [params, url];
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


if(!window.plugins) {
    window.plugins = {};
}

if (!window.plugins.EgovZip) {
    window.plugins.EgovZip = EgovZip;
}

