//
//  ContainerCell.swift
//  TextKitTutorial
//
//  Created by Yuchen Nie on 9/12/16.
//  Copyright © 2016 WeddingWire. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

struct DimensionConstants {
    static let margin:CGFloat = 10
}

class ContainerCell: UITableViewCell {
    static let idenitifer = "ContainerCellIdenitifer"
    
    var subContainerViews:[UIView] = [UIView]()
    
}
