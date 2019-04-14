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
import UIKit

protocol ConnectionDelegate {
    func didRecieveTarget(base64: String)
}

class ConnectionHandler: WebSocketDelegate {
    
    // singleton
    static let sharedInstance = ConnectionHandler()
    
    // all scenes
    var scenes : [String: CubeScene] = [String: CubeScene]()
    
    // TODO: do core data stuff
    
    // create websocket connection to localhost server
    let socket = WebSocket(url: URL(string: "ws://sodium-lodge-237501.appspot.com")!, protocols: ["chat"])
//    let socket = WebSocket(url: URL(string: "ws://localhost:8080")!, protocols: ["chat"])
    
    // designate delegate
    var delegate: ConnectionDelegate?
    
    init() {
        print("creating connection handler")
        
        socket.delegate = self
        socket.connect()
    }
    
    func sendMessage(message: String) {
        socket.write(string: message)
    }
    
    func websocketDidConnect(socket: WebSocketClient) {
        // do nothing?
        print("connected to server")
        
    }
    
    // TODO: remove mock for tseting
    func mockRecieveNewTargetMessage() {
        print("mock recieve new target")
        let image = UIImage(named: "bitcamp")
        let imageData = image!.pngData()
        let base64Str = imageData?.base64EncodedString()
        delegate?.didRecieveTarget(base64: base64Str!)
    }
    
    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        // TODO: handle disconnects
    }
    
    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        // we aren't going to do anything with binary streams
    }
    
    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        print("recieved message")
        
        guard let data = text.data(using: .utf8) else {
            // TODO: make this fatal
            
            return
        }
        
        let json = try? JSON(data: data)
        
        let type = json!["type"]
        
        switch type {
        case "add-cube":
            print("got add-cube")
            let data: JSON = json!["data"]
            let sceneID = data["scene_id"].int!
            let x = data["x"].int!
            let y = data["y"].int!
            let z = data["z"].int!
            let color = data["color"].int!
            scenes[String(sceneID)]?.addCube(x: Double(x), y: Double(y), z: Double(z), color: UIColor.purple)
            
        case "state":
            print("state recieved")
            let data: JSON = json!["data"]
            let targets = data["targets"].array
            for target in targets! {
                let targetID = target["target_id"].int!
                let scene: JSON = target["scene"]
                let map = scene["map"].array!
                print(map)
                
                let newCubeScene = CubeScene(json: scene)
                scenes[String(targetID)] = newCubeScene
                print(newCubeScene)
                
            }
            
            
        default:
            print("defaulted")
        }
        
        print("recieved message from server : \(data)")
    }
}
