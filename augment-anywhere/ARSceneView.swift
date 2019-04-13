//
//  ARSceneView.swift
//  bitcamp-client
//
//  Created by zach on 4/13/19.
//  Copyright © 2019 zach. All rights reserved.
//

import UIKit
import ARKit
import SceneKit
import PureLayout

class ARSceneView: ARSCNView {
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
    var backButton: UIButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    public override init(frame: CGRect, options: [String : Any]? = nil) {
        super.init(frame: frame, options: options)
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        print("arsceneview setup")
        
        backButton.backgroundColor = UIColor.red
        backButton.autoSetDimension(.height, toSize: 100)
        backButton.autoSetDimension(.width, toSize: 100)
        addSubview(backButton)
        backButton.autoCenterInSuperview()
    }
    
    func setupActions() {
        
    }
    
}
