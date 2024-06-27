//
//  SdkError.swift
//  XySmartDemo
//
//  Created by rocky on 2024/4/4.
//

import Foundation

public class SdkError : NSObject {
    // 定义错误码和错误信息属性
     public var code: Int
     public var message: String
     
     // 初始化方法
     public init(code: Int, message: String) {
         self.code = code
         self.message = message
     }
}
