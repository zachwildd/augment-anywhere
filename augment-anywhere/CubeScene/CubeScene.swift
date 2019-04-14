//
//  CubeScene.swift
//  augment-anywhere
//
//  Created by zach on 4/13/19.
//  Copyright © 2019 zach. All rights reserved.
//

import Foundation
import ARKit
import SwiftyJSON

class CubeScene {
    
    var root: SCNNode?
    var trackingImage: ARReferenceImage?
    var cubeMap: [[[Int]]]
    var targetID: Int
    var sceneID: Int
    
    // LOAD THIS
    var sceneId: Int = 0
    
    // allow to change with button and sshit
    
    init(json: JSON) {
        let map = json["map"].arrayObject as! [[[Int]]]
        self.cubeMap = map
        
        let targetID = json["target_id"].int!
        self.targetID = targetID
        self.sceneID = targetID
    }
    
    init(json: JSON, name: String) {
         print("init cubescene")
        self.cubeMap = Array(repeating: Array(repeating: Array(repeating: 0, count: 5), count: 5), count: 5)
        self.targetID = 0
        self.sceneID = targetID
    }
    
    init(name: String, trackingImage: UIImage) {
        // do something with tracking image
        self.cubeMap = Array(repeating: Array(repeating: Array(repeating: 0, count: 5), count: 5), count: 5)
        self.targetID = 0
        self.sceneID = targetID
    }
    
    // init from json map
    
    
    func buildScene() -> SCNNode {
        print("building cubescene")
        
        // create root plane
        var planeMaterials = [SCNMaterial]()
        let planeMaterial = SCNMaterial()
        planeMaterial.diffuse.contents = UIColor.white
        planeMaterials.append(planeMaterial)
        
        root = SCNNode()
        let planeGeometry = SCNPlane(width: 0.001, height: 0.001)
        planeGeometry.materials = planeMaterials
        root!.geometry = planeGeometry
        root!.position = SCNVector3(0, 0, 0)
        root!.name = "root"
        
        
        
        
        cubeMap[0][0][0] = 1
        
        // add boxes from map
        var z_ind = 0
        var y_ind = 0
        var x_ind = 0
        for z in cubeMap {
            
            for xy in z {
                for x in xy {
                    print(x)
                    
                    if (x == 1) {
                        
                        addCube(x: Double(x_ind), y: Double(y_ind), z: Double(z_ind), color: UIColor.gray)
                        
                    }
                    
                    x_ind += 1
                }
                
                print(" ")
                
                y_ind += 1
            }
            
            print("-----------------")
            
            z_ind += 1
        }
        
        return root!
    }
    
    func addCube(x: Double, y: Double, z: Double, color: UIColor) {
         print("addcube called")
        
        
        // create cube
        let front = SCNMaterial()
        front.diffuse.contents = color
        let right = SCNMaterial()
        right.diffuse.contents = color
        let back = SCNMaterial()
        back.diffuse.contents = color
        let left = SCNMaterial()
        left.diffuse.contents = color
        let top = SCNMaterial()
        top.diffuse.contents = color
        let bottom = SCNMaterial()
        bottom.diffuse.contents = color
        let cubeMaterials = [ front, right, back, left, top, bottom ]
        
        // create a box to add to the image
        let cubeNode = SCNNode()
        let cubeGeometry = SCNBox(width: 0.025, height: 0.025, length: 0.025, chamferRadius: 0)
        cubeGeometry.materials = cubeMaterials
        cubeNode.geometry = cubeGeometry
        // set box position
        cubeNode.position = SCNVector3(0 + (x*0.025), 0.025 + (y*0.025), 0 + (z*0.025))
        
        cubeNode.name = "cube,\(Int(x)),\(Int(y)),\(Int(z))"

        root!.addChildNode(cubeNode)
        
        // send a message to the ws ab adding a
        
        
        sendAddCube(x: Int(x), y: Int(y), z: Int(z), color: 0)
    }
    
    func sendAddCube(x: Int, y: Int, z: Int, color: Int) {
        print("send addcube")
        // color is 0-9
        // figure out .... so much garbage code
        
        let json: JSON =  ["type": "add-cube", "data": ["target_id":sceneId,"x":Int(x),"y":Int(y),"z":Int(z),"color":1]]
        
        ConnectionHandler.sharedInstance.sendMessage(message: json.rawString()!)
    }
    
//    func buildScene() -> SCNNode {
//
//        // create root plane
//        var planeMaterials = [SCNMaterial]()
//        let planeMaterial = SCNMaterial()
//        planeMaterial.diffuse.contents = UIColor.white
//        planeMaterials.append(planeMaterial)
//
//        root = SCNNode()
//        let planeGeometry = SCNPlane(width: 0.001, height: 0.001)
//        planeGeometry.materials = planeMaterials
//        root!.geometry = planeGeometry
//        root!.position = SCNVector3(0, 0, 0)
//        root!.name = "root"
//
//
//        // create cube
//        var cubeMaterials = [SCNMaterial]()
//        let cubeMaterial = SCNMaterial()
//        cubeMaterial.diffuse.contents = UIColor.black
//        cubeMaterials.append(cubeMaterial)
//
//        // create a box to add to the image
//        let cubeNode = SCNNode()
//        let cubeGeometry = SCNBox(width: 0.025, height: 0.025, length: 0.025, chamferRadius: 0)
//        cubeGeometry.materials = cubeMaterials
//        cubeNode.geometry = cubeGeometry
//        // set box position
//        cubeNode.position = SCNVector3(0, 0.025, 0)
//
//        root!.addChildNode(cubeNode)
//
//        return root!
//
//    }
    
    
}
