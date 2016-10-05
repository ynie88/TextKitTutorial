//
//  HTMLParserTests.swift
//  TextKitTutorial
//
//  Created by Yuchen Nie on 5/12/16.
//  Copyright © 2016 WeddingWire. All rights reserved.
//

import Foundation
import Quick
import Nimble
@testable import TextKitTutorial

class HTMLParserTest: QuickSpec {
    override func spec() {
        let textView = WWHTMLTextView()
        
        describe("Textview is not nil") {
            it("shouldn't be nil") {
                let parser = HTMLParser(textView: textView)
                expect(parser.textView).notTo(equal(nil))
            }
        }
        
        describe("Parser should parse html images") {
            it("should remove html image tags") {
                let parser = HTMLParser(textView: textView)
                guard let htmlString = self.getJSONValueFromFile("SampleJSONTest", key: "cooked") else {return}
                let cookedString = parser.removeImageTags(htmlString)
                expect(cookedString.rangeOfString("<img")).to(beNil())
            }
            
            it("should get a list of images from html") {
                let parser = HTMLParser(textView: textView)
                guard let htmlString = self.getJSONValueFromFile("SampleJSONTest", key: "cooked") else {return}
                let imageTags = parser.getImageTags(htmlString).images
                let parsedHTMLString = parser.getImageTags(htmlString).htmlWithNoImages
                
                expect(parsedHTMLString.rangeOfString("<img")).to(beNil())
                expect(imageTags.count).to(equal(8))
            }
            
            it("shouldn't have any images") {
                let parser = HTMLParser(textView: textView)
                guard let htmlString = self.getJSONValueFromFile("Sample21", key: "cooked") else {return}
                let imageTags = parser.getImageTags(htmlString).images
                let parsedHTMLString = parser.getImageTags(htmlString).htmlWithNoImages
                expect(parsedHTMLString).to(equal(htmlString))
                expect(imageTags.count).to(equal(0))
            }
        }
        
        describe("Image struct tests") {
            var images:[ImageTypeStruct]!
            
            beforeEach({ 
                let parser = HTMLParser(textView: textView)
                guard let htmlString = self.getJSONValueFromFile("SampleJSONTest", key: "cooked") else {return}
                images = parser.getImageTags(htmlString).images
            })
            
            it("should have the proper information for images", closure: {
                let firstImage = images[0]
                expect(firstImage.src).to(equal("http://lorempixel.com/96/96?random=1"))
                expect(firstImage.key).to(equal("http://lorempixel.com/96/96?random=1"))
                expect(firstImage.size.height).to(equal(96.0))
            })
        }
        
        describe("WWXMLElements Tests") { 
            var parser:HTMLParser!
            var htmlString:String!
            
            beforeEach({ 
                parser = HTMLParser(textView: textView)
                htmlString = self.getJSONValueFromFile("SampleJSONTest", key: "cooked")
            })
            
            it("should return the proper number of elements", closure: { 
                let elements = parser.getElementsFromString(htmlString)
                expect(elements.count).to(equal(51))
            })
            
            it("elements should have the correct values", closure: { 
                let elements = parser.getElementsFromString(htmlString)
                let firstElement = elements[1]
                expect(firstElement.attributes?.count).to(equal(0))
                expect(firstElement.raw!).to(equal("<blockquote>This is someone elses quote that I\'m showing here... oh do \n\n<br/>\n\n<a href=\"http://google.com\">links</a> work here?</blockquote>"))
                expect(firstElement.stringValue!).to(equal("This is someone elses quote that I\'m showing here... oh do \n\n\n\nlinks work here?"))
                expect(firstElement.tag!).to(equal("blockquote"))
                
            })
            
            it("should build attributed string", closure: { 
                let elements = parser.getElementsFromString(htmlString)
                let attributedString = parser.buildAttributedStringWithXMLElements(elements).attrString
                expect(attributedString.length>0).to(beTrue())
                expect(attributedString.containsAttachmentsInRange(NSMakeRange(0, attributedString.length))).to(beFalse())
            })
            
            it("should have the correct indexing for images", closure: {
                let elements = parser.getElementsFromString(htmlString)
                let images = parser.buildAttributedStringWithXMLElements(elements).images
                expect(images.count).to(equal(8))
                let image0 = images[0]
                expect(image0.index).to(equal(395))
                let image1 = images[1]
                expect(image1.index).to(equal(430))
                let image2 = images[2]
                expect(image2.index).to(equal(432))
                let image3 = images[3]
                expect(image3.index).to(equal(520))
            
            })
            
        }
    }
    
    func getJSONValueFromFile(_ fileName:String, key:String) -> String? {
        let bundle = Bundle(for: type(of: self))
        guard let path = bundle.path(forResource: fileName, ofType: "json") else {return nil}
        guard let jsonData = try? Data(contentsOf: URL(fileURLWithPath: path), options: NSData.ReadingOptions.mappedIfSafe) else {return nil}
        guard let jsonResult = try? JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) else {return nil}
        guard let str = (jsonResult as AnyObject).object(forKey: key) as? String else {return nil}
        return str
    }
}
