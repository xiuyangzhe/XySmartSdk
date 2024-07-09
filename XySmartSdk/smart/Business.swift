//
//  Business.swift
//  xysmart
//
//  Created by rocky on 2024/4/4.
//

import Foundation
import CocoaMQTT

class Business: NSObject {
    public var clientId: String = ""
    public var clientSecret: String = ""
    
    public static var Instance = Business()
    
    func initBusiness(clientId: String,
                      clientSecret: String,
                      onSuccess: @escaping () -> Void = {  },
                      onFailed: @escaping (SdkError) -> Void = { _ in }){
        
        NSLog("init initBusiness")
        
        self.clientId = clientId
        self.clientSecret = clientSecret
        
        mqttMessageInit(clientId:clientId,clientSecret:clientSecret)
        
        appLogin {
            onSuccess()
        } onFailed: { e in
            onFailed(e)
        }

    }
    
    private var serverUrl = "https://iot.greytechnology.top"
    private var token: String = ""
    
    func appLogin(onSuccess: @escaping () -> Void = {  }, onFailed: @escaping (SdkError) -> Void = { _ in }){
        // 创建URL对象
        let url = URL(string: serverUrl + "/api/appSdk/login")!

        // 创建URLSession对象
        let session = URLSession.shared

        // 创建请求对象
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue(clientId, forHTTPHeaderField: "clientId")
        request.addValue(clientSecret, forHTTPHeaderField: "clientSecret")
        
        let params = ["userName":"iosSdk"]
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
        } catch let error {
            print("Error serializing JSON: \(error.localizedDescription)")
        }

        // 添加请求头
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        // 创建一个数据任务
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                onFailed(SdkError(code: 5000, message: "request server error"))
            } else if let data = data {
                // 将返回的数据解析为JSON对象
                do{
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        if let code = json["code"] as? Int {
                            if(code != 200){
                                onFailed(SdkError(code: code, message: "request server error"))
                                return
                            }
                        }
                        // 获取 "data" 字典中的值
                        if let data = json["data"] as? [String: Any] {
                            // 获取 "token" 属性值
                            if let token = data["token"] as? String {
                                print("Token: \(token)")
                                self.token = token
                                onSuccess()
                                return
                            }
                        }
                        
                        onFailed(SdkError(code: 5000, message: "request server error"))
                        
                    }
                } catch let error {
                    onFailed(SdkError(code: 5000, message: "request server error"))
                }
            }
        }

        // 开始任务
        task.resume()
    }
    
    func activeDevice(uuid: String, homeId: String?, onSuccess: @escaping (Device) -> Void = { _ in  }, onFailed: @escaping (SdkError) -> Void = { _ in }){
        
        // 创建URL对象
        let url = URL(string: serverUrl + "/api/appSdk/activate")!

        // 创建URLSession对象
        let session = URLSession.shared

        // 创建请求对象
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue(clientId, forHTTPHeaderField: "clientId")
        request.addValue(clientSecret, forHTTPHeaderField: "clientSecret")
        request.addValue(token, forHTTPHeaderField: "Authorization")
        
        let params = ["uuid": uuid, "ownerId": homeId]
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
        } catch let error {
            print("Error serializing JSON: \(error.localizedDescription)")
        }

        // 添加请求头
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        // 创建一个数据任务
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                onFailed(SdkError(code: 5000, message: "request server error"))
            } else if let data = data {
                // 将返回的数据解析为JSON对象
                do{
//                    if let responseString = String(data: data, encoding: .utf8) {
//                            // 在这里使用转换后的字符串
//                        print("data: \(responseString)")
//                    }
                    
                    let decoder = JSONDecoder()
                    let result: DataResult<ActivateDeviceResult> = try decoder.decode(DataResult<ActivateDeviceResult>.self,from: data)
                    if let success = result.success {
                        if(success){
                            onSuccess(result.data!.device!)
                        }else{
                            let message = result.message
                            onFailed(SdkError(code: result.code!, message: message!))
                        }
                    }else{
                        onFailed(SdkError(code: 5000, message: "request server error"))
                    }
                } catch let error {
                    onFailed(SdkError(code: 5000, message: "request server error"))
                }
            }
        }

        // 开始任务
        task.resume()
    }
    
    func resetGateway(id: String, onSuccess: @escaping () -> Void = {  }, onFailed: @escaping (SdkError) -> Void = { _ in }){
        
        // 创建URL对象
        let url = URL(string: serverUrl + "/api/appSdk/resetGatewayByUUID/\(id)")!

        // 创建URLSession对象
        let session = URLSession.shared

        // 创建请求对象
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue(clientId, forHTTPHeaderField: "clientId")
        request.addValue(clientSecret, forHTTPHeaderField: "clientSecret")
        request.addValue(token, forHTTPHeaderField: "Authorization")

        // 添加请求头
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        // 创建一个数据任务
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                onFailed(SdkError(code: 5000, message: "request server error"))
            } else if let data = data {
                // 将返回的数据解析为JSON对象
                do{
//                    if let responseString = String(data: data, encoding: .utf8) {
//                            // 在这里使用转换后的字符串
//                        print("data: \(responseString)")
//                    }
                    
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        if let code = json["code"] as? Int {
                            if(code != 200){
                                let message = json["message"] as? String
                                onFailed(SdkError(code: 5000, message: message!))
                                return
                            }
                        }
                        onSuccess()
                        return
                    }
                } catch let error {
                    onFailed(SdkError(code: 5000, message: "request server error"))
                }
            }
        }

        // 开始任务
        task.resume()
    }
    
    
     let myDelegate = MyDelegate()
     
     let mqtt5 = CocoaMQTT5(clientID: "ios_" + String(ProcessInfo().processIdentifier), host: "iot.greytechnology.top")
     func mqttMessageInit(clientId: String,
                          clientSecret: String) {
        ///MQTT 5.0
        
        
        mqtt5.allowUntrustCACertificate = true
        let connectProperties = MqttConnectProperties()
        connectProperties.topicAliasMaximum = 0
        connectProperties.sessionExpiryInterval = 0
        connectProperties.receiveMaximum = 100
        connectProperties.maximumPacketSize = 500
        mqtt5.connectProperties = connectProperties

        mqtt5.username = clientId
        mqtt5.password = clientSecret
//        mqtt5.willMessage = CocoaMQTT5Message(topic: "/will", string: "dieout")
        mqtt5.keepAlive = 60
        mqtt5.delegate = myDelegate
        mqtt5.enableSSL = false
         mqtt5.cleanSession = true
        mqtt5.autoReconnect = true
//         mqtt5.didConnectAck = { ack, code, connAckData in
//             DispatchQueue.main.async {
//                 print("mqtt connected")
//             }
//             print("Did connect to MQTT server with ack: \(ack)")
//         }
         
        let result = mqtt5.connect(timeout: 5)
        Thread.sleep(forTimeInterval: 1.0)
        print(result)
    }
    func subTopic(topic: String){
        mqtt5.subscribe(topic, qos: CocoaMQTTQoS.qos1)
    }
    
    func unsubTopic(topic: String){
        mqtt5.unsubscribe(topic)
    }
    
    func bindDevice(info: BindDeviceInfo, onSuccess: @escaping (ActivateDeviceResult) -> Void = { _ in  }, onFailed: @escaping (SdkError) -> Void = { _ in }){
        
        // 创建URL对象
        let url = URL(string: serverUrl + "/api/appSdk/bind")!
        
        // 创建URLSession对象
        let session = URLSession.shared
        
        // 创建请求对象
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue(clientId, forHTTPHeaderField: "clientId")
        request.addValue(clientSecret, forHTTPHeaderField: "clientSecret")
        request.addValue(token, forHTTPHeaderField: "Authorization")
        
        // 添加请求头
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let params = ["uuid": info.uuid, "model": info.model,"gatewayUUId":info.gatewayUUId]
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
        } catch let error {
            print("Error serializing JSON: \(error.localizedDescription)")
        }
        
        // 创建一个数据任务
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                onFailed(SdkError(code: 5000, message: "request server error"))
            } else if let data = data {
                // 将返回的数据解析为JSON对象
                do{
                    //                    if let responseString = String(data: data, encoding: .utf8) {
                    //                            // 在这里使用转换后的字符串
                    //                        print("data: \(responseString)")
                    //                    }
                    let decoder = JSONDecoder()
                    let result: DataResult<ActivateDeviceResult> = try decoder.decode(DataResult<ActivateDeviceResult>.self,from: data)
                    if let success = result.success {
                        if(success){
                            onSuccess(result.data!)
                        }else{
                            let message = result.message
                            onFailed(SdkError(code: result.code!, message: message!))
                        }
                    }else{
                        onFailed(SdkError(code: 5000, message: "request server error"))
                    }
                    return
                } catch let error {
                    onFailed(SdkError(code: 5000, message: "request server error"))
                }
            }
        }
        
        // 开始任务
        task.resume()
    }
    func getMqttConfig(onSuccess: @escaping (MqttConfig) -> Void = { _ in  }, onFailed: @escaping (SdkError) -> Void = { _ in }){
        // 创建URL对象
        let url = URL(string: serverUrl + "/api/appSdk/mqttConfig")!

        // 创建URLSession对象
        let session = URLSession.shared

        // 创建请求对象
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue(clientId, forHTTPHeaderField: "clientId")
        request.addValue(clientSecret, forHTTPHeaderField: "clientSecret")
        request.addValue(token, forHTTPHeaderField: "Authorization")

        // 添加请求头
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        // 创建一个数据任务
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                onFailed(SdkError(code: 5000, message: "request server error"))
            } else if let data = data {
                // 将返回的数据解析为JSON对象
                do{
//                    if let responseString = String(data: data, encoding: .utf8) {
//                            // 在这里使用转换后的字符串
//                        print("data: \(responseString)")
//                    }
                    let decoder = JSONDecoder()
                    let result: DataResult<MqttConfig> = try decoder.decode(DataResult<MqttConfig>.self,from: data)
                    if let success = result.success {
                        if(success){
                            onSuccess(result.data!)
                        }else{
                            let message = result.message
                            onFailed(SdkError(code: result.code!, message: message!))
                        }
                    }else{
                        onFailed(SdkError(code: 5000, message: "request server error"))
                    }
                    return
                } catch let error {
                    onFailed(SdkError(code: 5000, message: "request server error"))
                }
            }
        }

        // 开始任务
        task.resume()
    }
    
    func startDeviceScan(seconds: Int,id: String, onSuccess: @escaping (StartDeviceScanResult) -> Void = { _ in  }, onFailed: @escaping (SdkError) -> Void = { _ in }){
        
        // 创建URL对象
        let url = URL(string: serverUrl + "/api/appSdk/startDeviceScanByUUID/\(id)")!

        // 创建URLSession对象
        let session = URLSession.shared

        // 创建请求对象
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue(clientId, forHTTPHeaderField: "clientId")
        request.addValue(clientSecret, forHTTPHeaderField: "clientSecret")
        request.addValue(token, forHTTPHeaderField: "Authorization")

        // 添加请求头
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let params = ["seconds": seconds]
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
        } catch let error {
            print("Error serializing JSON: \(error.localizedDescription)")
        }
        

        // 创建一个数据任务
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                onFailed(SdkError(code: 5000, message: "request server error"))
            } else if let data = data {
                // 将返回的数据解析为JSON对象
                do{
//                    if let responseString = String(data: data, encoding: .utf8) {
//                            // 在这里使用转换后的字符串
//                        print("data: \(responseString)")
//                    }
                    let decoder = JSONDecoder()
                    let result: DataResult<StartDeviceScanResult> = try decoder.decode(DataResult<StartDeviceScanResult>.self,from: data)
                    if let success = result.success {
                        if(success){
                            onSuccess(result.data!)
                        }else{
                            let message = result.message
                            onFailed(SdkError(code: result.code!, message: message!))
                        }
                    }else{
                        onFailed(SdkError(code: 5000, message: "request server error"))
                    }
                    return
                } catch let error {
                    onFailed(SdkError(code: 5000, message: "request server error"))
                }
            }
        }

        // 开始任务
        task.resume()
    }
    
    func stopDeviceScan(uuid: String, onSuccess: @escaping (StartDeviceScanResult) -> Void = { _ in  }, onFailed: @escaping (SdkError) -> Void = { _ in }){
        
        // 创建URL对象
        let url = URL(string: serverUrl + "/api/appSdk/stopDeviceScanByUUID/\(uuid)")!

        // 创建URLSession对象
        let session = URLSession.shared

        // 创建请求对象
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue(clientId, forHTTPHeaderField: "clientId")
        request.addValue(clientSecret, forHTTPHeaderField: "clientSecret")
        request.addValue(token, forHTTPHeaderField: "Authorization")

        // 添加请求头
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        // 创建一个数据任务
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                onFailed(SdkError(code: 5000, message: "request server error"))
            } else if let data = data {
                // 将返回的数据解析为JSON对象
                do{
//                    if let responseString = String(data: data, encoding: .utf8) {
//                            // 在这里使用转换后的字符串
//                        print("data: \(responseString)")
//                    }
                    let decoder = JSONDecoder()
                    let result: DataResult<StartDeviceScanResult> = try decoder.decode(DataResult<StartDeviceScanResult>.self,from: data)
                    if let success = result.success {
                        if(success){
                            onSuccess(result.data!)
                        }else{
                            let message = result.message
                            onFailed(SdkError(code: result.code!, message: message!))
                        }
                    }else{
                        onFailed(SdkError(code: 5000, message: "request server error"))
                    }
                    return
                } catch let error {
                    onFailed(SdkError(code: 5000, message: "request server error"))
                }
            }
        }

        // 开始任务
        task.resume()
    }
}
