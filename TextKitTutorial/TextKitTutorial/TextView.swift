//
//  TextView.swift
//  PrettyTextView
//
//  Created by Wesley Cope on 4/13/16.
//  Copyright © 2016 Wess Cope. All rights reserved.
//

import Foundation
import UIKit

class WWHTMLTextView : UITextView {
    var onClick:((_ string:String, _ type:DetectedType, _ range:NSRange) -> Void)?
    var detected:((_ string:String, _ type:DetectedType, _ range:NSRange) -> Void)?
    var tapGestureRecognizer:UITapGestureRecognizer?
    var shouldUpdate        = true
    var highlightColor      = UIColor.blue.withAlphaComponent(0.2)
    var placeholderLabel    = UILabel(frame: .zero)
    let tapInset            = UIEdgeInsets(top: -2, left: -2, bottom: -2, right: -2)
    
    fileprivate var prettyStorage       = NSTextStorage()
    fileprivate var prettyLayoutManager = NSLayoutManager()
    fileprivate var prettyContainer     = NSTextContainer()

    var placeholder: String? {
        didSet {
            var attributes = [String: AnyObject]()
            
            if typingAttributes.count > 0 && isFirstResponder {
                attributes = typingAttributes as [String : AnyObject]
            } else {
                if let font = font {
                    attributes[NSFontAttributeName] = font
                }
                
                attributes[NSForegroundColorAttributeName] = UIColor(white: 0.7, alpha: 1.0)
                
                if textAlignment != NSTextAlignment.left {
                    let paragraph                               = NSMutableParagraphStyle()
                    paragraph.alignment                         = textAlignment
                    attributes[NSParagraphStyleAttributeName]   = paragraph
                }
            }
            
            self.attributedPlaceholder = NSAttributedString(string: placeholder!, attributes: attributes)
        }
    }
    
    var attributedPlaceholder: NSAttributedString? {
        didSet {
            placeholderLabel.attributedText = attributedPlaceholder
            placeholderLabel.sizeToFit()
            
            placeholderLabel.frame = placeholderFrame(placeholderLabel.bounds)
        }
    }
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    init(frame: CGRect) {
        prettyStorage.addLayoutManager(prettyLayoutManager)
        prettyLayoutManager.addTextContainer(prettyContainer)
        
        super.init(frame: frame, textContainer: prettyContainer)
        
        initialize()
    }
    
    func initialize() {
        NotificationCenter.default.addObserver(self, selector: #selector(textChanged), name: NSNotification.Name.UITextViewTextDidChange, object: self)

        placeholderLabel.isHidden = false
        
        addSubview(placeholderLabel)
    }

    func textChanged() {
        if let _ = attributedPlaceholder {
            placeholderLabel.isHidden = text.characters.count == 0 ? false : true
        }
        
        setNeedsDisplay()
    }
    
    func newline() {
        if let attrString = attributedText.mutableCopy() as? NSMutableAttributedString {
            let lineEnd = NSMutableAttributedString(string: "\n")
            
            lineEnd.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle(0), range: NSRange(location: 0, length: lineEnd.length))
            
            attrString.append(lineEnd)
            
            attributedText = attrString
        }
    }
    
    func paragraphStyle(_ spacing:CGFloat) -> NSParagraphStyle {
        let style                       = NSMutableParagraphStyle()
        style.paragraphSpacing          = spacing
        style.paragraphSpacingBefore    = spacing
        
        return style
    }
}

extension WWHTMLTextView /* Actions */ {
    func clickedDetected(_ string:String, type:DetectedType, range:NSRange) {
        onClick?(string, type, range)
    }
}

extension WWHTMLTextView /* Detection */ {
    func urlsAt(_ location:CGPoint, complete:@escaping (NSRange) -> ()) {
        var found = false
        
        attributedText.enumerateAttribute(DetectedDataHandlerAttributeName, in: NSMakeRange(0, attributedText.length), options: []) { (value, range, stop) in
            if value != nil {
                self.frames([NSValue(range: range),]) { (frame, range, stop) in
                    if !found && frame.contains(location) {
                        
                        self.drawHighlight(frame, range: range)
                        
                        found = true
                        
                        complete(range)
                    }
                }
            }
        }
        
        if !found {
            attributedText.enumerateAttribute(ImageAttributeName, in: NSMakeRange(0, attributedText.length), options: []) { (value, range, stop) in
                if value != nil {
                    self.frames([NSValue(range: range),]) { (frame, range, stop) in
                        if !found && frame.contains(location) {
                            
                            self.drawHighlight(frame, range: range)
                            
                            found = true
                            
                            complete(range)
                        }
                    }
                }
            }
        }
    }
    
    func frames(_ ranges:[NSValue], complete:@escaping (_ frame: CGRect, _ range:NSRange, _ stop:Bool) -> Void) {
        for value in ranges {
            let range   = value.rangeValue
            let glyphs  = layoutManager.glyphRange(forCharacterRange: range, actualCharacterRange: nil)
            
            layoutManager.enumerateEnclosingRects(forGlyphRange: glyphs, withinSelectedGlyphRange: NSMakeRange(NSNotFound, 0), in: textContainer) { (rect, stop) in
                var rect        = rect
                rect.origin.x  += self.textContainerInset.left
                rect.origin.y  += self.textContainerInset.top
                rect            = UIEdgeInsetsInsetRect(rect, self.tapInset)
                
                complete(rect, range, true)
            }
        }
    }
    
    func currentlydetected(_ string:String, type:DetectedType, range:NSRange) {
        detected?(string, type, range)
    }
}

extension WWHTMLTextView /* Imaging */ {
    func imageRanges() -> [[String : NSRange]] {
        var ranges = [[String : NSRange]]()
        attributedText.enumerateAttribute(ImageAttributeName, in: NSRange(location: 0, length: attributedText.length), options: []) { (value, range, stop) in
            guard let value = value as? String else { return }
            
            ranges.append([value : range])
        }
        
        return ranges
    }
    
    func range(of imageHash:String) -> NSRange? {
        var imageRange:NSRange? = nil
        
        attributedText.enumerateAttribute(ImageAttributeName, in: NSRange(location: 0, length: attributedText.length), options: []) { (value, range, stop) in
            guard let value = value as? String , value == imageHash else { return }
            imageRange = range
        }
        
        return imageRange
    }
    
    func insertImage(_ name:String, image:UIImage, width:CGFloat) {
        if let attrText = attributedText.mutableCopy() as? NSMutableAttributedString {
            attrText.append(NSAttributedString(string: "\n"))
            
            let _ = text.lengthOfBytes(using: String.Encoding.utf8)
            
            attributedText = attrText
            
            let ratio   = CGFloat(width / image.size.width)
            let width   = image.size.width * ratio
            let height  = image.size.height * ratio
            let size    = CGSize(width: width, height: height)
            
            insertImage(name, image: image, size: size)
            newline()
        }
    }
    
    func insertImage(_ name:String, image:UIImage, size:CGSize) {
        let attachment      = NSTextAttachment(data: nil, ofType: nil)
        attachment.image    = image
        attachment.bounds   = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        
        if let attachedAttributedString = NSAttributedString(attachment: attachment) as? NSMutableAttributedString {
            attachedAttributedString.addAttributes([NSParagraphStyleAttributeName: paragraphStyle(0), DetectedDataHandlerAttributeName: DetectedType.image.rawValue], range: NSRange(location: 0, length: attachedAttributedString.length))
            
            if let attrString = attributedText.mutableCopy() as? NSMutableAttributedString {
                attrString.append(attachedAttributedString)
                
                attributedText = attrString
            }
        }
    }
    
    func insertImage(_ name:String, image:UIImage, size:CGSize, at index:Int) -> NSRange{
        let attachment      = NSTextAttachment(data: nil, ofType: nil)
        attachment.image    = image
        attachment.bounds   = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        
        if let attachmentAttributedString = NSAttributedString(attachment: attachment) as? NSMutableAttributedString {
            let paragraphStyle                      = NSMutableParagraphStyle()
            paragraphStyle.paragraphSpacing         = 10
            paragraphStyle.paragraphSpacingBefore   = 10
            let attr: [String: AnyObject]           = [NSParagraphStyleAttributeName: paragraphStyle, ImageAttributeName: name as AnyObject, DetectedDataHandlerAttributeName: DetectedType.image.rawValue as AnyObject]
            
            attachmentAttributedString.addAttributes(attr, range: NSRange(location: 0, length: attachmentAttributedString.length))
            
            if let attrString = self.attributedText.mutableCopy() as? NSMutableAttributedString {
                attrString.insert(attachmentAttributedString, at: index)
                let range = NSMakeRange(index, attachmentAttributedString.length)
                self.attributedText = attrString
                return range
            }
        }
        return NSMakeRange(0, 0)
    }
    
    func removeImage(_ range:NSRange){
        if let attrString = self.attributedText.mutableCopy() as? NSMutableAttributedString {
            attrString.replaceCharacters(in: range, with: "")
            self.attributedText = attrString
        }
    }
}

extension WWHTMLTextView /* Drawing */ {
    func placeholderFrame(_ frame:CGRect) -> CGRect {
        var bounds       = frame
        bounds.origin.x += textContainer.lineFragmentPadding
        bounds.origin.y += textContainer.lineFragmentPadding
        
        return bounds
    }
    
    func drawHighlight(_ frame:CGRect, range: NSRange) {
        let layer               = CALayer()
        layer.frame             = frame
        layer.backgroundColor   = highlightColor.cgColor
        layer.cornerRadius      = 4.0
        layer.masksToBounds     = true
        
        self.layer.addSublayer(layer)
        
        let delay = DispatchTime.now() + Double(Int64(0.4 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: delay) {
            layer.removeFromSuperlayer()
        }
    }
}

extension WWHTMLTextView : UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}




