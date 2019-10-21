//
//  Owner.swift
//  TesteGitHub
//
//  Created by Victor Rabelo on 19/10/19.
//  Copyright © 2019 Victor. All rights reserved.
//

import Foundation

struct Owner: Codable, Equatable {
    let login: String?
    let avatar_url: String?
    var image: Data?
}
