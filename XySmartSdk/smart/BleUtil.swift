//
//  BleUtil.swift
//  XySmartSdk
//
//  Created by rocky on 2024/7/4.
//

import Foundation

import CoreBluetooth

extension Data {
    func hexadecimalString() -> String {
        return map { String(format: "%02x", $0) }.joined()
    }
}

class BleUtil: NSObject,CBCentralManagerDelegate,CBPeripheralDelegate{
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if(central.state == .poweredOn){
            // open handle
            NSLog("ble is open")
            isOpen = true
        }else{
            isOpen = false
            NSLog("ble is not open")
        }
    }
    
    var manager: CBCentralManager?
    var peripheral: CBPeripheral?
    var activeService: CBService?
    var activecharacteristic:CBCharacteristic?
    var isOpen: Bool = false
    
    override init(){
        super.init()
        manager = CBCentralManager(delegate: self, queue: nil)
    }
    
    func startActive(ssid:String?,password:String?,homeId:String,onSuccess: @escaping ((Device) -> Void),onAcviveFailed: @escaping ((SdkError) -> Void)){
        self.onActiveSuccess = onSuccess
        self.onAcviveFailed = onAcviveFailed
        self.ssid = ssid
        self.password = password
        self.homeId = homeId
        
        if(isOpen){
            startScan()
        }else{
            let error = SdkError(code:SdkErrorType.BleConnectError.code,message: "打开蓝牙失败")
            onAcviveFailed(error)
        }
    }
    
    func initBle(){
        manager = CBCentralManager(delegate: self, queue: nil)
    }
    func startScan(){
        manager?.scanForPeripherals(withServices: nil)
    }
    
    func stopScan(){
        manager?.stopScan()
    }
    
    var wifiHeader: [UInt8] = [ 0x03, 0xca, 0x20]
    
    var ethHeader: [UInt8] = [0x03,0xf1, 0x13]
    
    func writeBuffer(buffer: UnsafeMutableBufferPointer<UInt8>, offset:Int, str:String) {
        let dataBuffer = str.data(using: String.Encoding.utf8)
        if(dataBuffer == nil){
            return
        }
        if (str.count > 255) {
            
            buffer[offset] = 0xFF;
            let size = dataBuffer!.count - 255
            
            buffer[offset+1] = UInt8(size);
        } else {
            buffer[offset] = 0x00;
            
            buffer[offset+1] = UInt8(dataBuffer!.count);
        }
        
        for i in 0..<dataBuffer!.count {
            buffer[offset + 2 + i] = dataBuffer![i]
        }
    }
    
    var ssid: String?
    var password: String?
    var activeResultHeader = "12127733160E9C48".lowercased();
    var homeId: String?
    var onActiveSuccess: ((Device) -> Void)?
    var onAcviveFailed: ((SdkError) -> Void)?
    
    func handleWriteMqttConfig(mqttConfig: MqttConfig){
        var isSsl = 0
        
        if mqttConfig.mqttServer!.prefix(5) == "mqtts" {
            isSsl = 1
        }
        
        var localConfig: [String: Any] = [
            "brokerUrl": mqttConfig.mqttServer,
            "port": mqttConfig.mqttPort,
            "username": Business.Instance.clientId,
            "password": Business.Instance.clientSecret,
            "cerUrl": mqttConfig.cerUrl,
            "isSsl": isSsl,
            "ntpServer": mqttConfig.ntpServer
        ]
        
        let buffer = UnsafeMutableRawBufferPointer.allocate(byteCount: 3 + 50 + 35 + 320, alignment: 1)
        let dataView:UnsafeMutableBufferPointer<UInt8> = buffer.bindMemory(to: UInt8.self)
        
        
        
        // write header
        if self.ssid != nil && !self.ssid!.isEmpty {
            for (index, value) in self.wifiHeader.enumerated() {
                dataView[index] = value
            }
        } else {
            for (index, value) in self.ethHeader.enumerated() {
                dataView[index] = value
            }
        }
        
        // write dev id 50
        let devId = "testid" // Replace with actual value
        writeBuffer(buffer: dataView, offset:3, str: devId)
        
        if ssid != nil && !ssid!.isEmpty {
            // write wifiSsid 35
            writeBuffer(buffer: dataView, offset: 53, str: ssid!)
            
            // write wifiPassword 65
            writeBuffer(buffer: dataView, offset: 88, str: password!)
            
            // write mqtt json 320
            
            do{
                let jsonData = try JSONSerialization.data(withJSONObject: localConfig, options: [])
                if let jsonString = String(data: jsonData, encoding: .utf8) {
                    writeBuffer(buffer: dataView, offset: 153, str: jsonString)
                }
            }catch{
                NSLog("Failed to convert dictionary to JSON: \(error)")
                let error = SdkError(code:SdkErrorType.OtherError.code,message: SdkErrorType.OtherError.message)
                onAcviveFailed?(error)
            }
            
            
            
        } else {
            do{
                let jsonData = try JSONSerialization.data(withJSONObject: localConfig, options: [])
                   if let jsonString = String(data: jsonData, encoding: .utf8) {
                       writeBuffer(buffer: dataView, offset: 53, str: jsonString)
                }
            }catch{
                NSLog("Failed to convert dictionary to JSON: \(error)")
                
                let error = SdkError(code:SdkErrorType.OtherError.code,message: SdkErrorType.OtherError.message)
                onAcviveFailed?(error)
            }
        }
        
        let byteData: Data = Data.init(dataView)
        
        peripheral!.writeValue(byteData, for: activecharacteristic!, type: .withResponse)
        
        // Clean up buffer
        buffer.deallocate()
    }
    
    func writeMqttConfig() {
        
        Business.Instance.getMqttConfig(onSuccess: { mqttConfig in
            self.handleWriteMqttConfig(mqttConfig:mqttConfig)
            
        },onFailed:{e in
        })
    }
    
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if let data = characteristic.value {
            let hexString = data.hexadecimalString().lowercased()
//            NSLog("Characteristic value: \(hexString)")
            if(hexString.starts(with: "460bf3")){
                NSLog("goto write mqttconfig")
                
                writeMqttConfig()
            }
            if(hexString.starts(with: activeResultHeader)){
                let startIndex = hexString.index(hexString.startIndex, offsetBy: activeResultHeader.count)
                let substring = hexString[startIndex...]
                NSLog("goto avtive device ")
                let deviceId = substring.uppercased()
                
                Business.Instance.activeDevice(uuid: deviceId, homeId: self.homeId,onSuccess: { d in
                    self.onActiveSuccess?(d)
                },onFailed:{e in
                    self.onAcviveFailed?(e)
                })
                
            }
          }
    }
    
    func peripheral(_ peripheral: CBPeripheral,
                    didDiscoverCharacteristicsFor service: CBService,
                    error: Error?) {
        
        if service.uuid.uuidString.lowercased() == "d4e1" {
            activeService = service
            service.characteristics?.forEach({ characteristic in
                activecharacteristic = characteristic
                peripheral.setNotifyValue(true, for: characteristic)
                
                let bytes: [UInt8] = [0x8e, 0xd5, 0x71, 0xac, 0x10, 0xd4, 0x0b, 0x7f]
                let byteData: Data = Data.init(bytes)
                peripheral.writeValue(byteData, for: characteristic, type: .withResponse)
            })
        }
//        delegate?.bleDidDiscoverCharacteristicsForService(peripheral, error: error)
    }

    
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        peripheral.services?.forEach({ service in
            
            NSLog("ble find service:")
            peripheral.discoverCharacteristics(nil, for: service)
        })
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        NSLog("ble connect:")
        
        peripheral.delegate = self
        // 连接蓝牙设备的代理
        peripheral.discoverServices(nil)
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if(peripheral.name != nil){
            NSLog("ble is didDiscover:"))
            
            if(peripheral.name=="xyiotgatef010591df12"){
                NSLog("find device")
                stopScan()
                
                self.peripheral = peripheral
                
                // goto connect
                manager?.connect(peripheral)
                
            }
        }
    }
}
