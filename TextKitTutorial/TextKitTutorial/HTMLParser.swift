//
//  HTMLParser.swift
//  TextKitTutorial
//
//  Created by Yuchen Nie on 4/28/16.
//  Copyright © 2016 WeddingWire. All rights reserved.
//

import Foundation
import Fuzi
import Kingfisher

class HTMLParser {
    let textView:WWHTMLTextView!
    
    init(textView:WWHTMLTextView) {
        self.textView = textView
    }
    
    func getAttributedStringAndImagesFromHTML(_ string:String)->(attrString:NSAttributedString, images:[ImageTypeStruct]) {
        let elements = getElementsFromString(string)
        return buildAttributedStringWithXMLElements(elements)
    }
    
    func getElementsFromString(_ string:String) -> [WWXMLElement]{
        var elements = [WWXMLElement]()
        
        do {
            let document = try HTMLDocument(string: string)
            
            if let root = document.root![0] {
                for element in root.children {
                    let wwElement = WWXMLElement(element: element, raw: element.rawXML, attributes: element.attributes, tag: element.tag, stringValue: element.stringValue)
                    elements.append(wwElement)
                }
            }
        } catch {
            
        }
        return elements
    }
    
    func buildAttributedStringWithXMLElements(_ wwElements:[WWXMLElement])->(attrString: NSAttributedString, images:[ImageTypeStruct]) {
        
        let attrStr = NSMutableAttributedString()
        var imageTags:[ImageTypeStruct] = [ImageTypeStruct]()
        
        for wwelement in wwElements {
            let element = wwelement.element
            if let tag = element?.tag {
                if tag == HTMLParserConstants.HTMLTypes.image {
                    let attributes = element?.attributes
                    let length = attrStr.length
                    if let imageType = buildImageTypeStruct(attributes!, index: length) {
                        imageTags.append(imageType)
                    }

                } else if tag == HTMLParserConstants.HTMLTypes.link {
                    if var href = element?.attributes[HTMLParserConstants.ClassTypes.href] {
                        if let linkClass = element?.attributes[HTMLParserConstants.ClassTypes.kClass]{
                            href = linkClass + HTMLParserConstants.HTMLConstants.separator + href
                        }
                        let attributedString = NSMutableAttributedString(string: (element?.stringValue)!)
                        attributedString.addAttribute(NSLinkAttributeName, value: href, range: NSMakeRange(0, element!.stringValue.characters.count))
                        attrStr.append(attributedString)
                    } else {
                        let attributedString = NSMutableAttributedString(string: (element?.stringValue)!)
                        attributedString.addAttribute(NSLinkAttributeName, value: HTMLParserConstants.ClassTypes.mention, range: NSMakeRange(0, element!.stringValue.characters.count))
                        attrStr.append(attributedString)
                    }
                    
                } else {
                    if let htmlString = wwelement.raw {
                        let innerImageTags = getImageTags(htmlString)
                        let attributedOptions : [String: AnyObject] = [
                            NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType as AnyObject,
                            NSCharacterEncodingDocumentAttribute: String.Encoding.utf16 as AnyObject
                        ]
                        do {
                            let encodedData = innerImageTags.htmlWithNoImages.data(using: String.Encoding.utf16)
                            let attributedString = try NSAttributedString(data: encodedData!, options: attributedOptions, documentAttributes: nil)
                            attrStr.append(attributedString)
                            for (index, var imageStruct) in innerImageTags.images.enumerated() {
                                let length = attrStr.length
                                imageStruct.index = length + index
                                imageTags.append(imageStruct)
                            }
                        }catch (let error){
                            print("error: \(error)")
                        }
                    }
                }
            }
        }
        
        return (attrStr, imageTags)
    }
    
    //remove image tags
    func getImageTags(_ string:String) -> (htmlWithNoImages:String, images:[ImageTypeStruct]){
        var images:[ImageTypeStruct] = [ImageTypeStruct]()
        var newString = string
        do {
            let htmlDoc = try HTMLDocument(string: string)
            
            for (_, image) in htmlDoc.css(HTMLParserConstants.HTMLTypes.image).enumerated() {
                let attributes = image.attributes
                if let imageType = buildImageTypeStruct(attributes) {
                    images.append(imageType)
                }
            }
            
            if images.count > 0{
                newString = self.removeImageTags(string)
            }
            
            
        }catch(let error){
            print(error)
        }
        return (newString, images)
    }
    
    fileprivate func buildImageTypeStruct(_ attributes:[String:String], index:Int = 0) -> ImageTypeStruct? {
        if let src = attributes[HTMLParserConstants.ClassTypes.source], let width = attributes[HTMLParserConstants.ClassTypes.width], let height = attributes[HTMLParserConstants.ClassTypes.height], let widthFlt = Float(width), let heightFlt = Float(height) {
            
            let widthCG = CGFloat(widthFlt)
            let heightCG = CGFloat(heightFlt)
            
            return ImageTypeStruct(src: src, key: src, size: CGSize.init(width: widthCG, height: heightCG) , index: index)
        }
        return nil
    }
    
    func removeImageTags(_ string:String)->String {
        let imageTag = HTMLParserConstants.HTMLConstants.openBracket + HTMLParserConstants.HTMLTypes.image
        let startIndex = string.indexOf(imageTag)
        
        let range = startIndex..<string.endIndex
        let endIndex = string.indexOfWithRange(HTMLParserConstants.HTMLConstants.closeBracket, range: range)
        
        let newRange = startIndex..<endIndex
        
        let newString = string.replacingCharacters(in: newRange, with: "")
        let checkIndex = newString.indexOf(imageTag)
        if checkIndex != string.startIndex {
            return removeImageTags(newString)
        } else {
            return newString
        }
    }
    
    func insertImages(_ images:[ImageTypeStruct]) {
        for var imageType in images {
            let placeholderImage = UIImage(named: "gray")
            imageType.imageRange = self.textView.insertImage("placeholderImage", image: placeholderImage!, size: imageType.size, at: imageType.index)
            KingfisherManager.shared.retrieveImage(with: URL(string: imageType.src)!, options: nil, progressBlock: nil, completionHandler: { [weak self] (image, error, cache, url) in
                DispatchQueue.main.async(execute: {
                    if let _self = self, let image = image, let range = imageType.imageRange {
                        _self.textView.removeImage(range)
                        _self.textView.insertImage("Image", image: image, size: imageType.size, at: imageType.index)
                    }
                })
            })
        }
    }
}

struct HTMLParserConstants {
    struct HTMLTypes {
        static let image    = "img"
        static let link     = "a"
    }
    
    struct ClassTypes {
        static let width    = "width"
        static let height   = "height"
        static let source   = "src"
        static let mention  = "mention"
        static let href     = "href"
        static let kClass   = "class"
    }
    
    struct HTMLConstants {
        static let openBracket  = "<"
        static let closeBracket = ">"
        static let separator    = ":/"
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

public extension String {
    func indexOf(_ string: String) -> Index {
        return range(of: string, options: .literal, range: nil, locale: nil)?.lowerBound ?? startIndex
    }
    
    func indexOfWithRange(_ string: String, range:Range<String.Index>) -> Index {
        return self.range(of: string, options: .literal, range: range, locale: nil)?.upperBound ?? startIndex
    }
}
