//
//  PresenterTests.swift
//  TesteGitHubTests
//
//  Created by Victor Rabelo on 08/10/19.
//  Copyright © 2019 Victor. All rights reserved.
//

import XCTest
@testable import TesteGitHub

class PresenterTests: XCTestCase {

    var sut: MainPresenter!
    var displaySpy = MainDisplayLogicSpy()
    
    override func setUp() {
        super.setUp()
        sut = MainPresenter()
        sut.viewController = displaySpy
    }

    override func tearDown() {
        sut.viewController = nil
        sut = nil
        super.tearDown()
    }

    func testPresentData() {
        // Arrange
        let data = ServiceResponseModel(items: [ServiceResponseModelItem(name: "", stargazers_count: 1, html_url: "", owner: nil)], total_count: 1)
        
        // Action
        sut.presentData(response: MainModels.ShowGitData.Response(data: data))
        
        // Assert
        XCTAssertEqual(displaySpy.displayedData, data)
    }
    
    func testPresentCellImage() {
        // Arrange
        let cell = MainTableViewCell()
        let image = UIImage(named: "images")
        let pngImage = image?.pngData()
        
        // Action
        sut.presentCellImage(response: MainModels.DownloadImage.Response(cell: cell, imageData: image!.pngData()!))
        
        // Assert
        XCTAssertEqual(cell, displaySpy.cell)
        XCTAssertEqual(pngImage, displaySpy.image.pngData())
    }
    
    func testPresentRepository() {
        // Arrange
        let url = "urlTeste123"
        
        // Action
        sut.presentRepository(response: MainModels.OpenRepository.Response(url: url))
        
        // Assert
        XCTAssertEqual(url, displaySpy.url)
    }
}

class MainDisplayLogicSpy: MainDisplayLogic {
    
    var displayedData: ServiceResponseModel!
    var cell: MainTableViewCell!
    var image: UIImage!
    var url: String!
    
    func displayGitData(viewObject: MainModels.ShowGitData.VO) {
        displayedData = viewObject.data
    }
    
    func displayCellImage(viewObject: MainModels.DownloadImage.VO) {
        cell = viewObject.cell
        image = viewObject.image
    }
    
    func displayRepository(viewObject: MainModels.OpenRepository.VO) {
        url = viewObject.url
    }
}
