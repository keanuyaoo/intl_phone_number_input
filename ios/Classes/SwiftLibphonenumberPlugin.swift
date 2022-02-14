import Flutter
import UIKit
import PhoneNumberKit

public class SwiftLibphonenumberPlugin: NSObject, FlutterPlugin {
    
//    let libphonenumber : SwiftLibphonenumberPlugin = SwiftLibphonenumberPlugin()
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "plugin.libphonenumber", binaryMessenger: registrar.messenger())
        
        let instance = SwiftLibphonenumberPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "isValidPhoneNumber":
            isValidPhoneNumber(call: call, result: result)
            break
        case "normalizePhoneNumber":
            normalizePhoneNumber(call: call, result: result)
            break
        case "getRegionInfo":
            getRegionInfo(call: call, result: result)
            break
        case "getNumberType":
            getNumberType(call: call, result: result)
            break
        case "formatAsYouType":
            formatAsYouType(call: call, result: result)
            break
        case "getNameForNumber":
            getNameForNumber(call: call, result: result)
            break
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    
    func isValidPhoneNumber(call: FlutterMethodCall, result: @escaping FlutterResult) {
        let arguments = call.arguments as! Dictionary<String, Any>
        let phoneNumber = arguments["phoneNumber"] as! String
        let isoCode = arguments["isoCode"] as! String
        
        
        let phoneNumberKit : PhoneNumberKit = PhoneNumberKit()
        
        do {
            let isValid: Bool = phoneNumberKit.isValidPhoneNumber(phoneNumber,withRegion: isoCode.uppercased(),ignoreType: true);
            //            let p:PhoneNumber = try phoneNumberKit.parse(phoneNumber,withRegion: isoCode.uppercased(),ignoreType:true);
            //            // let p : NBPhoneNumber = try phoneUtils.parse(phoneNumber, defaultRegion: isoCode.uppercased())
            //            let isValid : Bool = phoneNumberKit.isvalid
            
            result(isValid)
        } catch let error as NSError {
            result(FlutterError(code: "\(error.code)", message: error.localizedDescription, details: nil))
        }
    }
    
    
    func normalizePhoneNumber(call: FlutterMethodCall, result: @escaping FlutterResult) {
        let arguments = call.arguments as! Dictionary<String, Any>
        let phoneNumber = arguments["phoneNumber"] as! String
        let isoCode = arguments["isoCode"] as! String
        
        
        let phoneNumberKit : PhoneNumberKit = PhoneNumberKit()
        
        do {
            // let p : NBPhoneNumber = try phoneUtils.parse(phoneNumber, defaultRegion: isoCode.uppercased())
            let p:PhoneNumber = try phoneNumberKit.parse(phoneNumber,withRegion: isoCode.uppercased(),ignoreType: true);
            let normalized : String = try phoneNumberKit.format(p, toType: .e164)
            
            result(normalized)
        } catch let error as NSError {
            result(FlutterError(code: "\(error.code)", message: error.localizedDescription, details: nil))
        }
    }
    
    func getRegionInfo(call: FlutterMethodCall, result: @escaping FlutterResult) {
        let arguments = call.arguments as! Dictionary<String, Any>
        let phoneNumber = arguments["phoneNumber"] as! String
        let isoCode = arguments["isoCode"] as! String
        
        
        let phoneNumberKit : PhoneNumberKit = PhoneNumberKit()
        
        do {
            let p : PhoneNumber = try phoneNumberKit.parse(phoneNumber, withRegion: isoCode.uppercased())
            
            let regionCode : String? = phoneNumberKit.getRegionCode(of: p)
            let countryCode : String? = String(p.countryCode);// p.countryCode.s .stringValue as String
            let formattedNumber : String? = try phoneNumberKit.format(p,toType: .national)
            
            let data : Dictionary<String, String?> = ["isoCode": regionCode, "regionCode" : countryCode, "formattedPhoneNumber" : formattedNumber]
            
            result(data)
        } catch let error as NSError {
            result(FlutterError(code: "\(error.code)", message: error.localizedDescription, details: nil))
        }
    }
    
    func getNumberType(call: FlutterMethodCall, result: @escaping FlutterResult) {
        let arguments = call.arguments as! Dictionary<String, Any>
        let phoneNumber = arguments["phoneNumber"] as! String
        let isoCode = arguments["isoCode"] as! String
        
        
        let phoneNumberKit : PhoneNumberKit = PhoneNumberKit()
        
        do {
            let p : PhoneNumber = try phoneNumberKit.parse(phoneNumber, withRegion: isoCode.uppercased())
            
            let value : Int?
            
            
            switch(p.type){
            case .fixedLine:
                value = 0;
                break;
            case .mobile:
                value = 1 ;
                break;
            case .fixedOrMobile:
                value = 2;
                break;
            case .pager:
                value=3;
                break;
            case .personalNumber:
                value=4;
                break;
            case .premiumRate:
                value=5;
                break;
            case .sharedCost:
                value=6;
                break;
            case .tollFree:
                value=7;
                break;
            case .voicemail:
                value=8;
                break;
            case .voip:
                value=9;
                break;
            case .uan:
                value=10;
                break;
            case .unknown:
                value = -1;
                break;
            case .notParsed:
                value = -2;
                break;
            }
            result(value)
        } catch let error as NSError {
            result(FlutterError(code: "\(error.code)", message: error.localizedDescription, details: nil))
        }
    }
    
    
    func formatAsYouType(call: FlutterMethodCall, result: @escaping FlutterResult) {
        let arguments = call.arguments as! Dictionary<String, Any>
        let phoneNumber = arguments["phoneNumber"] as! String
        let isoCode = arguments["isoCode"] as! String
        
        let partialFormatter : PartialFormatter = PartialFormatter();
        
        var formattedNumber: String? = partialFormatter.formatPartial(phoneNumber);
        result(formattedNumber)
    }
    
    
    
    func getNameForNumber(call: FlutterMethodCall, result: @escaping FlutterResult) {
        let arguments = call.arguments as! Dictionary<String, Any>
        let phoneNumber = arguments["phoneNumber"] as! String
        let isoCode = arguments["isoCode"] as! String
        
        
        let phoneNumberKit : PhoneNumberKit = PhoneNumberKit()
        
        
        do {
            let _ : PhoneNumber = try phoneNumberKit.parse(phoneNumber, withRegion: isoCode.uppercased())
            result(FlutterMethodNotImplemented)
        } catch let error as NSError {
            result(FlutterError(code: "\(error.code)", message: error.localizedDescription, details: nil))
        }
    }
    
//    func onDirectMethodCall(call: FlutterMethodCall, result: @escaping FlutterResult) {
//        let arguments = call.arguments as! Dictionary<String, Any>
//        let phoneNumber = arguments["phoneNumber"] as! String
//        let isoCode = arguments["isoCode"] as! String
//        
//        let data:[String:String] = ["phone_number": phoneNumber, "iso_code": isoCode]
//        
//        let methodCall:FlutterMethodCall = FlutterMethodCall(methodName: call.method, arguments: data)
////        libphonenumber.handle(methodCall, result: result)
//        return
//    }
}
