//
//  SocureViewController.swift
//  SocurePlugin
//
//  Created by Rahadur on 15/8/20.
//  Copyright © 2020 Rahadur. All rights reserved.
//

import UIKit
import SocureSdk

@objc class SocureViewController: UIViewController {
    
    var socureScaneMode : SocureScaneMode
    
    var delegate : SocureScanResult?
    
    var licenseScanResult: Dictionary<String, Any> = [:]
    var passportScanResult: Dictionary<String, Any> = [:]
    var selfieScanResult: Dictionary<String, String> = [:]

    init(socureScaneMode: SocureScaneMode) {
        self.socureScaneMode = socureScaneMode
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }

    @objc override func viewDidLoad() {
        super.viewDidLoad()
        
        switch socureScaneMode {
        case .License:
            let docScanner = DocumentScanner()
            docScanner.initiateLicenseScan(ImageCallback: self, BarcodeCallback: self)
            break
        case .Passport:
            let docScanner = DocumentScanner()
            docScanner.initiatePassportScan(ImageCallback: self, MRZCallback: self)
            break
        case .Selfie:
            let selfieScanner = SelfieScanner()
            selfieScanner.initiateSelfieScan(imageCallback: self)
            break
        }
    }
    
    @objc override func viewWillDisappear(_ animated: Bool) {
        switch socureScaneMode {
        case .License:
            self.delegate?.licanseScanResult(licenseScanResult: self.licenseScanResult)
            break
        case .Passport:
            self.delegate?.passportScanResult(passportScanResult: self.passportScanResult)
            break
        case .Selfie:
            self.delegate?.selfieScanResult(selfieScanResult: self.selfieScanResult)
            break
        }
        super.viewWillDisappear(false)
    }
        
}

extension SocureViewController: ImageCallback, MRZCallback, BarcodeCallback {
    func handleMRZData(mrzData: MrzData?) {
        print("handleMRZData")
        
        self.passportScanResult["mrzData"] = [
            "code": mrzData?.code ?? "",
            "format": mrzData?.format ?? "",
            "surName": mrzData?.surName ?? "",
            "firstName": mrzData?.fullName ?? "",
            "issuingCountry": mrzData?.issuingCountry ?? "",
            "nationality": mrzData?.nationality ?? "",
            "sex": mrzData?.sex ?? "",
            "dob": mrzData?.dob ?? "",
            "documentNumber": mrzData?.documentNumber ?? "",
            "expirationDate": mrzData?.expirationDate ?? "",
            "validDocumentNumber": mrzData?.validDocumentNumber ?? false,
            "validDateOfBirth": mrzData?.validDateOfBirth ?? false,
            "validExpirationDate": mrzData?.validExpirationDate ?? false,
            "validComposite": mrzData?.validComposite ?? false
            ] as [String : Any]
    }
    

     func handleBarcodeData(barcodeData: BarcodeData?) {
         print("handleBarcodeData")
        
        self.licenseScanResult["barcodeData"] = [
            "firstName": barcodeData?.firstName ?? "",
            "lastName": barcodeData?.lastName ?? "",
            "middleName": barcodeData?.middleName ?? "",
            "fullName": barcodeData?.fullName ?? "",
            "dob": barcodeData?.dob ?? "",
            "address": barcodeData?.address ?? "",
            "city": barcodeData?.city ?? "",
            "state": barcodeData?.state ?? "",
            "postalCode": barcodeData?.city ?? "",
            "documentNumber": barcodeData?.documentNumber ?? "",
            "issueDate": barcodeData?.issueDate ?? "",
            "expirationDate": barcodeData?.expirationDate ?? ""
            ] as [String: String]
    }
    
    @objc func documentFrontCallBack(docScanResult: DocScanResult) {
        print("documentFrontCallBack")
        switch socureScaneMode {
        case .License:
            self.licenseScanResult["licenseFrontImage"] = docScanResult.imageData?.base64EncodedString()
            break
        case .Passport:
            self.passportScanResult["passportImage"] = docScanResult.imageData?.base64EncodedString()
            break
        case .Selfie: break     // Required for ignore "Switch must be exhaustive" error.
        }
    }
    
    @objc func documentBackCallBack(docScanResult: DocScanResult) {
        print("documentBackCallBack")
        self.licenseScanResult["licenseBackImage"] = docScanResult.imageData?.base64EncodedString()
        self.dismiss(animated: false, completion: nil)
    }
    

    @objc func selfieCallBack(selfieScanResult: SelfieScanResult) {
        print("selfieCallBack")
        self.selfieScanResult["selfieImage"] = selfieScanResult.imageData?.base64EncodedString()
        self.dismiss(animated: false, completion: nil)
    }
    

    func onScanCancelled() {
       print("onScanCancelled")
       emptyScanResult()
       self.dismiss(animated: false, completion: nil)
    }
    
    func onError(errorType: SocureSDKErrorType, errorMessage: String) {
        print("onError: \(errorType) => \(errorMessage)")
        emptyScanResult()
        self.dismiss(animated: false, completion: nil)
    }
    
    func emptyScanResult() {
        switch socureScaneMode {
        case .License:
            let barcodeData = [
            "firstName": "",
            "lastName": "",
            "middleName": "",
            "fullName": "",
            "dob": "",
            "address": "",
            "city":  "",
            "state": "",
            "postalCode": "",
            "documentNumber": "",
            "issueDate": "",
            "expirationDate": ""
            ] as [String: String]
            
            self.licenseScanResult = ["licenseFrontImage": "", "licenseBackImage": "", "barcodeData": barcodeData]
            break
        case .Passport:
            let mrzData = [
                "code":  "",
                "format": "",
                "surName":  "",
                "firstName": "",
                "issuingCountry":  "",
                "nationality":  "",
                "sex": "",
                "dob": "",
                "documentNumber":  "",
                "expirationDate": "",
                "validDocumentNumber": false,
                "validDateOfBirth": false,
                "validExpirationDate": false,
                "validComposite": false
            ] as [String: Any]
            
            self.passportScanResult = ["passportImage": "", "mrzData": mrzData]
            break
        case .Selfie:
            self.selfieScanResult = ["selfieImage": ""]
            break
        }
    }
}
