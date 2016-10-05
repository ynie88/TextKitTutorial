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
    fileprivate lazy var imageView:UIImageView = {imageView in
        imageView.contentMode = .scaleAspectFit
        self.view.addSubview(imageView)
        return imageView
    }(UIImageView())
    
    fileprivate lazy var closeButton:UIButton = {button in
        button.setTitle("close", for: UIControlState())
        button.setTitleColor(UIColor.white, for: UIControlState())
        button.addTarget(self, action: #selector(self.close), for: .touchUpInside)
        button.isUserInteractionEnabled = true
        self.view.addSubview(button)
        return button
    }(UIButton())
    
    func configWithImage(_ image:UIImage) {
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
        self.dismiss(animated: true, completion: nil)
    }
}
