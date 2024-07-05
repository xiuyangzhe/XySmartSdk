//
//  BleUtil.swift
//  XySmartSdk
//
//  Created by rocky on 2024/7/4.
//

import Foundation

import CoreBluetooth

class BleUtil:NSObject,CBCentralManagerDelegate,CBPeripheralDelegate{
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if(central.state == .poweredOn){
            // open handle
            startScan()
        }else{
            NSLog("ble is not open")
        }
    }
    
    var manager: CBCentralManager?
    var peripheral: CBPeripheral?
    var activeService: CBService?
    var activecharacteristic:CBCharacteristic?
    
    override init(){
        super.init()
        manager = CBCentralManager(delegate: self, queue: nil)
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
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if let data = characteristic.value {
               let value = String(data: data, encoding: .utf8)
               NSLog("Characteristic value: \(value ?? "")")
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
            
            NSLog("ble find service:"+service.uuid.uuidString)
            peripheral.discoverCharacteristics(nil, for: service)
        })
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        NSLog("ble connect:"+(peripheral.name!))
        
        peripheral.delegate = self
        // 连接蓝牙设备的代理
        peripheral.discoverServices(nil)
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if(peripheral.name != nil){
            NSLog("ble is didDiscover:"+(peripheral.name!))
            
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
