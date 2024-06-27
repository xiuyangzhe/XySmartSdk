//
//  DeviceActivateEvent.swift
//  XySmartDemo
//
//  Created by rocky on 2024/4/4.
//

import Foundation

public protocol DeviceActivateEvent {
    
    func onSucceed(device: Device)

    func onFailed(errorCode: String, errorMessage: String?)
}
