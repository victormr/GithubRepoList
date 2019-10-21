//
//  MainViewControllerTests.swift
//  TesteGitHubTests
//
//  Created by Victor Rabelo on 20/10/19.
//  Copyright © 2019 Victor. All rights reserved.
//

import XCTest
@testable import TesteGitHub

class MainViewControllerTests: XCTestCase {

    var sut: MainViewController!
    var routerSpy = MainRoutingLogicSpy()
    
    override func setUp() {
        super.setUp()
        sut = MainViewController()
        sut.router = routerSpy
    }

    override func tearDown() {
        sut.router = nil
        sut = nil
        super.tearDown()
    }
    
    func testDisplayCellImage() {
        // Arrange
        let image = UIImage()
        let cell = MainTableViewCell()
        
        // Action
        sut.displayCellImage(viewObject: MainModels.DownloadImage.VO(cell: cell, image: image))
        
        // Assert
        DispatchQueue.main.async {
            XCTAssertEqual(image, cell.imageView?.image)
        }
    }
    
    func testDisplayRepository() {
        // Arrange
        let url = "repositoryURL"
        
        // Action
        sut.displayRepository(viewObject: MainModels.OpenRepository.VO(url: url))
        
        // Assert
        XCTAssertEqual(url, routerSpy.url)
    }
}

class MainRoutingLogicSpy: MainRoutingLogic {
    
    var url: String!
    
    func routeToRepository(repositoryURL: String) {
        url = repositoryURL
    }
}
