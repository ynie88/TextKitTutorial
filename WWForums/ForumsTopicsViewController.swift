//
//  ForumsTopicsViewController.swift
//  WWForums
//
//  Created by Yuchen Nie on 5/20/16.
//  Copyright © 2016 WeddingWire. All rights reserved.
//

import UIKit

protocol ForumsTopicsViewControllerInput {
    
}

protocol ForumsTopicsViewControllerOutput {
    
}

class ForumsTopicsViewController: UITableViewController, ForumsTopicsViewControllerInput {
    var output:ForumsTopicsViewControllerOutput!
    var router:ForumsTopicsRouter!
}
