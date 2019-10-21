//
//  RepositoryMock.swift
//  TesteGitHub
//
//  Created by Victor Rabelo on 19/10/19.
//  Copyright © 2019 Victor. All rights reserved.
//

import UIKit

class RepositoryMock: RepositoryProtocol {
    
    var fetchDataResponse: ServiceResponseModel!
    var imageData: Data!
    
    func fetchGitData(page: Int, completion: @escaping ((RepositoryResult<ServiceResponseModel>) -> Void)) {
        if fetchDataResponse == nil {
            completion(RepositoryResult<ServiceResponseModel>.failure(error: RepositoryError(errorType: .unknown)))
        } else {
            completion(RepositoryResult<ServiceResponseModel>.success(value: fetchDataResponse))
        }
    }
    
    func downloadProfileImage(imageURL: String, completion: @escaping ((RepositoryResult<Data>) -> Void)) {
        completion(RepositoryResult<Data>.success(value: imageData))
    }
}
