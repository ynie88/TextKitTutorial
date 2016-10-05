//
//  ContainerTable.swift
//  TextKitTutorial
//
//  Created by Yuchen Nie on 9/12/16.
//  Copyright © 2016 WeddingWire. All rights reserved.
//

import Foundation
import UIKit
import SnapKit


class ContainerTable:UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func loadData() {
        
    }
    
}

extension ContainerTable {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
}
