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
        super.updateViewConstraints()
    }
}