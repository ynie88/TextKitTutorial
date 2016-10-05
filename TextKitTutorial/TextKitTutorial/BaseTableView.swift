//
//  BaseTableView.swift
//  TextKitTutorial
//
//  Created by Yuchen Nie on 4/18/16.
//  Copyright © 2016 WeddingWire. All rights reserved.
//

import Foundation
import UIKit

class BaseTableView: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(BaseCell.self, forCellReuseIdentifier: BaseCell.identifier)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BaseCell.identifier, for: indexPath)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
