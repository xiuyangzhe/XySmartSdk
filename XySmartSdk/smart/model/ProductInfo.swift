//
//  ProductInfo.swift
//  XySmartDemo
//
//  Created by rocky on 2024/4/14.
//

import Foundation
public struct ProductInfo: Codable {
    public var id: String?
    public var createOn: Int64?
    public var updateOn: Int64?
    public var name:String?
    public var deviceType: String?
    public var icon: String?
    public var categoryName: String?
    public var functions: String?
    public var statusList: String?
}
