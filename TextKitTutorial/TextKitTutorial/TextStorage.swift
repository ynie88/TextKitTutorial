//
//  TextStorage.swift
//  PrettyTextView
//
//  Created by Wesley Cope on 4/13/16.
//  Copyright © 2016 Wess Cope. All rights reserved.
//

import Foundation
import UIKit

class TextStorage : NSTextStorage {
    var textStyles:[String : AnyObject]?
    
    var backing:NSMutableAttributedString   = NSMutableAttributedString()
    var emails:[NSRange]                    = []
    var urls:[NSRange]                      = []
    var custom:[NSRange]                    = []
    var tapInset                            = UIEdgeInsets(top: -5, left: -5, bottom: -5, right: -5)
    
    fileprivate let linkPattern     = "[a-zA-Z]+://[0-9a-zA-Z_.?&/=]+"
    fileprivate let emailPattern    = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]+"
    override var string: String {
        return backing.string
    }
    
    override func attributes(at location: Int, effectiveRange range: NSRangePointer?) -> [String : Any] {
        return backing.attributes(at: location, effectiveRange: range)
    }
    
    override func replaceCharacters(in range: NSRange, with str: String) {
        beginEditing()
        
        backing.replaceCharacters(in: range, with: str)
        edited([.editedAttributes, .editedCharacters,], range: range, changeInLength: (str.characters.count - range.length))
        endEditing()
    }
    
    override func setAttributes(_ attrs: [String : Any]?, range: NSRange) {
        beginEditing()
        
        backing.setAttributes(attrs, range: range)
        edited([.editedAttributes,], range: range, changeInLength: 0)
        
        endEditing()
    }
    
    override func addAttributes(_ attrs: [String : Any], range: NSRange) {
        beginEditing()
        
        backing.addAttributes(attrs, range: range)
        edited([.editedAttributes,], range: range, changeInLength: 0)
        
        endEditing()
    }
    
    override func processEditing() {
        
        let paragraphRange = (self.string as NSString).paragraphRange(for: self.editedRange)
        
        self.removeAttribute(NSForegroundColorAttributeName, range: paragraphRange)
        //self.removeAttribute(NSLinkAttributeName, range: paragraphRange)
        self.removeAttribute(DetectedDataHandlerAttributeName, range: paragraphRange)
        
        if let textStyles = textStyles {
            addAttributes(textStyles, range: paragraphRange)
        }
        
        emails  = [NSRange]()
        urls    = [NSRange]()

        let linkExpression    = try? NSRegularExpression(pattern: linkPattern, options: NSRegularExpression.Options())
        if let linkExpression = linkExpression {
            linkExpression.enumerateMatches(in: self.string, options: NSRegularExpression.MatchingOptions(), range: paragraphRange) { (result, flags, stop) in
                
                if let result = result {
                    let textValue                               = (self.string as NSString).substring(with: result.range)
                    let textAttributes: [String : AnyObject]!   = [NSForegroundColorAttributeName: UIColor.blue, NSLinkAttributeName: textValue as AnyObject, DetectedDataHandlerAttributeName: DetectedType.url.rawValue as AnyObject]
                    
                    self.addAttributes(textAttributes, range: result.range )
                    self.urls.append(result.range)
                }
            }
        }
        
        let emailExpression    = try? NSRegularExpression(pattern: emailPattern, options: NSRegularExpression.Options())
        if let emailExpression = emailExpression {
            emailExpression.enumerateMatches(in: self.string, options: NSRegularExpression.MatchingOptions(), range: paragraphRange) { (result, flags, stop) in
                
                if let result = result {
                    let textValue                               = (self.string as NSString).substring(with: result.range)
                    let textAttributes: [String : AnyObject]!   = [NSForegroundColorAttributeName: UIColor.blue, NSLinkAttributeName: textValue as AnyObject, DetectedDataHandlerAttributeName: DetectedType.email.rawValue as AnyObject]
                    
                    self.addAttributes(textAttributes, range: result.range )
                    self.emails.append(result.range)
                }
                
            }
        }
        
        for range in custom {
            let textAttributes: [String : AnyObject]! = [NSForegroundColorAttributeName: UIColor.blue, NSLinkAttributeName: "CustomRange" as AnyObject, DetectedDataHandlerAttributeName: DetectedType.custom.rawValue as AnyObject]
            
            self.addAttributes(textAttributes, range: range )
        }
        
        super.processEditing()
    }
}

