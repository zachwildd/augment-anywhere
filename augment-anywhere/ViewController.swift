//
//  ViewController.swift
//  bitcamp-client
//
//  Created by zach on 4/13/19.
//  Copyright © 2019 zach. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {
    
    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // create new scene view
        let arSceneView = ARSceneView(frame: view.bounds)
        sceneView = arSceneView
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        view.addSubview(sceneView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        var referenceImages: Set<ARReferenceImage> = Set<ARReferenceImage>()
        let arImage = loadImage()
        referenceImages.insert(arImage)
        
        // Create a session configuration
        let configuration = ARImageTrackingConfiguration()
        
        configuration.trackingImages = referenceImages
        configuration.maximumNumberOfTrackedImages = 1
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    func loadImage() -> ARReferenceImage {
        let targetImage: UIImage = UIImage(named: "bitcamp")!
        let arImage = ARReferenceImage(targetImage.cgImage!, orientation: CGImagePropertyOrientation.up, physicalWidth: 0.15)
        arImage.name = "bitcamp"
        return arImage
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        
        // if out of target image has been ddetected then get corresponding anchor
        guard let currentImageAnchor = anchor as? ARImageAnchor else { return }
        
        // get targets name
        let name = currentImageAnchor.referenceImage.name!
        
        print("Image named \(name)")
        
        // create a box to add to the image
        let boxNode = SCNNode()
        let boxGeometry = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0)
        
        // make each side a different color
        let faceColours = [UIColor.red, UIColor.green, UIColor.blue, UIColor.cyan, UIColor.yellow, UIColor.gray]
        var faceMaterials = [SCNMaterial]()
        
        // apply color to each side
        for face in 0 ..< 5{
            let material = SCNMaterial()
            material.diffuse.contents = faceColours[face]
            faceMaterials.append(material)
        }
        boxGeometry.materials = faceMaterials
        boxNode.geometry = boxGeometry
        
        // set box position
        boxNode.position = SCNVector3(0, 0.05, 0)
        
        // add box to node
        node.addChildNode(boxNode)
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
