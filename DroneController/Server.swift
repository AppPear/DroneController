//
//  Server.swift
//  DroneController
//
//  Created by Samu András on 2019. 10. 10..
//  Copyright © 2019. Samu András. All rights reserved.
//

import Foundation
import Starscream

class DroneServer: WebSocketDelegate {
    let socket:WebSocket
    let encoder = JSONEncoder()
    init() {
        self.socket = WebSocket(url: URL(string: "ws://192.168.132.130:8000")!)
        socket.delegate = self
        socket.connect()
    }
    
    func sendData(data: DataModel) {
        do {
            let encodedData = try encoder.encode(data)
            let text = String(data: encodedData, encoding: .utf8)!
            socket.write(string: text)
        } catch {
            print ("\(error.localizedDescription)")
        }
    }
        
    func websocketDidConnect(socket: WebSocketClient) {
        print("Connected")
    }
    
    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        
    }
    
    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        
    }
    
    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        
    }
}
