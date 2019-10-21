//
//  ServiceResponseModel.swift
//  TesteGitHub
//
//  Created by Victor Rabelo on 19/10/19.
//  Copyright © 2019 Victor. All rights reserved.
//

import Foundation

struct ServiceResponseModel: Codable, Equatable {
    var items: [ServiceResponseModelItem]
    let total_count: Int
}
