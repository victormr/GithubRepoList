//
//  MainConfigurator.swift
//  TesteGitHub
//
//  Created by Victor Rabelo on 19/10/19.
//  Copyright © 2019 Victor. All rights reserved.
//

import UIKit

class MainConfigurator {
    static func config(_ viewController: UIViewController) {
        guard let vc = viewController as? MainViewController   else {
            return
        }
        
        let interactor = MainInteractor()
        let presenter = MainPresenter()
        let router = MainRouter()
        
        vc.interactor = interactor
        vc.router = router
        interactor.presenter = presenter
        interactor.repository = Repository()
        presenter.viewController = vc
        router.viewController = vc
    }
}
