//
//  MqttDataMessage.swift
//  XySmartDemo
//
//  Created by rocky on 2024/4/23.
//

import Foundation
struct MqttDataMessage: Codable  {
    var messageType: String?
    var data: [MqttData]?
}
