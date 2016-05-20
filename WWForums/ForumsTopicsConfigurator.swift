//
//  ForumsTopicsConfigurator.swift
//  WWForums
//
//  Created by Yuchen Nie on 5/20/16.
//  Copyright © 2016 WeddingWire. All rights reserved.
//

import Foundation
import UIKit

extension ForumsTopicsViewController: ForumsTopicsPresenterOutput{}

extension ForumsTopicsInteractor:ForumsTopicsViewControllerOutput{}
extension ForumsTopicsPresenter: ForumsTopicsInteractorOutput{}

class ForumsTopicsConfigurator {
    static let sharedConfigurator = ForumsTopicsConfigurator()
    
    func configure(viewController: ForumsTopicsViewController) {
        let router = ForumsTopicsRouter()
        router.viewController = viewController
        viewController.router = router
        
        let presenter = ForumsTopicsPresenter()
        presenter.output = viewController
        
        let interactor = ForumsTopicsInteractor()
        interactor.output = presenter
    }
}