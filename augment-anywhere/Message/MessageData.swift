//
//  MessageData.swift
//  augment-anywhere
//
//  Created by zach on 4/13/19.
//  Copyright © 2019 zach. All rights reserved.
//

import Foundation

class MessageData {
    
    var text: String
    
    init(text: String) {
        self.text = text
    }
    
    func getText() -> String {
        return self.text
    }
}
