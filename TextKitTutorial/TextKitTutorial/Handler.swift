//
//  Handler.swift
//  PrettyTextView
//
//  Created by Wesley Cope on 4/13/16.
//  Copyright © 2016 Wess Cope. All rights reserved.
//

import Foundation
import UIKit

enum urlScheme:String {
    case webURL = "http"
    case webURLS = "https"
    case mention = "mention"
    case hashtag = "hashtag"
}

class Handler : NSObject, UITextViewDelegate {
    func textView(textView: UITextView, shouldInteractWithTextAttachment textAttachment: NSTextAttachment, inRange characterRange: NSRange) -> Bool {
        
        if let image = textAttachment.image {
            let imageVC = EnlargeImageVC()
            imageVC.configWithImage(image)
            AppDelegate.instance.window?.rootViewController?.presentViewController(imageVC, animated: true, completion: nil)
        }
        else if let contents = textAttachment.fileWrapper?.regularFileContents{
            if let image = UIImage(data: contents) {
                let imageVC = EnlargeImageVC()
                imageVC.configWithImage(image)
                AppDelegate.instance.window?.rootViewController?.presentViewController(imageVC, animated: true, completion: nil)
            }
        }
        print(textAttachment)
        
        return true
    }
    
    func textView(textView: UITextView, shouldInteractWithURL URL: NSURL, inRange characterRange: NSRange) -> Bool {
        print("host name: \(URL.host)")
        print("scheme: \(URL.scheme)")
        
        let name = textView.attributedText.attributedSubstringFromRange(characterRange)
        
        var message = ""
        switch URL.scheme {
        case urlScheme.hashtag.rawValue:
            message = "Open Hashtag \(name)"
        case urlScheme.mention.rawValue:
            message = "Open Mention \(name)"
        default:
            message = "open website with url: \(URL.absoluteString)"
        }
        
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.Cancel, handler: nil))
        
        AppDelegate.instance.window?.rootViewController?.presentViewController(alert, animated: true, completion: nil)
        
        return false
    }
    
//    func textView(textView: UITextView, shouldInteractWithURL URL: NSURL, inRange characterRange: NSRange) -> Bool {
//        let textString: NSString    = textView.text
//        let str                     = textString.substringWithRange(characterRange)
//        
//        if let dataType = textView.attributedText.attribute(DetectedDataHandlerAttributeName, atIndex: characterRange.location, effectiveRange: nil) as? Int {
//            
//            (textView as! WWTextView).onClick?(string: str, type: DetectedType(rawValue: dataType)!, range: characterRange)
//            
//        }
//        
//        return true
//    }
    
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