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
import Fuzi

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
        view.backgroundColor = UIColor.whiteColor()
        view.setNeedsUpdateConstraints()
        view.updateConstraintsIfNeeded()
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
            let htmlParser = HTMLParser(textView: self.textView)
            let attrStr = htmlParser.buildAttributedStringWithXMLElements(elements)
            textView.attributedText = attrStr.attrString
            insertImages(attrStr.images)
        }
    }
    
    func insertImages(images:[ImageTypeStruct]) {
        for var imageType in images {
            let placeholderImage = UIImage(named: "gray")
            imageType.imageRange = self.textView.insertImage("placeholderImage", image: placeholderImage!, size: imageType.size, at: imageType.index)
            
            ImageLoader.sharedLoader.imageForUrl(imageType.src, completionHandler: { (image, url) in
                if let image = image, let range = imageType.imageRange {
                    self.textView.removeImage(range)
                    self.textView.insertImage("Image", image: image, size: imageType.size, at: imageType.index)
                }
            })
        }
    }
}

