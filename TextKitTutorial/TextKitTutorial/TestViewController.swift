//
//  TestViewController.swift
//  TextKitTutorial
//
//  Created by Yuchen Nie on 10/4/16.
//  Copyright © 2016 WeddingWire. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class TestViewController:UIViewController {
    private lazy var signatureBox:SignatureBoxView = {
       let view = SignatureBoxView()
        self.view.addSubview(view)
        return view
    }()
    
    override func viewDidLoad() {
        self.view.backgroundColor = UIColor.white
        updateViewConstraints()
        signatureBox.setNeedsUpdateConstraints()
        signatureBox.updateConstraintsIfNeeded()
        super.viewDidLoad()
    }
    
    override func updateViewConstraints() {
        signatureBox.snp.updateConstraints { (make) in
            make.top.leading.trailing.equalTo(self.view)
            make.height.equalTo(self.view).multipliedBy(0.5)
        }
        
        super.updateViewConstraints()
    }
}
