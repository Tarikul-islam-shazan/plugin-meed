cordova.define("cordova-plugin-meed-socure.Socure", function(require, exports, module) {
var exec = require('cordova/exec');

/**
 * This method will return all permissions that required
 * for access camera hardware.
 * 
 * options = [
 *  Permission.Camera,
 *  Permission.Location
 * ]
 */
exports.checkPermissions = function (options, success, error) {
    exec(success, error, 'Socure', 'checkPermissions', [options]);
};

/**
 * This method will capture License front and back part
 * and return base64 captured Image Data
 */
exports.scanLicense = function (success, error) {
    exec(success, error, 'Socure', 'scanLicense', []);
};


/**
 * This method will capture Passport by back camera
 * and return base64 captured Image Data
 */
exports.scanPassport = function (success, error) {
    exec(success, error, 'Socure', 'scanPassport', []);
};

/**
 * This method will capture Selfie by front camera
 * and return base64 captured Image Data
 */
exports.scanSelfie = function (success, error) {
    exec(success, error, 'Socure', 'scanSelfie', []);
};


/**
 * This method will take user to the app setting window
 * so that they can give required permission for this
 * plugin.
 */
exports.openSetting = function (success, error) {
    exec(success, error, 'Socure', 'openSetting', []);
};

});
