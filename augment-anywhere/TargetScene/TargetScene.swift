//
//  TargetScene.swift
//  augment-anywhere
//
//  Created by zach on 4/13/19.
//  Copyright © 2019 zach. All rights reserved.
//

import Foundation
import ARKit
import SwiftyJSON

class TargetScene {
    
    var root: SCNNode?
    var treeDataJSON: JSON
    var trackingImage: ARReferenceImage?
    var name: String
    
    init(json: JSON, name: String) {
        self.treeDataJSON = json
        self.name = name
    }
    
    func encode() -> JSON {
        return JSON()
    }
    
    func buildScene() -> SCNNode {
        
        // use the json to build the scene
        var planeMaterials = [SCNMaterial]()
        let planeMaterial = SCNMaterial()
        planeMaterial.diffuse.contents = UIColor.black
        planeMaterials.append(planeMaterial)
        
        var textMaterials = [SCNMaterial]()
        let textMaterial = SCNMaterial()
        textMaterial.diffuse.contents = UIColor.white
        textMaterials.append(textMaterial)
        
        // create plane
        root = SCNNode()
        let planeGeometry = SCNPlane(width: 0.15, height: 0.15)
        planeGeometry.materials = planeMaterials
        root!.geometry = planeGeometry
        root!.position = SCNVector3(0, 0.05, 0)
        root!.name = "plane"
        
        // create text
        let textBase = SCNNode()
        let textGeometry = SCNText(string: "hello world", extrusionDepth: 1)
        textGeometry.materials = textMaterials
        textBase.scale = SCNVector3(0.001, 0.001, 0.001)
        textBase.geometry = textGeometry
        textBase.position = root!.worldPosition
        textBase.name = "text"
        
        // create side plane
        var sidePlaneMaterials = [SCNMaterial]()
        let sidePlaneMaterial = SCNMaterial()
        sidePlaneMaterial.diffuse.contents = UIColor.gray
        sidePlaneMaterials.append(sidePlaneMaterial)
        
        let sidePlaneBase = SCNNode()
        let sidePlaneGeometry = SCNPlane(width: 0.15, height: 0.15)
        sidePlaneGeometry.materials = sidePlaneMaterials
        sidePlaneBase.geometry = sidePlaneGeometry
        sidePlaneBase.position = SCNVector3(0.15, 0, 0)
        sidePlaneBase.rotation = SCNVector4(0, 0.5, 0.2, 0)
        sidePlaneBase.name = "side-plane"
        
        // add add-plane button
        let addPlaneButtonBase = SCNNode()
        let addPlaneButtonGeometry = SCNPlane(width: 0.025, height: 0.025)
        addPlaneButtonGeometry.materials = sidePlaneMaterials
        addPlaneButtonBase.geometry = addPlaneButtonGeometry
        addPlaneButtonBase.position = SCNVector3(0, 0, 0.01)
        addPlaneButtonBase.name = "add-plane-button"
        
        root!.addChildNode(addPlaneButtonBase)
        root!.addChildNode(textBase)
        root!.addChildNode(sidePlaneBase)
        
        return root!
        
    }
    
    
}
