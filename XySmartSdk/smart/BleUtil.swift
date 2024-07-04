//
//  BleUtil.swift
//  XySmartSdk
//
//  Created by rocky on 2024/7/4.
//

import Foundation

import CoreBluetooth

class BleUtil:NSObject,CBCentralManagerDelegate{
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if(central.state == .poweredOn){
            // open handle
            startScan()
        }else{
            NSLog("ble is not open")
        }
    }
    
    var manager: CBCentralManager?
    
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
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if(peripheral.name != nil){
            NSLog("ble is didDiscover:"+(peripheral.name!))
        }
    }
}
