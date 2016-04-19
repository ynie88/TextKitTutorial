//
//  HelperFunctions.swift
//  TextKitTutorial
//
//  Created by Yuchen Nie on 4/19/16.
//  Copyright © 2016 WeddingWire. All rights reserved.
//

import Foundation
import UIKit

struct HelperFunctions {
    static func getHTMLFromFile(fileName:String) -> String{
        let url = NSBundle.mainBundle().URLForResource(fileName, withExtension:"html")
        guard let fileContent = try? NSString(contentsOfURL: url!, encoding: NSUTF8StringEncoding) else {return ""}
        return fileContent as String
    }
}

extension String {
    var html2String:NSAttributedString {
        return try! NSAttributedString(data: dataUsingEncoding(NSUTF8StringEncoding)!, options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType], documentAttributes: nil)
    }
}
