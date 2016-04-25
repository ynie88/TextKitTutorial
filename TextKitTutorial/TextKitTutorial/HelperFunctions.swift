//
//  HelperFunctions.swift
//  TextKitTutorial
//
//  Created by Yuchen Nie on 4/19/16.
//  Copyright © 2016 WeddingWire. All rights reserved.
//

import Foundation
import UIKit
import Fuzi
import StringStylizer

struct HelperFunctions {
    static func getHTMLFromFile(fileName:String) -> String{
        let url = NSBundle.mainBundle().URLForResource(fileName, withExtension:"html")
        guard let fileContent = try? NSString(contentsOfURL: url!, encoding: NSUTF8StringEncoding) else {return ""}
        return fileContent as String
    }
    
    static func showHTMLString(unformattedString: String) -> NSAttributedString{
//        var attrStr = NSAttributedString(data: unformattedString.dataUsingEncoding(NSUnicodeStringEncoding, allowLossyConversion: true)!, options: [ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType], documentAttributes: nil, error: nil)
        
        return try! NSAttributedString(data: unformattedString.dataUsingEncoding(NSUnicodeStringEncoding, allowLossyConversion: true)!, options: [ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType], documentAttributes: nil)
    }
    
    static func getElementsFromString(string:String) -> [XMLElement]{
        var elements = [XMLElement]()
        let newStr = string.stringByReplacingOccurrencesOfString("<br>", withString: "<br></br>").stringByReplacingOccurrencesOfString("<p>", withString: "<br></br> ").stringByReplacingOccurrencesOfString("</p>", withString: " ")
        do {
            let document = try HTMLDocument(string: newStr)
            
            if let root = document.root![0] {
                for element in root.children {
//                    for subElement in element.children {
//                        print("sub element: tag: \(element.tag): attributes: \(element.attributes), string value: \(element.stringValue)")
//                        elements.append(subElement)
//                    }
                    print("tag: \(element.tag): attributes: \(element.attributes), string value: \(element.stringValue)")
                    elements.append(element)
                }
            }
            
        } catch {
            
        }
        return elements
    }
    
    static func convertSizeForImage(originalSize:CGSize, containerSize:CGSize) -> CGSize {
        if originalSize.width > containerSize.width {
            let ratio = containerSize.width/originalSize.width
            return CGSizeMake(originalSize.width * ratio, originalSize.height * ratio)
        } else {
            return originalSize
        }
    }
    
    
}

extension NSData {
    var attributedString: NSAttributedString? {
        do {
            return try NSAttributedString(data: self, options:[NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute: NSUTF16StringEncoding], documentAttributes: nil)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        return nil
    }
}

extension String {
    var utf8Data: NSData? {
        return dataUsingEncoding(NSUTF16StringEncoding)
    }
}
