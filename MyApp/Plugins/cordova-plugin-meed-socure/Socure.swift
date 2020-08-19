/********* Socure.swift Cordova Plugin Implementation *******/

import SocureSdk

/*
* Notes: The @objc shows that this class & function should be exposed to Cordova.
*/


@objc(Socure) class Socure : CDVPlugin, SocureScanResult {
    
  var invokedUrlcommand: CDVInvokedUrlCommand?
    

  @objc(checkPermissions:) // Declare your function name.
  func checkPermissions(command: CDVInvokedUrlCommand) { // write the function code.
    // Set the plugin result to fail.
    // var pluginResult = CDVPluginResult (status: CDVCommandStatus_ERROR, messageAs: "The Plugin Failed");
    // Set the plugin result to succeed.
     let   pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: 100);
    // Send the function result back to Cordova.
    self.commandDelegate!.send(pluginResult, callbackId: command.callbackId);
  }
    
    
  @objc(scanLicense:)
  func scanLicense(command: CDVInvokedUrlCommand) {
    self.invokedUrlcommand = command
    let controller =  SocureViewController(socureScaneMode: SocureScaneMode.License);
    controller.modalPresentationStyle = .fullScreen
    controller.delegate = self
    
    self.viewController.present(controller, animated: false, completion: nil)
  }
    

  @objc(scanPassport:)
  func scanPassport(command: CDVInvokedUrlCommand) {
    self.invokedUrlcommand = command
    let controller =  SocureViewController(socureScaneMode: SocureScaneMode.Passport);
    controller.modalPresentationStyle = .fullScreen
    controller.delegate = self
     
    self.viewController.present(controller, animated: false, completion: nil)
  }
    
    
  @objc(scanSelfie:)
  func scanSelfie(command: CDVInvokedUrlCommand) {
    self.invokedUrlcommand = command
      
    let controller =  SocureViewController(socureScaneMode: SocureScaneMode.Selfie);
    controller.modalPresentationStyle = .fullScreen
    controller.delegate = self
      
    self.viewController.present(controller, animated: false, completion: nil)
  }
    

  @objc(openSetting:)
  func openSetting(command: CDVInvokedUrlCommand) {
    if let url = NSURL(string: UIApplicationOpenSettingsURLString) as URL? {
      UIApplication.shared.open(url)
      let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: true);
      self.commandDelegate!.send(pluginResult, callbackId: command.callbackId);
    }
  }

    /********* SocureScanResult  Delegate Protocol  Methods Implementation *******/
    
  @objc public func licanseScanResult(licenseScanResult: Dictionary<String, Any>) {
    let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: licenseScanResult);
    self.commandDelegate!.send(pluginResult, callbackId: self.invokedUrlcommand?.callbackId);
      
  }
  
  @objc public func passportScanResult(passportScanResult: Dictionary<String, Any>) {
    let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: passportScanResult);
    self.commandDelegate!.send(pluginResult, callbackId: self.invokedUrlcommand?.callbackId);
  }
  
  @objc public func selfieScanResult(selfieScanResult: Dictionary<String, String>) {
    let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: selfieScanResult);
    self.commandDelegate!.send(pluginResult, callbackId: self.invokedUrlcommand?.callbackId);
  }
    
}

public enum SocureScaneMode {
  case License
  case Passport
  case Selfie
}

@objc public protocol SocureScanResult {
  func licanseScanResult(licenseScanResult: Dictionary<String, Any>)
  func passportScanResult(passportScanResult: Dictionary<String, Any>)
  func selfieScanResult(selfieScanResult: Dictionary<String, String>)
}
