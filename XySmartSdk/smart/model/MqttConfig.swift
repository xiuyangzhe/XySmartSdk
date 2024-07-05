//
//  MqttConfig.swift
//  xysmartsdk
//
//  Created by rocky on 2024/7/5.
//

import Foundation

public struct MqttConfig: Codable  {
    public var mqttServer:String?
    public var mqttPort: Int?
    public var username: String?
    public var password: String?
    public var gatewayTopic: String?
    public var uuid: String?
    public var deviceId: String?
    public var ntpServer: String?
    public var cerUrl: String?
}
