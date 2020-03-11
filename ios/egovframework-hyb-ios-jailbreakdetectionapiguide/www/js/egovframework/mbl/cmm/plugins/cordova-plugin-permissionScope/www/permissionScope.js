cordova.define("cordova-plugin-permissionScope.PermissionScope", function(require, exports, module) {

(function () {

var exec = require('cordova/exec');

exports.init = function(config, success, error) {
    exec(success, error, 'PermissionScope',  'initialize', [ config ]);
};

const types = [
               'Notifications',
               'LocationInUse',
               'LocationAlways',
               'Contacts',
               'Events',
               'Microphone',
               'Camera',
               'Photos',
               'Reminders',
               'Bluetooth',
               'Motion',
               'Speech'
               ];

types.forEach(function(type) {
              const addPermissionMethod = `add${type}Permission`;
              const requestPermissionMethod = `request${type}Permission`;
              exports[addPermissionMethod] = function(message, success, error) {
              exec(success, error, 'PermissionScope', 'addPermission', [ type, message ] );
              };
              exports[requestPermissionMethod] = function(success, error) {
              exec(success, error, 'PermissionScope', 'requestPermission', [ type ] );
              };
              })

exports.show = function(success, error) {
    exec(success, error, 'PermissionScope',  'show');
};


 })();
               
});
