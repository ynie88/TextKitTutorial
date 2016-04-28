//
//  WWXMLElement.swift
//  TextKitTutorial
//
//  Created by Yuchen Nie on 4/28/16.
//  Copyright © 2016 WeddingWire. All rights reserved.
//

import Foundation
import Fuzi

class WWXMLElement {
    let element:XMLElement!
    let raw:String?
    
    init(element:XMLElement, raw:String?){
        self.element = element
        self.raw = raw
    }
}