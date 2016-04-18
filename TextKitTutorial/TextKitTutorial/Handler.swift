//
//  Handler.swift
//  PrettyTextView
//
//  Created by Wesley Cope on 4/13/16.
//  Copyright © 2016 Wess Cope. All rights reserved.
//

import Foundation
import UIKit

class Handler : NSObject, UITextViewDelegate {
    func textView(textView: UITextView, shouldInteractWithTextAttachment textAttachment: NSTextAttachment, inRange characterRange: NSRange) -> Bool {
        return true
    }
    
    func textView(textView: UITextView, shouldInteractWithURL URL: NSURL, inRange characterRange: NSRange) -> Bool {
        let textString: NSString    = textView.text
        let str                     = textString.substringWithRange(characterRange)
        
        if let dataType = textView.attributedText.attribute(DetectedDataHandlerAttributeName, atIndex: characterRange.location, effectiveRange: nil) as? Int {
            
            (textView as! WWTextView).onClick?(string: str, type: DetectedType(rawValue: dataType)!, range: characterRange)
            
        }
        
        return true
    }
    
    func textViewDidChange(textView: UITextView) {
        if let textStorage = textView.layoutManager.textStorage as? TextStorage {
            let targetLocation = textView.selectedRange.location
            
            for range in textStorage.emails {
                if range.location >= targetLocation || range.location + range.length >= targetLocation {
                    
                    let textValue = (textStorage.string as NSString).substringWithRange(range)
                    
                    detected(textView, string: textValue, type: DetectedType.Email, range: range)
                    
                    return
                }
            }
            
            for range in textStorage.urls {
                if range.location >= targetLocation || range.location + range.length >= targetLocation {
                    
                    let textValue = (textStorage.string as NSString).substringWithRange(range)
                    
                    detected(textView, string: textValue, type: DetectedType.URL, range: range)
                    
                    return
                }
            }
            
            
        }
    }
    
    func detected(textView: UITextView, string: String, type: DetectedType, range: NSRange) {
        (textView as! WWTextView).detected?(string: string, type: type, range: range)
    }
}