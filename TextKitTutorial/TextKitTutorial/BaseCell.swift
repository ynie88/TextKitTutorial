//
//  BaseCell.swift
//  TextKitTutorial
//
//  Created by Yuchen Nie on 4/18/16.
//  Copyright © 2016 WeddingWire. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class BaseCell: UITableViewCell {
    static let identifier = "BaseCellIdentifier"
    
    fileprivate lazy var textView:WWHTMLTextView = {
        let textView = WWHTMLTextView(frame: .zero)
        
        self.addSubview(textView)
        return textView
    }()
    
    func loadViewModel() {
        
    }
}
