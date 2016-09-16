//
//  HeartRateViewController.swift
//  BluetoothTutorial
//
//  Created by Yuchen Nie on 9/16/16.
//  Copyright © 2016 Yuchen Nie. All rights reserved.
//

import Foundation
import UIKit
import SnapKit



class HeartRateViewController : UIViewController {
    private lazy var bpmLabel:UILabel = {
        let label = UILabel()
        
        self.view.addSubview(label)
        return label
    }()
    
    private lazy var connectedLabel:UILabel = {
        let label = UILabel()
        
        self.view.addSubview(label)
        return label
    }()
    
    private lazy var bodyLocationLabel:UILabel = {
        let label = UILabel()
        
        self.view.addSubview(label)
        return label
    }()
    
    private lazy var manufacturerLabel:UILabel = {
        let label = UILabel()
        
        self.view.addSubview(label)
        return label
    }()
    
    override func updateViewConstraints() {
        bpmLabel.snp.updateConstraints { (make) in
            make.leading.trailing.top.equalTo(view).inset(10)
        }
        
        super.updateViewConstraints()
    }
}

extension HeartRateViewController: BluetoothDelegate{
    
}
