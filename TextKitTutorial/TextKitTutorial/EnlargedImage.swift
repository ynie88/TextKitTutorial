//
//  EnlargedImage.swift
//  TextKitTutorial
//
//  Created by Yuchen Nie on 4/19/16.
//  Copyright © 2016 WeddingWire. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class EnlargeImageVC: UIViewController {
    private lazy var imageView:UIImageView = {imageView in
        imageView.contentMode = .ScaleAspectFit
        self.view.addSubview(imageView)
        return imageView
    }(UIImageView())
    
    private lazy var closeButton:UIButton = {button in
        button.setTitle("close", forState: .Normal)
        button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        button.addTarget(self, action: #selector(self.close), forControlEvents: .TouchUpInside)
        button.userInteractionEnabled = true
        self.view.addSubview(button)
        return button
    }(UIButton())
    
    func configWithImage(image:UIImage) {
        imageView.image = image

        view.setNeedsUpdateConstraints()
        view.updateConstraintsIfNeeded()
    }
    
    override func updateViewConstraints() {
        imageView.snp_updateConstraints { (make) in
            make.leading.trailing.equalTo(self.view)
            make.centerY.equalTo(self.view)
        }
        
        closeButton.snp_updateConstraints { (make) in
            make.leading.equalTo(self.view).offset(10)
            make.top.equalTo(self.view).offset(10)
        }
        
        super.updateViewConstraints()
    }
    
    func close() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}