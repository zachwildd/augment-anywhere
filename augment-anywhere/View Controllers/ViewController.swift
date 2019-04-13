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

class ViewController: UIViewController, ARSCNViewDelegate, ConnectionDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // ar view
    @IBOutlet var sceneView: ARSCNView!
    
    // buttons
    var backButton: UIButton = UIButton()
    var addTargetButton: UIButton = UIButton()
    
    // image picker
    var imagePicker: UIImagePickerController?
    
    var referenceImages: Set<ARReferenceImage> = Set<ARReferenceImage>()
    
    var connectionHandler: ConnectionHandler = ConnectionHandler.sharedInstance
    
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
        
        connectionHandler.delegate = self
        connectionHandler.socket.write(string: "hey fucker")
        connectionHandler.mockRecieveNewTargetMessage()
        connectionHandler.mockRecieveSecondTargetMessage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARImageTrackingConfiguration()
        
        configuration.trackingImages = referenceImages
        configuration.maximumNumberOfTrackedImages = 2
        
        // Run the view's session
        sceneView.session.run(configuration)
        
        setupUI()
        setupActions()
    }
    
    func didRecieveTarget(base64: String) {
        
        let imageDecoded:NSData = NSData(base64Encoded: base64, options: NSData.Base64DecodingOptions(rawValue: 0))!
        let decodedimage:UIImage = UIImage(data: imageDecoded as Data)!
        
        addTarget(image: decodedimage)
    }
    
    func loadImage(image: UIImage) -> ARReferenceImage {
        let targetImage: UIImage = UIImage(named: "bitcamp")!
        let arImage = ARReferenceImage(targetImage.cgImage!, orientation: CGImagePropertyOrientation.up, physicalWidth: 0.15)
        arImage.name = "bitcamp"
        return arImage
    }
    
    var name = "1"
    func addTarget(image: UIImage) {
        let arImage = ARReferenceImage(image.cgImage!, orientation: CGImagePropertyOrientation.up, physicalWidth: 0.15)
        arImage.name = name
        name = "2"
        referenceImages.insert(arImage)
        resetTracking()
    }
    
    func resetTracking() {
        // Create a session configuration
        let configuration = ARImageTrackingConfiguration()
        
        configuration.trackingImages = referenceImages
        configuration.maximumNumberOfTrackedImages = 2
        
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    func setupUI() {
        print("arsceneview setup")
        
        // setup back button
        backButton.backgroundColor = UIColor.red
        backButton.autoSetDimension(.height, toSize: 100)
        backButton.autoSetDimension(.width, toSize: 100)
        view?.addSubview(backButton)
        backButton.autoPinEdge(.left, to: .left, of: view, withOffset: 10)
        backButton.autoPinEdge(.top, to: .top, of: view, withOffset: 10)
        
        // setup add target button
        addTargetButton.backgroundColor = UIColor.gray
        addTargetButton.autoSetDimension(.height, toSize: 100)
        addTargetButton.autoSetDimension(.width, toSize: 100)
        view?.addSubview(addTargetButton)
        addTargetButton.autoPinEdge(.bottom, to: .bottom, of: view, withOffset: 10)
        addTargetButton.autoPinEdge(.right, to: .right, of: view, withOffset: 10)
    }
    
    func setupActions() {
        backButton.addTarget(self, action: #selector(presentLoginVC), for: .touchUpInside)
        addTargetButton.addTarget(self, action: #selector(pressAddTarget), for: .touchUpInside)
    }
    
    @objc func presentLoginVC() {
        performSegue(withIdentifier: "loginVC", sender: self)
    }
    
    @objc func pressAddTarget() {
        print("press add target")
        // pull up camera to take picture of target
        // performSegue(withIdentifier: "showAddTarget", sender: self)
        
        imagePicker =  UIImagePickerController()
        imagePicker!.delegate = self
        imagePicker!.sourceType = .camera

        present(imagePicker!, animated: true, completion: nil)
    }
    
    // implement UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imagePicker!.dismiss(animated: true, completion: nil)
        let newTarget = info[.originalImage] as? UIImage
        addTarget(image: newTarget!)
    }
    
    func createPlane() -> SCNNode {
        
        var planeMaterials = [SCNMaterial]()
        let planeMaterial = SCNMaterial()
        planeMaterial.diffuse.contents = UIColor.black
        planeMaterials.append(planeMaterial)
        
        var textMaterials = [SCNMaterial]()
        let textMaterial = SCNMaterial()
        textMaterial.diffuse.contents = UIColor.white
        textMaterials.append(textMaterial)
        
        // create plane
        let planeBase = SCNNode()
        let planeGeometry = SCNPlane(width: 0.15, height: 0.15)
        planeGeometry.materials = planeMaterials
        planeBase.geometry = planeGeometry
        planeBase.position = SCNVector3(0, 0.05, 0)
        planeBase.name = "plane"
        
        // create text
        let textBase = SCNNode()
        let textGeometry = SCNText(string: "hello world", extrusionDepth: 1)
        textGeometry.materials = textMaterials
        textBase.scale = SCNVector3(0.001, 0.001, 0.001)
        textBase.geometry = textGeometry
        textBase.position = planeBase.worldPosition
        textBase.name = "text"
        
        // create side plane
        var sidePlaneMaterials = [SCNMaterial]()
        let sidePlaneMaterial = SCNMaterial()
        sidePlaneMaterial.diffuse.contents = UIColor.gray
        sidePlaneMaterials.append(sidePlaneMaterial)
        
//        let sidePlaneBase = SCNNode()
//        let sidePlaneGeometry = SCNPlane(width: 0.15, height: 0.15)
//        sidePlaneGeometry.materials = sidePlaneMaterials
//        sidePlaneBase.geometry = sidePlaneGeometry
//        sidePlaneBase.position = SCNVector3(0.15, 0, 0)
//        sidePlaneBase.rotation = SCNVector4(0, 0.5, 0.2, 0)
//        sidePlaneBase.name = "side-plane"
        
        // add add-plane button
        let addPlaneButtonBase = SCNNode()
        let addPlaneButtonGeometry = SCNPlane(width: 0.025, height: 0.025)
        addPlaneButtonGeometry.materials = sidePlaneMaterials
        addPlaneButtonBase.geometry = addPlaneButtonGeometry
        addPlaneButtonBase.position = SCNVector3(0, 0, 0.01)
        addPlaneButtonBase.name = "add-plane-button"
        
        planeBase.addChildNode(addPlaneButtonBase)
        planeBase.addChildNode(textBase)
//        planeBase.addChildNode(sidePlaneBase)
        
        return planeBase
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        
        // if out of target image has been ddetected then get corresponding anchor
        guard let currentImageAnchor = anchor as? ARImageAnchor else { return }
        
        // get targets name
        let name = currentImageAnchor.referenceImage.name!
        
        print("Image named \(name)")
        
//        let base = SCNNode()
//        let baseGeometry = SCNText(string: "text", extrusionDepth: 10)
//        let material = SCNMaterial()
//        material.diffuse.contents = UIColor.blue
//        baseGeometry.materials = [material]
//        base.geometry = baseGeometry
//        base.position = SCNVector3(0, 0.05, 0)
//        node.addChildNode(base)
        
        // make each side a different color
        let faceColours = [UIColor.red, UIColor.green, UIColor.blue, UIColor.cyan, UIColor.yellow, UIColor.gray]
        var faceMaterials = [SCNMaterial]()
        
        // apply color to each side
        for face in 0 ..< 5{
            let material = SCNMaterial()
            material.diffuse.contents = faceColours[face]
            faceMaterials.append(material)
        }
        
        let plane: SCNNode = createPlane()
        node.addChildNode(plane)
        
        // create a box to add to the image
        let boxNode = SCNNode()
        let boxGeometry = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0)
        boxGeometry.materials = faceMaterials
        boxNode.geometry = boxGeometry
        // set box position
        boxNode.position = SCNVector3(0, 0.05, 0)
        // add box to node
        //node.addChildNode(boxNode)
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
