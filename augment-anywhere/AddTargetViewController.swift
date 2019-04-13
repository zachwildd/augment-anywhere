//
//  AddTargetViewController.swift
//  augment-anywhere
//
//  Created by zach on 4/13/19.
//  Copyright © 2019 zach. All rights reserved.
//

import UIKit
import PureLayout
import ARKit

class AddTargetViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var targetImageView: UIImageView = UIImageView()
    var backButton: UIButton = UIButton()
    var addTargetButton: UIButton = UIButton()
    
    var imagePicker: UIImagePickerController?
    
     let screenSize = UIScreen.main.bounds

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupUI()
        setupActions()
    }
    
    func setupUI() {
        print("addtargetvc setup ui")
        
        // setup target image view
        targetImageView.image = UIImage()
        targetImageView.autoSetDimension(.height, toSize: screenSize.width/3)
        targetImageView.autoSetDimension(.width, toSize: screenSize.width/3)
        view.addSubview(targetImageView)
        targetImageView.autoPinEdge(.left, to: .left, of: view, withOffset: screenSize.width/3)
        
        // setup back button
        backButton.backgroundColor = UIColor.red
        backButton.autoSetDimension(.height, toSize: 100)
        backButton.autoSetDimension(.width, toSize: 100)
        view.addSubview(backButton)
        backButton.autoPinEdge(.left, to: .left, of: view, withOffset: 10)
        backButton.autoPinEdge(.top, to: .top, of: view, withOffset: 10)
        
        // setup add target button
        addTargetButton.backgroundColor = UIColor.blue
        addTargetButton.autoSetDimension(.height, toSize: 100)
        addTargetButton.autoSetDimension(.width, toSize: 100)
        view.addSubview(addTargetButton)
        addTargetButton.autoCenterInSuperview()
        
    }
    
    func setupActions() {
        print("addtarget setup actions")
        backButton.addTarget(self, action: #selector(pressBackButton), for: .touchUpInside)
        addTargetButton.addTarget(self, action: #selector(pressAddTargetButton), for: .touchUpInside)
    }
    
    @objc func pressBackButton() {
        performSegue(withIdentifier: "backToAR", sender: self)
    }
    
    @objc func pressAddTargetButton() {
        // pull up camera to take picture of target
        
        imagePicker =  UIImagePickerController()
        imagePicker!.delegate = self
        imagePicker!.sourceType = .camera

        present(imagePicker!, animated: true, completion: nil)
    }
    
    // implement UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imagePicker!.dismiss(animated: true, completion: nil)
        
        let newTarget = info[.originalImage] as? UIImage
        targetImageView.image = newTarget
        addTarget(image: newTarget!)
    }
    
    func addTarget(image: UIImage) {
        print("called add target")
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
