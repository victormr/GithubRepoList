//
//  MainInteractor.swift
//  TesteGitHub
//
//  Created by Victor Rabelo on 19/10/19.
//  Copyright © 2019 Victor. All rights reserved.
//

import UIKit

protocol MainBusinessLogic {
    func handleDidLoad(request: MainModels.DidLoad.Request)
    func handlePreFetchData(request: MainModels.PreFetchData.Request)
    func handleRefreshData(request: MainModels.RefreshData.Request)
    func handleDownloadImage(request: MainModels.DownloadImage.Request)
    func handleOpenRepository(request: MainModels.OpenRepository.Request)
}

class MainInteractor: MainBusinessLogic {
    
    var presenter: MainPresentationLogic?
    var repository: RepositoryProtocol?
    var currentFetchedPage = 0
 
    func handleDidLoad(request: MainModels.DidLoad.Request) {
        fetchGitData(index: 1)
    }
    
    func handleDownloadImage(request: MainModels.DownloadImage.Request) {
        repository?.downloadProfileImage(imageURL: request.url) { (_ result: RepositoryResult<Data>) in
            switch result {
                case .success(let value):
                    self.presenter?.presentCellImage(response: MainModels.DownloadImage.Response(cell: request.cell, imageData: value))
                case .failure:
                    return
            }
        }
    }
    
    func handlePreFetchData(request: MainModels.PreFetchData.Request) {
        fetchGitData(index: request.index)
    }
    
    func handleRefreshData(request: MainModels.RefreshData.Request) {
        currentFetchedPage = 0
        fetchGitData(index: 1)
    }
    
    @objc private func fetchGitData(index: Int) {
        let newpage = index + 1
        if newpage > currentFetchedPage {
            let minPage = currentFetchedPage + 1
            currentFetchedPage = newpage
            for page in minPage...newpage {
                repository?.fetchGitData(page: page) { (_ result: RepositoryResult<ServiceResponseModel>) in
                    switch  result {
                    case .success(let value):
                        self.presenter?.presentData(response: MainModels.ShowGitData.Response(data: value))
                    case .failure(let error):
                        if case let RepositoryError.ErrorType.requestLimit(resetTime) = error.errorType {
                            let timer = Timer(fireAt: resetTime, interval: 1, target: self, selector: #selector(self.fetchGitData), userInfo: nil, repeats: false)
                            RunLoop.main.add(timer, forMode: .common)
                        } else {
                            self.presenter?.presentAlert(response: MainModels.Alert.Response())
                        }
                    }
                }
            }
        }
    }
    
    func handleOpenRepository(request: MainModels.OpenRepository.Request) {
        presenter?.presentRepository(response: MainModels.OpenRepository.Response(url: request.url))
    }
}
