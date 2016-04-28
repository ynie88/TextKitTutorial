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
        guard let fileContent = try? NSString(contentsOfURL: url!, encoding: NSNonLossyASCIIStringEncoding) else {return ""}
        return fileContent as String
    }
    
    static func showHTMLString(unformattedString: String) -> NSAttributedString{
//        var attrStr = NSAttributedString(data: unformattedString.dataUsingEncoding(NSUnicodeStringEncoding, allowLossyConversion: true)!, options: [ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType], documentAttributes: nil, error: nil)
        
        return try! NSAttributedString(data: unformattedString.dataUsingEncoding(NSUnicodeStringEncoding, allowLossyConversion: true)!, options: [ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType], documentAttributes: nil)
    }
    
    static func getElementsFromString(string:String) -> [WWXMLElement]{
        var elements = [WWXMLElement]()
        //let newStr = string.stringByReplacingOccurrencesOfString("<br>", withString: "<br></br>").stringByReplacingOccurrencesOfString("<p>", withString: "<br></br> ").stringByReplacingOccurrencesOfString("</p>", withString: " ")
        do {
            //let document = try XMLDocument(string: string)
            let document = try HTMLDocument(string: string)
            
            if let root = document.root![0] {
                for element in root.children {
                    print("tag: \(element.tag): attributes: \(element.attributes), string value: \(element.stringValue)")
                    for (index, subItems) in element.css("a").enumerate(){
                        print("index: \(index), element attributes: \(subItems.attributes), element string value: \(element.stringValue), \(element.rawXML)")
                    }
                    let wwElement = WWXMLElement(element: element, raw: element.rawXML)
                    elements.append(wwElement)
                }
            }
            
//            for (index, element) in document.css("a").enumerate(){
//                print("index: \(index), element: \(element.attributes)")
//            }
            
        } catch {
            
        }
        return elements
    }
    
    static func getJSONValueFromFile(fileName:String, key:String) -> String? {
        guard let path = NSBundle.mainBundle().pathForResource(fileName, ofType: "json") else {return nil}
        guard let jsonData = try? NSData(contentsOfFile: path, options: NSDataReadingOptions.DataReadingMappedIfSafe) else {return nil}
        guard let jsonResult = try? NSJSONSerialization.JSONObjectWithData(jsonData, options: .AllowFragments) else {return nil}
        guard let stream = jsonResult["post_stream"] as? NSDictionary else {return nil}
        guard let posts = stream["posts"] as! NSArray? else {return nil}
        let firstPost = posts[0] as! NSDictionary
        
        guard let str = firstPost[key] as? String else {return nil}
        return str
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
