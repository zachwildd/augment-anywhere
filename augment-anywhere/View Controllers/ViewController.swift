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
import SwiftyJSON

class ViewController: UIViewController, ARSCNViewDelegate, ConnectionDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var connectionHandler: ConnectionHandler = ConnectionHandler.sharedInstance
    
    // UI
    // ar view
    @IBOutlet var sceneView: ARSCNView!
    // buttons
    var backButton: UIButton = UIButton()
    var addTargetButton: UIButton = UIButton()
    var sidePlaneBase: SCNNode?
    
    var redButton: UIButton = UIButton()
    var greenButton: UIButton = UIButton()
    var blueButton: UIButton = UIButton()
    var grayButton: UIButton = UIButton()
    
    // image picker
    var imagePicker: UIImagePickerController?
    
    var bottombar: UIView = UIView()
    
    
    let screenSize = UIScreen.main.bounds
    
    // DATA
    // scenes
    // has all tracking images, and the associated scenes
    var scenes: [String: CubeScene] = ConnectionHandler.sharedInstance.scenes
    var currentScene: CubeScene?
    
    var currentColor: UIColor = UIColor.blue
    
    // targets
    var referenceImages: Set<ARReferenceImage> = Set<ARReferenceImage>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // create new scene view
        let arSceneView = ARSceneView(frame: view.bounds)
        sceneView = arSceneView
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        sceneView.autoenablesDefaultLighting = true
        
        view.addSubview(sceneView)
        
        ConnectionHandler.sharedInstance.delegate = self
        connectionHandler.mockRecieveNewTargetMessage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARImageTrackingConfiguration()
        
        configuration.trackingImages = referenceImages
        configuration.maximumNumberOfTrackedImages = 1
        
        // Run the view's session
        sceneView.session.run(configuration)
        
        setupUI()
        setupActions()
    }
    
    func didRecieveTarget(base64: String) {
        
        let imageDecoded:NSData = NSData(base64Encoded: base64, options: NSData.Base64DecodingOptions(rawValue: 0))!
        let decodedimage:UIImage = UIImage(data: imageDecoded as Data)!
        
        addTarget(image: decodedimage, name: "0")
    }
    
    func loadImage(image: UIImage) -> ARReferenceImage {
        let targetImage: UIImage = UIImage(named: "bitcamp")!
        let arImage = ARReferenceImage(targetImage.cgImage!, orientation: CGImagePropertyOrientation.up, physicalWidth: 0.15)
        arImage.name = "0"
        return arImage
    }
    
    //
    func addTarget(image: UIImage, name: String) {
        let arImage = ARReferenceImage(image.cgImage!, orientation: CGImagePropertyOrientation.up, physicalWidth: 0.15)
        arImage.name = name
        referenceImages.insert(arImage)
        resetTracking()
        scenes[name] = CubeScene(json: JSON(), name: name)
    }
    
    // adds new tracking images to images actively tracked
    func resetTracking() {
        // Create a session configuration
        let configuration = ARImageTrackingConfiguration()
        
        configuration.trackingImages = referenceImages
        configuration.maximumNumberOfTrackedImages = 1
        
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
        backButton.autoSetDimension(.height, toSize: 40)
        backButton.autoSetDimension(.width, toSize: 100)
        view?.addSubview(backButton)
        backButton.autoPinEdge(.left, to: .left, of: view, withOffset: 10)
        backButton.autoPinEdge(.top, to: .top, of: view, withOffset: 40)
        
        let backlabel: UILabel = UILabel()
        backlabel.text = "Back"
        backlabel.textColor = UIColor.black
        backlabel.font = UIFont(name: "Helvetica", size: 18)
        backButton.addSubview(backlabel)
        
        // setup bottom bar
        bottombar.backgroundColor = UIColor.white
        bottombar.autoSetDimension(.width, toSize: screenSize.width)
        bottombar.autoSetDimension(.height, toSize: 120)
        view?.addSubview(bottombar)
        bottombar.autoPinEdge(.bottom, to: .bottom, of: view!)
        bottombar.autoPinEdge(.left, to: .left, of: view!)
        
        // setup add target button
        addTargetButton.backgroundColor = UIColor.gray
        addTargetButton.autoSetDimension(.height, toSize: 80)
        addTargetButton.autoSetDimension(.width, toSize: 80)
        view?.addSubview(addTargetButton)
        addTargetButton.autoPinEdge(.top, to: .top, of: bottombar, withOffset: 10)
        addTargetButton.autoPinEdge(.right, to: .right, of: view, withOffset: -20)
        
        // setup red button
        redButton.backgroundColor = UIColor.red
        redButton.autoSetDimension(.height, toSize: 50)
        redButton.autoSetDimension(.width, toSize: 50)
        view?.addSubview(redButton)
        redButton.autoPinEdge(.top, to: .top, of: bottombar, withOffset: 10)
        redButton.autoPinEdge(.left, to: .left, of: view, withOffset: 10)
        
        // setup
        greenButton.backgroundColor = UIColor.green
        greenButton.autoSetDimension(.height, toSize: 50)
        greenButton.autoSetDimension(.width, toSize: 50)
        view?.addSubview(greenButton)
        greenButton.autoPinEdge(.top, to: .top, of: bottombar, withOffset: 10)
        greenButton.autoPinEdge(.left, to: .right, of: redButton, withOffset: 10)
        
        // setup add target button
        blueButton.backgroundColor = UIColor.blue
        blueButton.autoSetDimension(.height, toSize: 50)
        blueButton.autoSetDimension(.width, toSize: 50)
        view?.addSubview(blueButton)
        blueButton.autoPinEdge(.top, to: .top, of: bottombar, withOffset: 10)
        blueButton.autoPinEdge(.left, to: .right, of: greenButton, withOffset: 10)
        
        // setup add target button
        grayButton.backgroundColor = UIColor.gray
        grayButton.autoSetDimension(.height, toSize: 50)
        grayButton.autoSetDimension(.width, toSize: 50)
        view?.addSubview(grayButton)
        grayButton.autoPinEdge(.top, to: .top, of: bottombar, withOffset: 10)
        grayButton.autoPinEdge(.left, to: .right, of: blueButton, withOffset: 10)
        
    }
    
    func setupActions() {
        backButton.addTarget(self, action: #selector(presentLoginVC), for: .touchUpInside)
        addTargetButton.addTarget(self, action: #selector(pressAddTarget), for: .touchUpInside)
        greenButton.addTarget(self, action: #selector(makeColorGreen), for: .touchUpInside)
        redButton.addTarget(self, action: #selector(makeColorRed), for: .touchUpInside)
        blueButton.addTarget(self, action: #selector(makeColorBlue), for: .touchUpInside)
        grayButton.addTarget(self, action: #selector(makeColorGray), for: .touchUpInside)
    }
    
    @objc func makeColorBlue() {
        currentColor = UIColor.blue
    }
    @objc func makeColorRed() {
        currentColor = UIColor.red
    }
    @objc func makeColorGreen() {
        currentColor = UIColor.green
    }
    
    @objc func makeColorGray() {
        currentColor = UIColor.gray
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
        addTarget(image: newTarget!, name: "0")
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        
        // if out of target image has been ddetected then get corresponding anchor
        guard let currentImageAnchor = anchor as? ARImageAnchor else { return }
        
        // get targets name
        let targetName = currentImageAnchor.referenceImage.name!
        print("target found with name:\(targetName)")
        
        
        // select scene by name
        let dummyJSON: JSON = JSON()
        let name: String = targetName
        
        let targetID = Int(targetName)
        print(scenes)
        let connectHandler = ConnectionHandler.sharedInstance
        let targetScene: CubeScene = scenes[String(targetID!)]!
        currentScene = targetScene
        
        // build target scene
        let targetSceneRootNode: SCNNode = targetScene.buildScene()
        
        // add scene root to node
        node.addChildNode(targetSceneRootNode)
    }
    
    var count = 0
    var offset = 0.01
    func addNewText() {
        var textMaterials = [SCNMaterial]()
        let textMaterial = SCNMaterial()
        textMaterial.diffuse.contents = UIColor.white
        textMaterials.append(textMaterial)
        
        // create text
        let textBase = SCNNode()
        let textGeometry = SCNText(string: "hello world", extrusionDepth: 1)
        textGeometry.materials = textMaterials
        textBase.scale = SCNVector3(0.001, 0.001, 0.001)
        textBase.geometry = textGeometry
        textBase.position = SCNVector3(0, offset, 0)
        offset += 0.02
        count += 1
        textBase.name = "text-\(count)"
        sidePlaneBase?.addChildNode(textBase)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        // check what nodes are tapped
        let p = touches.first?.location(in: sceneView)
        let hitResults = sceneView.hitTest(p!, options: nil)
        if hitResults.count > 0
        {
            
            let hitnode = (hitResults.first)!.node
            print("\nName of node hit is \(hitnode.name)")
            
            
            if let result = hitResults.first {
                let node = result.node
                
                // Find the material for the clicked element
                // (Indices match between the geometryElements and materials arrays)
                let material = node.geometry!.materials[result.geometryIndex]
                
              
                // Do something with that material, for example:
                let highlight = CABasicAnimation(keyPath: "diffuse.contents")
                highlight.toValue = UIColor.red
                highlight.duration = 1.0
                highlight.autoreverses = true
                material.addAnimation(highlight, forKey: nil)
                
                // add cube to side clicked
                
                // get position from cube name
                let coords:[String] = hitnode.name!.components(separatedBy: ",")
                let x = Int(coords[1])!
                let y = Int(coords[2])!
                let z = Int(coords[3])!
                
                enum CubeFace: Int {
                    case Front, Right, Back, Left, Top, Bottom
                }
                
                // when processing hit test result:
                print("hit face: \(CubeFace(rawValue: result.geometryIndex))")
                
                
                if (result.geometryIndex == CubeFace.Right.rawValue) {
                    currentScene!.addCube(x: Double(x+1), y: Double(y), z: Double(z), color: currentColor)
                }
                else if (result.geometryIndex == CubeFace.Left.rawValue) {
                    currentScene!.addCube(x: Double(x-1), y: Double(y), z: Double(z), color: currentColor)
                }
                else if (result.geometryIndex == CubeFace.Top.rawValue) {
                    currentScene!.addCube(x: Double(x), y: Double(y+1), z: Double(z), color: currentColor)
                }
                else if (result.geometryIndex == CubeFace.Bottom.rawValue) {
                    currentScene!.addCube(x: Double(x), y: Double(y-1), z: Double(z), color: currentColor)
                }
                else if (result.geometryIndex == CubeFace.Front.rawValue) {
                    currentScene!.addCube(x: Double(x), y: Double(y), z: Double(z+1), color: currentColor)
                }
                else if (result.geometryIndex == CubeFace.Back.rawValue) {
                    currentScene!.addCube(x: Double(x), y: Double(y), z: Double(z-1), color: currentColor)
                }
                
            }
            
            //var indexvalue = hitResults.first?.faceIndex
            //print(indexvalue)
        }
        
//        guard let touchLocation = touches.first?.location(in: sceneView),
//            let hitNode = sceneView?.hitTest(touchLocation, options: nil).first?.node,
//            let nodeName = hitNode.name
//            else {
//                //No Node Has Been Tapped
//                return
//
//        }
//        if (nodeName == "add-plane-button") {
//            //toggleAddedPlane()
//            addNewText()
//        }
//
//        //Handle Event Here e.g. PerformSegue
//        print(nodeName)
        
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
