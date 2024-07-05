//
//  XySmartSdk.swift
//  xysmart
//
//  Created by rocky on 2024/4/4.
//

import Foundation

public class XySmartSdk: NSObject {
    
    public static func initSdk(clientId: String,
                               clientSecret: String,
                               onSuccess: @escaping () -> Void = {  },
                               onFailed: @escaping (SdkError) -> Void = { _ in }) {
        Business.Instance.initBusiness(clientId: clientId, clientSecret: clientSecret,onSuccess: {
            onSuccess()
        },onFailed:{e in
            onFailed(e)
        })
    }
    
    public static func activateDevice(
          uuid: String,
          homeId: String,
          onSuccess: @escaping () -> Void = {  },
          onFailed: @escaping (SdkError) -> Void = { _ in }
    ){
        Business.Instance.activeDevice(uuid: uuid, homeId: homeId,onSuccess: {
            onSuccess()
        },onFailed:{e in
            onFailed(e)
        })
    }
    
    public static func resetGateway(
          uuid: String,
          onSuccess: @escaping () -> Void = {  },
          onFailed: @escaping (SdkError) -> Void = { _ in }
    ){
        Business.Instance.resetGateway(id: uuid,onSuccess: {
            onSuccess()
        },onFailed:{e in
            onFailed(e)
        })
    }
    
    
    public static var scanDeviceonSuccess: ((Device) -> Void)?
    public static var scanDeviceononFailed: ((SdkError) -> Void)?
    public static var scanGatewayUUId: String?
    public static var scanTopic: String?
    
    public static var isInScan = false
    
    public static func  scanDevice(uuid: String,
                                   onSuccess: @escaping (Device) -> Void = { _ in },
                                   onFailed: @escaping (SdkError) -> Void = { _ in }){
        
        // subscribe
        // start time 30s and stop
        // auto unsubscribe
        if(isInScan){
            onFailed(SdkError(code: 6006,message: "in scan device"))
            return
        }
        let thread = Thread(){
            print("start scan")
            isInScan = true
            
            scanDeviceonSuccess = onSuccess
            scanDeviceononFailed = onFailed
            scanGatewayUUId = uuid
            
            Business.Instance.startDeviceScan(id: uuid, onSuccess: { d in
                Business.Instance.subTopic(topic: d.scanTopic!)
                scanTopic = d.scanTopic!
            },onFailed:{e in
                scanDeviceonSuccess = nil
                scanDeviceononFailed = nil
                scanGatewayUUId = nil
                print("stop scan")
                isInScan = false
                onFailed(e)
            })
            
            var lastTime = Date().timeIntervalSince1970
            while(true){
                var nowTime = Date().timeIntervalSince1970
                if((nowTime - lastTime) * 1000 > 30 * 1000 && isInScan){
                    scanDeviceonSuccess = nil
                    scanDeviceononFailed = nil
                    scanGatewayUUId = nil
                    print("stop scan")
                    isInScan = false
                    if(scanTopic != nil){
                        Business.Instance.unsubTopic(topic: scanTopic!)
                    }
                    var e = SdkError(code: SdkErrorType.TIMEOUT.code, message: "scan time out")
                    onFailed(e)
                    break;
                }else if(isInScan){
                    Thread.sleep(forTimeInterval: 1.0)
                    print("in scan")
                }
                if(!isInScan){
                    break;
                }
            }
        }
        
        thread.start()

        
    }

    public static func  stopScanDevice(uuid: String,
                                       onSuccess: @escaping () -> Void = {  },
                                       onFailed: @escaping (SdkError) -> Void = { _ in }){
        // send stop
        // unsubscribe
        isInScan = false
        Business.Instance.stopDeviceScan(uuid: uuid, onSuccess: { d in
            if(scanTopic != nil){
                Business.Instance.unsubTopic(topic: scanTopic!)
            }
            
            onSuccess()
        }, onFailed: {e in
            scanGatewayUUId = nil
            onFailed(e)
        })
    }
    
    static var bleUtil:BleUtil?
    
    public static var inActive = false
    
    private static func clearActiveConfig(){
        self.inActive = false
        bleUtil?.ssid = nil
        bleUtil?.password = nil
        bleUtil?.homeId = nil
        bleUtil?.onActiveSuccess = nil
        bleUtil?.onAcviveFailed = nil
    }
    
    public static func activateXyWIFIDevice(ssid:String?,password:String?,homeId:String,  onSuccess: @escaping () -> Void = {  },
                                            onFailed: @escaping (SdkError) -> Void = { _ in }){
        let thread = Thread(){
            bleUtil = BleUtil();
            bleUtil?.startActive(ssid:nil,password:nil,homeId:homeId,onSuccess: {
                clearActiveConfig()
                onSuccess()
            }, onAcviveFailed: { e in
                clearActiveConfig()
                onFailed(e)
            })
            
            let lastTime = Date().timeIntervalSince1970
            while(true){
                let nowTime = Date().timeIntervalSince1970
                if((nowTime - lastTime) * 1000 > 60 * 1000 && self.inActive){
                    let e = SdkError(code: SdkErrorType.TIMEOUT.code, message: "active time out")
                    NSLog("active time out")
                    onFailed(e)
                    break;
                }else if(self.inActive){
                    Thread.sleep(forTimeInterval: 1.0)
                    NSLog("in active")
                }
                if(!self.inActive){
                    break;
                }
            }
        }
        thread.start()
        
    }
    
    
    public static func activateXyDevice(homeId:String,  onSuccess: @escaping () -> Void = {  },
                                        onFailed: @escaping (SdkError) -> Void = { _ in }){
        activateXyWIFIDevice(ssid: nil,password: nil,homeId:homeId,onSuccess:onSuccess,onFailed:onFailed)

    }
}
