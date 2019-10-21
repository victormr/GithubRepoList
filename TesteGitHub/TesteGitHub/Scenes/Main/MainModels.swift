//
//  MainModels.swift
//  TesteGitHub
//
//  Created by Victor Rabelo on 20/10/19.
//  Copyright © 2019 Victor. All rights reserved.
//

import UIKit

enum MainModels {
    enum DidLoad {
        struct Request { }
        struct Response { }
        struct VO { }
    }
    
    enum PreFetchData {
        struct Request {
            let index: Int
        }
        struct Response { }
        struct VO { }
    }
    
    enum RefreshData {
        struct Request { }
        struct Response { }
        struct VO { }
    }
    
    enum DownloadImage {
        struct Request {
            let cell: MainTableViewCell
            let url: String
        }
        struct Response {
            let cell: MainTableViewCell
            let imageData: Data
        }
        struct VO {
            let cell: MainTableViewCell
            let image: UIImage
        }
    }
    
    enum ShowGitData {
        struct Request { }
        struct Response {
            let data: ServiceResponseModel
        }
        struct VO {
            let data: ServiceResponseModel
        }
    }
    
    enum OpenRepository {
        struct Request {
            let url: String
        }
        struct Response {
            let url: String
        }
        struct VO {
            let url: String
        }
    }
    
    enum Alert {
        struct Request { }
        struct Response { }
        struct VO {
            let title: String
            let description: String
        }
    }
}

