//
//  SignatureBox.swift
//  TextKitTutorial
//
//  Created by Yuchen Nie on 10/4/16.
//  Copyright © 2016 WeddingWire. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class SignatureBoxView:UIView {
    lazy var signatureBoxImage:SignatureImageView = {
        let imageView = SignatureImageView()
        imageView.isUserInteractionEnabled = true
        self.addSubview(imageView)
        return imageView
    }()
    
    private lazy var btnClear:UIButton = {
        let button = UIButton()
        button.setTitle("Clear", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.backgroundColor = UIColor.lightGray
        button.addTarget(self, action: #selector(clearImage), for: .touchUpInside)
        self.addSubview(button)
        return button
    }()
    
    private lazy var btnSubmit:UIButton = {
        let button = UIButton()
        button.setTitle("Submit", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.backgroundColor = UIColor.lightGray
        button.addTarget(self, action: #selector(submitPressed), for: .touchUpInside)
        self.addSubview(button)
        return button
    }()
    
    override func updateConstraints() {
        signatureBoxImage.snp.updateConstraints { (make) in
            make.leading.trailing.top.equalTo(self).inset(10)
            make.height.equalTo(70)
        }
        
        btnSubmit.snp.updateConstraints { (make) in
            make.leading.equalTo(self).inset(10)
            make.top.equalTo(signatureBoxImage.snp.bottom).offset(10)
            make.bottom.equalTo(self).inset(10)
            make.width.lessThanOrEqualTo(self).multipliedBy(0.5)
            make.height.equalTo(44)
        }
        
        btnClear.snp.updateConstraints { (make) in
            make.trailing.equalTo(self).inset(10)
            make.top.bottom.width.height.equalTo(btnSubmit)
            make.leading.equalTo(btnSubmit.snp.trailing).offset(10)
        }
        super.updateConstraints()
    }
}

extension SignatureBoxView {

}

extension SignatureBoxView {
    func clearImage() {
        signatureBoxImage.image = nil
    }
    
    func submitPressed() {
        print("function has not been implemented")
    }
}
