//
//  RenderingHelperFunctions.swift
//  TextKitTutorial
//
//  Created by Yuchen Nie on 9/12/16.
//  Copyright © 2016 WeddingWire. All rights reserved.
//

import Foundation
import UIKit

struct RenderingHelperFunctions{
    static func getJSONValueFromFile(fileName:String, key:String) -> AnyObject? {
        guard let path = NSBundle.mainBundle().pathForResource(fileName, ofType: "json") else {return nil}
        guard let jsonData = try? NSData(contentsOfFile: path, options: NSDataReadingOptions.DataReadingMappedIfSafe) else {return nil}
        return try? NSJSONSerialization.JSONObjectWithData(jsonData, options: .AllowFragments)
    }
}