//
//  ServiceResponseModelItem.swift
//  TesteGitHub
//
//  Created by Victor Rabelo on 19/10/19.
//  Copyright © 2019 Victor. All rights reserved.
//

import Foundation

struct ServiceResponseModelItem: Codable, Equatable {
    let name: String?
    var stargazers_count: Int
    var html_url: String
    var owner: Owner?
}
