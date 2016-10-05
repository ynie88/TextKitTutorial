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
    static func getJSONValueFromFile(_ fileName:String, key:String) -> AnyObject? {
        guard let path = Bundle.main.path(forResource: fileName, ofType: "json") else {return nil}
        guard let jsonData = try? Data(contentsOf: URL(fileURLWithPath: path), options: NSData.ReadingOptions.mappedIfSafe) else {return nil}
        return try! JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as AnyObject?
    }
}
