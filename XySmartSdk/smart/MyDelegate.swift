//
//  MyDelegate.swift
//  XySmartDemo
//
//  Created by rocky on 2024/4/4.
//

import Foundation
import CocoaMQTT

class MyDelegate: CocoaMQTT5Delegate{
    
    func isNullOrempty(str: String?)-> Bool{
        return str == nil || str!.isEmpty
    }
    func mqtt5(_ mqtt5: CocoaMQTT5, didConnectAck ack: CocoaMQTTCONNACKReasonCode, connAckData: MqttDecodeConnAck?) {
        NSLog("mq server connected")
        
        if(XySmartSdk.scanTopic != nil){
            Business.Instance.subTopic(topic: XySmartSdk.scanTopic!)
        }
    }
    
    func mqtt5(_ mqtt5: CocoaMQTT5, didPublishMessage message: CocoaMQTT5Message, id: UInt16) {
        NSLog("mqtt didPublishMessage")
    }
    
    func mqtt5(_ mqtt5: CocoaMQTT5, didPublishAck id: UInt16, pubAckData: MqttDecodePubAck?) {
        NSLog("mqtt didPublishAck")
    }
    
    func mqtt5(_ mqtt5: CocoaMQTT5, didPublishRec id: UInt16, pubRecData: MqttDecodePubRec?) {
        NSLog("mqtt5 didPublishRec")
    }
    
    func activeDeice(uuid: String, model:String){
        var bindDevice = BindDeviceInfo()
        bindDevice.uuid = uuid
        bindDevice.model = model
        bindDevice.gatewayUUId = XySmartSdk.scanGatewayUUId
        Business.Instance.bindDevice(info: bindDevice, onSuccess: { b in
            XySmartSdk.scanDeviceonSuccess?(b.device!)
        },onFailed:{e in
            XySmartSdk.scanDeviceononFailed?(e)
        })
    }
    
    func mqtt5(_ mqtt5: CocoaMQTT5, didReceiveMessage message: CocoaMQTT5Message, id: UInt16, publishData: MqttDecodePublish?) {
        // NSLog("Received message: \(message.string) from topic: \(message.topic)")
        
        do{
            
            let decoder = JSONDecoder()
            var data = Data(message.payload)
            let result: MqttDataMessage = try decoder.decode(MqttDataMessage.self,from: data)
            
            NSLog("messag type: \(result.messageType!)")
            
            
            if(result.messageType == "Bind"){
                let new_result:MqttNewDataMessage = try decoder.decode(MqttNewDataMessage.self,from: data)
                
                activeDeice(uuid: new_result.deviceStatusList![0].uuid!,model: new_result.deviceStatusList![0].model!);
            }
            
            // 绑定子设备
            if (result.messageType == "bind") { // || (data.messageType == "control.prop" && data.data!![0].code == "SWBuildID")
                var uuid = result.data![0].deviceId
                if (isNullOrempty(str: uuid) || isNullOrempty(str: result.data![0].model) || isNullOrempty(str: XySmartSdk.scanGatewayUUId)) {
                    return;
                }
                let model = result.data![0].model!
                activeDeice(uuid: uuid!,model: model)
                
            }
        } catch let error {
            NSLog("message error")
        }
    }
    
    func mqtt5(_ mqtt5: CocoaMQTT5, didSubscribeTopics success: NSDictionary, failed: [String], subAckData: MqttDecodeSubAck?) {
        print("mqtt didSubscribeTopics")
    }
    
    func mqtt5(_ mqtt5: CocoaMQTT5, didUnsubscribeTopics topics: [String], unsubAckData: MqttDecodeUnsubAck?) {
        print("mqtt didUnsubscribeTopics")
    }
    
    func mqtt5(_ mqtt5: CocoaMQTT5, didReceiveDisconnectReasonCode reasonCode: CocoaMQTTDISCONNECTReasonCode) {
//        print("mqtt5 didReceiveDisconnectReasonCode")
    }
    
    func mqtt5(_ mqtt5: CocoaMQTT5, didReceiveAuthReasonCode reasonCode: CocoaMQTTAUTHReasonCode) {
//        print("mqtt5DidReceivePong")
    }
    
    func mqtt5DidPing(_ mqtt5: CocoaMQTT5) {
//        print("mqtt5 mqtt5DidPing")
    }
    
    func mqtt5DidReceivePong(_ mqtt5: CocoaMQTT5) {
//        print("mqtt5 mqtt5DidReceivePong")
    }
    
    func mqtt5DidDisconnect(_ mqtt5: CocoaMQTT5, withError err: Error?) {
        if let error = err {
            print("mqtt: \(error.localizedDescription)")
        } else {
            print("mqtt: Disconnected without error")
        }
    }
    
    
}
