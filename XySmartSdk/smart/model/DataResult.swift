//
//  DataResult.swift
//  XySmartDemo
//
//  Created by rocky on 2024/4/18.
//

import Foundation
struct DataResult<T: Codable>: Codable  {
    var data: T?
    var message: String?
    var success: Bool?
    var code: Int?
    
//    enum CodingKeys: String, CodingKey {
//
//        case data = "data"
//        case message = "message"
//        case success = "success"
//        case code = "code"
//    }
//    
//    public required init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        data = try values.decodeIfPresent(T.self, forKey: .data)
//        message = try values.decodeIfPresent(String.self, forKey: .message)
//        success = try values.decodeIfPresent(Bool.self, forKey: .success)
//        code = try values.decodeIfPresent(Int.self, forKey: .code)
//    }
//    
//    public func encode(to encoder: Encoder) throws {
//         // 编码其他属性
//     }
}

