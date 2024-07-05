//
//  SdkErrorType.swift
//  XySmartSdk
//
//  Created by rocky on 2024/6/24.
//

import Foundation

//INSCAN("6006","device in scan"),
//DeviceOffline("5006", "网关离线"),
//DeviceInfoError("5007","网关信息错误"),
//ServerError("5000","调用服务失败"),
//DeviceNotFind("4006","未找到设备"),
//DeviceTypeError("4007","设备类型错误"),
//DeviceActivatedError("6001","设备已经激活"),
enum SdkErrorType {
    case TIMEOUT
    case INSCAN
    case DeviceOffline
    case DeviceInfoError
    case ServerError
    case DeviceNotFind
    case DeviceTypeError
    case DeviceActivatedError
    case BleConnectError
    case OtherError
    
    var code: Int {
        switch self {
        case .TIMEOUT:
            return 9009
        
        case .INSCAN:
            return 6006
        
        case .DeviceOffline:
            return 5006
        
        case .DeviceInfoError:
            return 5007
        
        case .ServerError:
            return 5000
        
        case .DeviceNotFind:
            return 4006
        
        case .DeviceTypeError:
            return 4007
        
        case .DeviceActivatedError:
            return 6001
        case .BleConnectError:
            return 3002
        case .OtherError:
            return 9999
        }
        
    }
    
    var message: String {
        switch self {
        case .TIMEOUT:
            return "Time out"
        case .INSCAN:
            return "device in scan"
        case .DeviceOffline:
            return "device is offline"
        case .DeviceInfoError:
            return "device info error"
        case .ServerError:
            return "server error"
        case .DeviceNotFind:
            return "device not find"
        case .DeviceTypeError:
            return "device type error"
        case .DeviceActivatedError:
            return "device is activated"
        case .BleConnectError:
            return "connect ble error"
        case .OtherError:
            return "other error"
        }
    }
}
