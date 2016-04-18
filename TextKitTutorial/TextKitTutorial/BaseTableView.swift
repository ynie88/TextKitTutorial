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
        
        tableView.registerClass(BaseCell.self, forCellReuseIdentifier: BaseCell.identifier)
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(BaseCell.identifier, forIndexPath: indexPath)
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
}