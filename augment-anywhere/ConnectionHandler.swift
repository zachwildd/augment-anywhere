//
//  ConnectionHandler.swift
//  augment-anywhere
//
//  Created by zach on 4/13/19.
//  Copyright © 2019 zach. All rights reserved.
//

import Foundation
import Starscream
import SwiftyJSON

protocol ConnectionDelegate {
    func didRecieveMessage(type: String, data: JSON)
}

class ConnectionHandler: WebSocketDelegate {
    
    // singleton
    static let sharedInstance = ConnectionHandler()
    
    // TODO: do core data stuff
    
    // create websocket connection to localhost server
    let socket = WebSocket(url: URL(string: "ws://localhost:1337")!, protocols: ["chat"])
    
    // designate delegate
    var delegate: ConnectionDelegate?
    
    init() {
        print("creating connection handler")
        
        socket.delegate = self
        socket.connect()
    }
    
    func websocketDidConnect(socket: WebSocketClient) {
        // do nothing?
        print("connected to server")
        socket.write(string: "hello server")
    }
    
    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        // TODO: handle disconnects
    }
    
    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        // we aren't going to do anything with binary streams
    }
    
    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        
        guard let data = text.data(using: .utf8) else {
            // TODO: make this fatal
            
            return
        }
        
        print("recieved message from client : \(data)")
    }
}
