cordova.define("cordova-plugin-root-detection.RootDetection", function(require, exports, module) {
var exec = require('cordova/exec');

exports.isDeviceRooted = function(success, error) {
    exec(success, error, "RootDetection", "isDeviceRooted", []);
};

});
