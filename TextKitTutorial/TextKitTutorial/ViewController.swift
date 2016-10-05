//
//  ViewController.swift
//  TextKitTutorial
//
//  Created by Yuchen Nie on 4/15/16.
//  Copyright © 2016 WeddingWire. All rights reserved.
//

import UIKit
import SnapKit
import Fuzi

class ViewController: UIViewController, UITextViewDelegate {
    fileprivate lazy var label:UILabel = {label in
        label.text = "test"
        label.textAlignment = .center
        self.view.addSubview(label)
        return label
    }(UILabel())
    
    var elements:[XMLElement] = [XMLElement]()
    
    fileprivate let textViewDelegate:Handler = Handler()
    
    fileprivate lazy var textView:WWHTMLTextView = {_textView in
        _textView.delegate                      = self.textViewDelegate
        _textView.textContainer.lineBreakMode   = .byWordWrapping
//        _textView.delaysContentTouches          = false
        _textView.textContainerInset            = UIEdgeInsets.zero
        _textView.isEditable                      = false
//        _textView.selectable                    = true
        _textView.isUserInteractionEnabled        = true
        
        self.view.addSubview(_textView)
        return _textView
    }(WWHTMLTextView())
    
    final lazy var htmlParser:HTMLParser = {
        let htmlParser = HTMLParser(textView: self.textView)
        return htmlParser
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        view.setNeedsUpdateConstraints()
        view.updateConstraintsIfNeeded()
        loadHTMLFromFile()
        
        //loadHTML()
    }

    override func updateViewConstraints() {
        label.snp.updateConstraints { (make) in
            make.leading.trailing.equalTo(self.view).inset(10)
            make.top.equalTo(self.view).offset(10)
        }
        
        textView.snp.updateConstraints { (make) in
            make.leading.trailing.equalTo(self.view)
            make.top.equalTo(label.snp.bottom).offset(10)
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
            let attrStr = htmlParser.getAttributedStringAndImagesFromHTML(htmlString)
            textView.attributedText = attrStr.attrString
            htmlParser.insertImages(attrStr.images)
        }
    }
}

