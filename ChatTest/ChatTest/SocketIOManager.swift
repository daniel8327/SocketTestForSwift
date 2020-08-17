//
//  SocketIOManager.swift
//  ChatTest
//
//  Created by 장태현 on 2020/08/16.
//  Copyright © 2020 장태현. All rights reserved.
//

import Foundation
import SocketIO
import SwiftyJSON

class SocketIOManager: NSObject {
    static let shared = SocketIOManager()
    var manager = SocketManager(socketURL: URL(string: "http://localhost:3000")!, config: [.log(true), .compress])
    var socket: SocketIOClient!
    
    override init() {
        super.init()
        //socket = self.manager.socket(forNamespace: "/test")
        socket = self.manager.defaultSocket
//        
//        socket.on(clientEvent: .connect) { (dataArray, ack) in
//            print("socket connected")
//        }
//        socket.on("test") { dataArray, socketEmitter in
//            
//            print("==========1========")
//            print(dataArray)
//        }
//        
//        socket.on("msg") { (data, ack) in
//        print("==========2========")
//            print(data)
//        }
//        
//        socket.on("newChatMessage") { (data, ack) in
//        print("==========newChatMessage========")
//            print(data)
//        }
//        
//        socket.connect()
//        self.socket.on("test") { dataArray, socketAckEmitter in
//
//            var chat = ChatType()
//
//            print("==================")
//            print(type(of: dataArray))
//            let data = dataArray[0] as! NSDictionary
//
//            chat.type = data["type"] as! Int
//            chat.message = data["message"] as! String
//            
//            self.textView.text += chat.message
//
//            print(chat)
//
////            self.updateChat(count: self.myChat.count) {
////                print("get message")
////            }
//        }
    }
    
    
    func establishConnection() {
        socket.connect()
    }
    
    
    func closeConnection() {
        socket.disconnect()
    }
    
    func sendMessage(message: String, nickName: String) {
//        socket.emit("event", ["message": "This is a test Message"])
//        socket.emit("event1", [["name" : "ns"], ["email" : "@naver.com"]])
//        socket.emit("event2", ["name" : "ns", "email" : "@naver.com"])
        //socket.emit("msg", ["nick": nickName, "msg" : message])
        socket.emit("chatMessage", nickName, message)
    }
    
    func connectToServerWithNickname(nickname: String, completionhandler: @escaping(_ userList: [[String: AnyObject]]) -> Void) {
        
        socket.emit("connectUser", nickname)
        
        socket.on("userList") { datas, ack in
            
            let aaa = datas[0] as! [[String: AnyObject]]
            print("aaa \(aaa)")
            
//            print("aa \(JSON(datas[0]))")
//            
//            struct Response: Decodable {
//                let users: [User]
//            }
//
//            let aa = try! JSONSerialization.data(withJSONObject: datas[0])
//            
//            print("aa \(aa)")
//            print("aa \(JSON(aa))")
//            
//            let response = try! JSONDecoder().decode(Response.self, from: aa)
//            
//            print("aa \(response.users)")
            completionhandler(aaa)
        }
        
        listenForOtherMessages()
    }
    
    private func listenForOtherMessages() {
        socket.on("userConnectUpdate") { (dataArray, socketAck) -> Void in
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "userWasConnectedNotification"), object: dataArray[0] as! [String: AnyObject])
        }
        
        socket.on("userExitUpdate") { (dataArray, socketAck) -> Void in
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "userWasDisconnectedNotification"), object: dataArray[0] as! String)
        }
        
        socket.on("userTypingUpdate") { (dataArray, socketAck) -> Void in
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "userTypingNotification"), object: dataArray[0] as! [String: AnyObject])
        }
    }
    
    func sendStartTypingMessage(nickname: String) {
        socket.emit("startType", nickname)
    }
    
    func sendStopTypingMessage(nickname: String) {
        socket.emit("stopType", nickname)
    }
    
    func getChatMessage(completionHandler: @escaping(_ messageInfo: [String: String]) -> Void) {
        socket.on("newChatMessage") { (dataArray, socketAck) -> Void in
            
            var messageDictionary = [String: String]()
            messageDictionary["nickname"] = dataArray[0] as? String
            messageDictionary["message"] = dataArray[1] as? String
            messageDictionary["date"] = dataArray[2] as? String
            
            completionHandler(messageDictionary)
        }
    }
    
    func exitChatWithNickname(nickname: String, completionHandler: () -> Void) {
        socket.emit("exitUser", nickname)
        completionHandler()
    }
    
    func sendMessage(message: String, withNickname nickname: String) {
        socket.emit("chatMessage", nickname, message)
    }
}
