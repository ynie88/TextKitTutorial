//
//  HTMLParser.swift
//  TextKitTutorial
//
//  Created by Yuchen Nie on 4/28/16.
//  Copyright © 2016 WeddingWire. All rights reserved.
//

import Foundation
import Fuzi
import StringStylizer

let imageTag = "INSERTIMAGEHERE"

class HTMLParser {
    let textView:WWTextView!
    
    init(textView:WWTextView) {
        self.textView = textView
    }
    
    func buildAttributedStringWithXMLElements(wwElements:[WWXMLElement])->(attrString: NSAttributedString, images:[ImageTypeStruct]) {
        
        let attrStr = NSMutableAttributedString()
        var imageTags:[ImageTypeStruct] = [ImageTypeStruct]()
        
        for wwelement in wwElements {
            let element = wwelement.element
            if let tag = element.tag {
                if tag == "img" {
                    let attributes = element.attributes
                    let src = attributes["src"]!
                    let width = CGFloat((attributes["width"]! as NSString).floatValue)
                    let height = CGFloat((attributes["height"]! as NSString).floatValue)
                    
                    let length = attrStr.length
                    let size = CGSizeMake(width, height)
                    
                    
                    let imageType = ImageTypeStruct(src: src, key: src, size: size, index: length)
                    imageTags.append(imageType)
                    
//                    let attributedString = NSAttributedString(string: src)
//                    attrStr.appendAttributedString(attributedString)
                    
                } else if tag == "a" {
                    if var href = element.attributes["href"] {
                        if let linkClass = element.attributes["class"]{
                            href = linkClass + ":/" + href
                        }
                        let attributedString = NSMutableAttributedString(string: element.stringValue)
                        attributedString.addAttribute(NSLinkAttributeName, value: href, range: NSMakeRange(0, element.stringValue.length))
                        attrStr.appendAttributedString(attributedString)
                    } else {
                        let attributedString = NSMutableAttributedString(string: element.stringValue)
                        attributedString.addAttribute(NSLinkAttributeName, value: "mention", range: NSMakeRange(0, element.stringValue.length))
                        attrStr.appendAttributedString(attributedString)
                    }
                    
                } else {
                    if let htmlString = wwelement.raw {
                        let innerImageTags = getImageTags(htmlString)
                        let attributedOptions : [String: AnyObject] = [
                            NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                            NSCharacterEncodingDocumentAttribute: NSUTF16StringEncoding
                        ]
                        do {
                            let encodedData = innerImageTags.htmlWithNoImages.dataUsingEncoding(NSUTF16StringEncoding)
                            let attributedString = try NSAttributedString(data: encodedData!, options: attributedOptions, documentAttributes: nil)
                            //let attributedString = try NSAttributedString(string: htmlString, attributes: attributedOptions)
                            attrStr.appendAttributedString(attributedString)
                            for var imageStruct in innerImageTags.images {
                                let length = attrStr.length
                                imageStruct.index = length
                                imageTags.append(imageStruct)
                            }
                        }catch (let error){
                            print("error: \(error)")
                        }
                    }

                    
//                    let stringValue = element.stringValue
//                    
//                    let attributedString:NSAttributedString
//                    if tag == "strong" {
//                        attributedString = stringValue.stylize().size(16).font(StringStylizerFontName.HelveticaNeue_Bold).attr
//                    } else if tag == "em" {
//                        attributedString = stringValue.stylize().size(14).font(StringStylizerFontName.HelveticaNeue_Italic).attr
//                    } else if tag == "ul" {
//                        let paragraphStyle = NSMutableParagraphStyle()
//                        paragraphStyle.paragraphSpacing = 4
//                        paragraphStyle.paragraphSpacingBefore = 3
//                        paragraphStyle.firstLineHeadIndent = 0.0
//                        paragraphStyle.headIndent = 10.5
//                        
//                        let mutableStr = NSMutableAttributedString(string: stringValue + "\n")
//                        mutableStr.addAttributes([NSParagraphStyleAttributeName:paragraphStyle], range: NSMakeRange(0, stringValue.length))
//                        attributedString = mutableStr as NSAttributedString
//                        //                        attributedString = stringValue.stylize().size(14).paragraph(paragraphStyle).attr
//                        
//                    } else if tag == "h2" {
//                        attributedString = stringValue.stylize().size(18).font(StringStylizerFontName.HelveticaNeue_Bold).attr
//                    } else if tag == "br" {
//                        attributedString = NSAttributedString(string: "\n")
//                    } else {
//                        let data = stringValue.dataUsingEncoding(NSUTF8StringEncoding)
//                        let str = String(data: data!, encoding: NSNonLossyASCIIStringEncoding)
//                        
//                        attributedString = NSAttributedString(string: str!)
//                    }
//                    attrStr.appendAttributedString(attributedString)
                }
            }
        }
        
        return (attrStr, imageTags)
    }
    //remove image tags
    func getImageTags(string:String) -> (htmlWithNoImages:String, images:[ImageTypeStruct]){
        var images:[ImageTypeStruct] = [ImageTypeStruct]()
        var newString = string
        do {
            let htmlDoc = try HTMLDocument(string: string)
            
            for (_, image) in htmlDoc.css("img").enumerate() {
                let attributes = image.attributes
                let src = attributes["src"]!
                let width = CGFloat((attributes["width"]! as NSString).floatValue)
                let height = CGFloat((attributes["height"]! as NSString).floatValue)

                let imageType = ImageTypeStruct(src: src, key: src, size: CGSizeMake(width, height) , index: 100)
                images.append(imageType)
                
            }
            
            if images.count > 0{
                newString = self.removeImageTags(string)
            }
            
            
        }catch(let error){
            print(error)
        }
        return (newString, images)
    }
    
    func removeImageTags(string:String)->String {
        let startIndex = string.indexOf("<img")
        
        let range = startIndex..<string.endIndex
        let endIndex = string.indexOfWithRange("/>", range: range)
        
        let newRange = startIndex..<endIndex
        
        let newString = string.stringByReplacingCharactersInRange(newRange, withString: "")
        let checkIndex = newString.indexOf("<img")
        if checkIndex != string.startIndex {
            return removeImageTags(newString)
        } else {
            return newString
        }
        
    }

}

struct ImageTypeStruct {
    let src:String!
    let key:String!
    let size:CGSize!
    var index:Int!
    var imageRange:NSRange?
    
    init(src:String, key:String, size:CGSize, index:Int){
        self.src = src
        self.key = key
        self.size = size
        self.index = index
    }
}

extension String {
    func indexOf(string: String) -> Index {
        return rangeOfString(string, options: .LiteralSearch, range: nil, locale: nil)?.startIndex ?? startIndex
    }
    
    func indexOfWithRange(string: String, range:Range<String.Index>) -> Index {
        return rangeOfString(string, options: .LiteralSearch, range: range, locale: nil)?.endIndex ?? startIndex
    }
}
