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
    func textView(_ textView: UITextView, shouldInteractWith textAttachment: NSTextAttachment, in characterRange: NSRange) -> Bool {
        
        if let image = textAttachment.image {
            let imageVC = EnlargeImageVC()
            imageVC.configWithImage(image)
            AppDelegate.instance.window?.rootViewController?.present(imageVC, animated: true, completion: nil)
        }
        else if let contents = textAttachment.fileWrapper?.regularFileContents{
            if let image = UIImage(data: contents) {
                let imageVC = EnlargeImageVC()
                imageVC.configWithImage(image)
                AppDelegate.instance.window?.rootViewController?.present(imageVC, animated: true, completion: nil)
            }
        }
        
        return true
    }
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        
        let text = textView.attributedText.attributedSubstring(from: characterRange).string
        if text.range(of: "@") != nil {
            //This is a mention, open user's profile
        } else {
            //This is a link, open page via webview
        }
        
        return false
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if let textStorage = textView.layoutManager.textStorage as? TextStorage {
            let targetLocation = textView.selectedRange.location
            
            for range in textStorage.emails {
                if range.location >= targetLocation || range.location + range.length >= targetLocation {
                    
                    let textValue = (textStorage.string as NSString).substring(with: range)
                    
                    detected(textView, string: textValue, type: DetectedType.email, range: range)
                    
                    return
                }
            }
            
            for range in textStorage.urls {
                if range.location >= targetLocation || range.location + range.length >= targetLocation {
                    
                    let textValue = (textStorage.string as NSString).substring(with: range)
                    
                    detected(textView, string: textValue, type: DetectedType.url, range: range)
                    
                    return
                }
            }
            
            
        }
    }
    
    func detected(_ textView: UITextView, string: String, type: DetectedType, range: NSRange) {
        (textView as! WWHTMLTextView).detected?(string, type, range)
    }
}
