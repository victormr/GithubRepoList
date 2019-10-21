//
//  RepositoryProtocol.swift
//  TesteGitHub
//
//  Created by Victor Rabelo on 19/10/19.
//  Copyright © 2019 Victor. All rights reserved.
//

import UIKit

protocol RepositoryProtocol {
    func fetchGitData(page: Int, completion: @escaping ((RepositoryResult<ServiceResponseModel>) -> Void))
    func downloadProfileImage(imageURL: String, completion: @escaping ((RepositoryResult<Data>) -> Void))
}

struct RepositoryError: Error {
    enum ErrorType {
        case requestLimit(reset: Date)
        case unknown
    }
    
    let errorType: ErrorType
}

enum RepositoryResult<T> {
    
    case success(value: T)
    case failure(error: RepositoryError)
    
    var value: T? {
        switch self {
        case .success(let value):
            return value
        case .failure:
            return nil
        }
    }
}
