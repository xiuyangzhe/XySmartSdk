//
//  Device.swift
//  XySmartDemo
//
//  Created by rocky on 2024/4/4.
//

import Foundation	

public struct Device: Codable  {
    public var id: String?
    public var createOn: CLongLong?
    public var updateOn: CLongLong?
    public var statusList: [DeviceStatusInfo]?
    public var product: ProductInfo?
    public var productId: String?
    public var deviceType: String?
    public var online: Bool?
    public var activeTime: CLongLong?
    public var uuid: String?
    public var originalId: String?
    public var parentDeviceId: String?
    public var ownerId: String?
    public var configJson: String?
    public var subDevices: Array<Device>?
    
//    enum CodingKeys: String, CodingKey {
//
//        case id = "id"
//        case createOn = "createOn"
//        case updateOn = "updateOn"
//        case statusList = "statusList"
//        case product = "product"
//        case productId = "productId"
//        case deviceType = "deviceType"
//        case online = "online"
//        case activeTime = "activeTime"
//        case uuid = "uuid"
//        case originalId = "originalId"
//        case parentDeviceId = "parentDeviceId"
//        case ownerId = "ownerId"
//        case configJson = "configJson"
//        case subDevices = "subDevices"
//    }
//    
//    public required init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        id = try values.decodeIfPresent(String.self, forKey: .id)
//        createOn = try values.decodeIfPresent(CLongLong.self, forKey: .createOn)
//        updateOn = try values.decodeIfPresent(CLongLong.self, forKey: .updateOn)
//        statusList = try values.decodeIfPresent([DeviceStatusInfo].self, forKey: .statusList)
//        product = try values.decodeIfPresent(ProductInfo.self, forKey: .product)
//        productId = try values.decodeIfPresent(String.self, forKey: .productId)
//        deviceType = try values.decodeIfPresent(String.self, forKey: .deviceType)
//        online = try values.decodeIfPresent(Bool.self, forKey: .online)
//        activeTime = try values.decodeIfPresent(CLongLong.self, forKey: .activeTime)
//        uuid = try values.decodeIfPresent(String.self, forKey: .uuid)
//        originalId = try values.decodeIfPresent(String.self, forKey: .originalId)
//        parentDeviceId = try values.decodeIfPresent(String.self, forKey: .parentDeviceId)
//        ownerId = try values.decodeIfPresent(String.self, forKey: .ownerId)
//        configJson = try values.decodeIfPresent(String.self, forKey: .configJson)
//        subDevices = try values.decodeIfPresent([Device].self, forKey: .subDevices)
//    }
//    
//    public func encode(to encoder: Encoder) throws {
//         // 编码其他属性
//     }
    
    
    public init(uuid: String,ownerId: String){
        self.uuid = uuid
        self.ownerId = ownerId
    }
}
