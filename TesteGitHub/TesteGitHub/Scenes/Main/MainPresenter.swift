//
//  MainPresenter.swift
//  TesteGitHub
//
//  Created by Victor Rabelo on 19/10/19.
//  Copyright © 2019 Victor. All rights reserved.
//


import UIKit

protocol MainPresentationLogic {
    func presentData(response: MainModels.ShowGitData.Response)
    func presentCellImage(response: MainModels.DownloadImage.Response)
    func presentRepository(response: MainModels.OpenRepository.Response)
    func presentAlert(response: MainModels.Alert.Response)
}

class MainPresenter: MainPresentationLogic {
    
    weak var viewController: MainDisplayLogic?
    
    func presentData(response: MainModels.ShowGitData.Response) {
        viewController?.displayGitData(viewObject: MainModels.ShowGitData.VO(data: response.data))
    }
    
    func presentCellImage(response: MainModels.DownloadImage.Response) {
        if let image = UIImage(data: response.imageData) {
            viewController?.displayCellImage(viewObject: MainModels.DownloadImage.VO(cell: response.cell, image: image))
        }
    }
    
    func presentRepository(response: MainModels.OpenRepository.Response) {
        viewController?.displayRepository(viewObject: MainModels.OpenRepository.VO(url: response.url))
    }
    
    func presentAlert(response: MainModels.Alert.Response) {
        viewController?.displayError(viewObject: MainModels.Alert.VO(title: "Erro", description: "Ocorreu um erro."))
    }
}
