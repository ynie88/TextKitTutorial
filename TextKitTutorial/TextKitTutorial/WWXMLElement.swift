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
    let attributes:[String:String]?
    let tag:String?
    let stringValue:String?
    
    init(element:XMLElement, raw:String?, attributes:[String:String], tag:String?, stringValue:String?){
        self.element        = element
        self.raw            = raw
        self.attributes     = attributes
        self.tag            = tag
        self.stringValue    = stringValue
    }
}