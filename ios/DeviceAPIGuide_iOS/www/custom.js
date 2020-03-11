//
//  sf_phonegap_plugin_demo_echo.js
//
//  Created by SungKwang Song on 3/12/14.
//
//


function CustomMyPlugin(){}

CustomMyPlugin.prototype.echo = function(message){
    cordova.exec(null, null, "CustomMyPlugin", "echo", [message]);
}

CustomMyPlugin.prototype.getMessage = function(){
    var callbackSuccess = function(result){
        alert(result.name);
    };
    
    var callbackFail = function(error){
        alert(error);
    };
    
    cordova.exec(callbackSuccess, callbackFail, "CustomMyPlugin", "getMessage", []);
    
}



CustomMyPlugin.prototype.runJavaScript = function(){
    var callbackFail = function(error){
        alert(error);
    };
    
    cordova.exec(null, callbackFail, "CustomMyPlugin", "runJavasScriptFuncion", []);
    
}

function print_message(result){
    alert(result.name);
}
