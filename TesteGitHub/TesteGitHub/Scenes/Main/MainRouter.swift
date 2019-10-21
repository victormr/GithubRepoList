//
//  MainRouter.swift
//  TesteGitHub
//
//  Created by Victor Rabelo on 19/10/19.
//  Copyright © 2019 Victor. All rights reserved.
//

import UIKit

protocol MainRoutingLogic {
    func routeToRepository(repositoryURL: String)
}

class MainRouter: MainRoutingLogic {
    
    weak var viewController: (UIViewController & MainDisplayLogic)?
    
    func routeToRepository(repositoryURL: String) {
        guard let url = URL(string: repositoryURL) else { return }
        UIApplication.shared.open(url)
    }
}
