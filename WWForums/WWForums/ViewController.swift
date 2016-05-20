//
//  ViewController.swift
//  WWForums
//
//  Created by Yuchen Nie on 5/17/16.
//  Copyright © 2016 WeddingWire. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var interactor: ForumsTopicsInteractor!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.interactor = ForumsTopicsInteractor()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

