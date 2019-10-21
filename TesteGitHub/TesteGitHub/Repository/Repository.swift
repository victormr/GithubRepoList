//
//  Repository.swift
//  TesteGitHub
//
//  Created by Victor Rabelo on 19/10/19.
//  Copyright © 2019 Victor. All rights reserved.
//

import UIKit

class Repository: RepositoryProtocol {
    
    func fetchGitData(page: Int, completion: @escaping ((RepositoryResult<ServiceResponseModel>) -> Void)) {
        guard let url = URL(string: "https://api.github.com/search/repositories?q=language:swift&sort=stars&page=\(page)&per_page=\(itensPerPage)") else {
            completion(RepositoryResult<ServiceResponseModel>.failure(error: RepositoryError(errorType: .unknown)))
            return
        }
        
        let request = NSMutableURLRequest(url: url)
        request.setValue("token 0bccac27eeb5402d09a0e64added6b0def099f2f", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
            guard let data = data else {
                completion(RepositoryResult<ServiceResponseModel>.failure(error: RepositoryError(errorType: .unknown)))
                return
            }
            do {
                if let remainingRequests = (response as? HTTPURLResponse)?.allHeaderFields["X-RateLimit-Remaining"] as? String,
                    Int(remainingRequests) == 0,
                    let headerResetTime = (response as? HTTPURLResponse)?.allHeaderFields["X-RateLimit-Reset"] as? String,
                    let timeAsDouble = Double(headerResetTime) {
                    let timezoneOffset =  TimeZone.current.secondsFromGMT()
                    let timezoneEpochOffset = (timeAsDouble + Double(timezoneOffset))
                    let resetTime = Date(timeIntervalSince1970: timezoneEpochOffset)
                    completion(RepositoryResult<ServiceResponseModel>.failure(error: RepositoryError(errorType: .requestLimit(reset: resetTime))))
                }
                
                let decoder = JSONDecoder()
                let parsedData = try decoder.decode(ServiceResponseModel.self, from: data)
                completion(RepositoryResult<ServiceResponseModel>.success(value: parsedData))
            } catch {
                completion(RepositoryResult<ServiceResponseModel>.failure(error: RepositoryError(errorType: .unknown)))
            }
        }.resume()
    }
    
    func downloadProfileImage(imageURL: String, completion: @escaping ((RepositoryResult<Data>) -> Void)) {
        guard let url = URL(string: imageURL) else {
            completion(RepositoryResult<Data>.failure(error: RepositoryError(errorType: .unknown)))
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                completion(RepositoryResult<Data>.failure(error: RepositoryError(errorType: .unknown)))
                return
            }
            completion(RepositoryResult<Data>.success(value: data))
        }.resume()
    }
}
