

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
    	console.log(error);
        alert(error);
    };
    
    cordova.exec(null, callbackFail, "CustomMyPlugin", "runJavaScriptFunction", []);
    
}

function print_message(result){
	console.log("result : "+result);
    alert(result.name);
}
