//
//  ViewController.swift
//  TextKitTutorial
//
//  Created by Yuchen Nie on 4/15/16.
//  Copyright © 2016 WeddingWire. All rights reserved.
//

import UIKit
import SnapKit
import Appendix
import StringStylizer

class ViewController: UIViewController, UITextViewDelegate {
    private lazy var label:UILabel = {label in
        label.text = "test"
        label.textAlignment = .Center
        self.view.addSubview(label)
        return label
    }(UILabel())
    
    var elements:[XMLElement] = [XMLElement]()
    
    private let textViewDelegate:Handler = Handler()
    
    private lazy var textView:WWTextView = {_textView in
        _textView.delegate                      = self.textViewDelegate
        _textView.textContainer.lineBreakMode   = .ByWordWrapping
//        _textView.delaysContentTouches          = false
        _textView.textContainerInset            = UIEdgeInsetsZero
        _textView.editable                      = false
//        _textView.selectable                    = true
        _textView.userInteractionEnabled        = true
        
        self.view.addSubview(_textView)
        return _textView
    }(WWTextView())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        view.backgroundColor = UIColor.whiteColor()
        view.setNeedsUpdateConstraints()
        view.updateConstraintsIfNeeded()
        //textView.insertImage("grayCat", image: UIImage(named: "grayCat")!, size: CGSizeMake(192, 120), at: 30)
        loadHTMLFromFile()
        
        //loadHTML()
    }

    override func updateViewConstraints() {
        label.snp_updateConstraints { (make) in
            make.leading.trailing.equalTo(self.view).inset(10)
            make.top.equalTo(self.view).offset(10)
        }
        
        textView.snp_updateConstraints { (make) in
            make.leading.trailing.equalTo(self.view)
            make.top.equalTo(label.snp_bottom).offset(10)
            make.bottom.equalTo(self.view)
        }
        super.updateViewConstraints()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadHTMLFromFile() {
        if let htmlString = HelperFunctions.getJSONValueFromFile("SampleHTMLParsingPost", key: "cooked") {
            //print("htmlStirng = \(htmlString)")
            let elements = HelperFunctions.getElementsFromString(htmlString)
            let attrStr = self.buildAttributedStringWithXMLElements(elements)
            textView.attributedText = attrStr
        }
    }
    
    func loadHTML() {
        let str = HelperFunctions.getHTMLFromFile("DiscourseTwo")
        elements = HelperFunctions.getElementsFromString(str)
        let attrStr = buildAttributedStringWithXMLElements(elements)
        textView.attributedText = attrStr
    }
    
    func buildAttributedStringWithXMLElements(elements:[XMLElement])->NSAttributedString {
        let attrStr = NSMutableAttributedString()
        for element in elements {
            if let tag = element.tag {
                print("tag \(tag)")
                if tag == "img" {
                    let attributes = element.attributes
                    let src = attributes["src"]!
                    let width = CGFloat((attributes["width"]! as NSString).floatValue)*0.9
                    let height = CGFloat((attributes["height"]! as NSString).floatValue)*0.9
                    
                    let length = attrStr.length
                    
                    ImageLoader.sharedLoader.imageForUrl(src, completionHandler: { (image, url) in
                        if let image = image {
                            let size = CGSizeMake(width, height)
                            let imageSize = HelperFunctions.convertSizeForImage(size, containerSize: self.textView.size)
                            //self.textView.insertImage(tag, image: image, size: imageSize)
                            self.textView.insertImage(tag, image: image, size: imageSize, at: length)
                        }
                    })
                } else if tag == "a" {
                    if var href = element.attributes["href"] {
                        if let linkClass = element.attributes["class"]{
                            href = linkClass + ":/" + href
                        }
                        let attributedString = NSMutableAttributedString(string: element.stringValue)
                        attributedString.addAttribute(NSLinkAttributeName, value: href, range: NSMakeRange(0, element.stringValue.length))
                        attrStr.appendAttributedString(attributedString)
                    }

                } else {
//                    let htmlString = element.rawXML
//                    guard let encodedData = htmlString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true) else {continue}
//                    let attributedOptions : [String: AnyObject] = [
//                        NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
//                        NSCharacterEncodingDocumentAttribute: NSUTF8StringEncoding
//                    ]
//                    do {
//                        let attributedString = try NSAttributedString(data: encodedData, options: attributedOptions, documentAttributes: nil)
//                    }catch (let error){
//                        print("error: \(error)")
//                    }
                    
                    let stringValue = element.stringValue
                    
                    let attributedString:NSAttributedString
                    if tag == "strong" {
                        attributedString = stringValue.stylize().size(16).font(StringStylizerFontName.HelveticaNeue_Bold).attr
                    } else if tag == "em" {
                        attributedString = stringValue.stylize().size(14).font(StringStylizerFontName.HelveticaNeue_Italic).attr
                    } else if tag == "ul" {
                        let paragraphStyle = NSMutableParagraphStyle()
                        paragraphStyle.paragraphSpacing = 4
                        paragraphStyle.paragraphSpacingBefore = 3
                        paragraphStyle.firstLineHeadIndent = 0.0
                        paragraphStyle.headIndent = 10.5
                        
                        let mutableStr = NSMutableAttributedString(string: stringValue + "\n")
                        mutableStr.addAttributes([NSParagraphStyleAttributeName:paragraphStyle], range: NSMakeRange(0, stringValue.length))
                        attributedString = mutableStr as NSAttributedString
//                        attributedString = stringValue.stylize().size(14).paragraph(paragraphStyle).attr
                        
                    } else if tag == "h2" {
                        attributedString = stringValue.stylize().size(18).font(StringStylizerFontName.HelveticaNeue_Bold).attr
                    } else if tag == "br" {
                        attributedString = NSAttributedString(string: "\n")
                    } else {
                        attributedString = NSAttributedString(string: stringValue)
                    }
                    attrStr.appendAttributedString(attributedString)
                }
            }
        }
        
        return attrStr
    }
    
    
}

