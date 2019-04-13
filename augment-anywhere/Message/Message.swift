//
//  Message.swift
//  augment-anywhere
//
//  Created by zach on 4/13/19.
//  Copyright © 2019 zach. All rights reserved.
//

import ARKit
import Foundation


class Message: SCNNode {

    var messageData: MessageData
    
    init(messageData: MessageData) {
        self.messageData = messageData
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("Business Card Coder Not Implemented") }
    
    
}
