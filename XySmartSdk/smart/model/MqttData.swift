//
//  MqttData.swift
//  XySmartDemo
//
//  Created by rocky on 2024/4/23.
//

import Foundation

struct MqttData: Codable{
    var model: String?
    var uuid: String?
    var parentDeviceId: String?
    var deviceId: String?
    var code: String?
}
