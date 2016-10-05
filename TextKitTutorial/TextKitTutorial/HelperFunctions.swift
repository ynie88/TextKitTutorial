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

struct HelperFunctions {
    static func getHTMLFromFile(_ fileName:String) -> String{
        let url = Bundle.main.url(forResource: fileName, withExtension:"html")
        guard let fileContent = try? NSString(contentsOf: url!, encoding: String.Encoding.nonLossyASCII.rawValue) else {return ""}
        return fileContent as String
    }
    
    static func showHTMLString(_ unformattedString: String) -> NSAttributedString{
        
        return try! NSAttributedString(data: unformattedString.data(using: String.Encoding.unicode, allowLossyConversion: true)!, options: [ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType], documentAttributes: nil)
    }
    
    static func getJSONValueFromFile(_ fileName:String, key:String) -> String? {
        guard let path = Bundle.main.path(forResource: fileName, ofType: "json") else {return nil}
        guard let jsonData = try? Data(contentsOf: URL(fileURLWithPath: path), options: NSData.ReadingOptions.mappedIfSafe) else {return nil}
        //guard let jsonResult = try? JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as? Dictionary else {return nil}
        guard let jsonResult:[String:Any] = try! JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as? [String : Any] else {return nil}
        guard let stream = jsonResult["post_stream"] as? NSDictionary else {return nil}
        guard let posts = stream["posts"] as! NSArray? else {return nil}
        let firstPost = posts[0] as! NSDictionary
        
        guard let str = firstPost[key] as? String else {return nil}
        return str
    }
    
    static func convertSizeForImage(_ originalSize:CGSize, containerSize:CGSize) -> CGSize {
        if originalSize.width > containerSize.width {
            let ratio = containerSize.width/originalSize.width
            return CGSize(width: originalSize.width * ratio, height: originalSize.height * ratio)
        } else {
            return originalSize
        }
    }
}

extension Data {
    var attributedString: NSAttributedString? {
        do {
            return try NSAttributedString(data: self, options:[NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute: String.Encoding.utf16], documentAttributes: nil)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        return nil
    }
}

extension String {
    var utf8Data: Data? {
        return data(using: String.Encoding.utf16)
    }
}
