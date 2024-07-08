//
//  MqttNewDataMessage.swift
//  XySmartSdk
//
//  Created by rocky on 2024/7/8.
//

import Foundation
struct MqttNewDataMessage: Codable  {
    var messageType: String?
    var deviceStatusList: [MqttData]?
}
