//
//  MainInteractorTests.swift
//  TesteGitHubTests
//
//  Created by Victor Rabelo on 20/10/19.
//  Copyright © 2019 Victor. All rights reserved.
//

import XCTest
@testable import TesteGitHub

class MainInteractorTests: XCTestCase {

    var sut: MainInteractor!
    var presenterSpy = MainPresentationLogicSpy()
    var repositorySpy = RepositoryMock()
    
    override func setUp() {
        super.setUp()
        sut = MainInteractor()
        sut.presenter = presenterSpy
        sut.repository = repositorySpy
    }
    
    override func tearDown() {
        sut.presenter = nil
        sut = nil
        super.tearDown()
    }

    func testHandleDidLoad() {
        // Arrange
        let response = ServiceResponseModel(items: [ServiceResponseModelItem(name: "name", stargazers_count: 1, html_url: "url", owner: nil)], total_count: 1)
        repositorySpy.fetchDataResponse = response
        
        // Action
        sut.handleDidLoad(request: MainModels.DidLoad.Request())
        
        // Assert
        XCTAssertEqual(2, sut.currentFetchedPage)
        XCTAssertEqual(response, presenterSpy.presentedData)
    }
    
    func testHandleDidLoad1() {
        // Arrange
        repositorySpy.fetchDataResponse = nil
        
        // Action
        sut.handleDidLoad(request: MainModels.DidLoad.Request())
        
        // Assert
        XCTAssertEqual(2, sut.currentFetchedPage)
        XCTAssertTrue(presenterSpy.calledError)
    }
    
    func testeHandlePreFetchData() {
        // Arrange
        let response = ServiceResponseModel(items: [ServiceResponseModelItem(name: "name", stargazers_count: 1, html_url: "url", owner: nil)], total_count: 1)
        repositorySpy.fetchDataResponse = response
        
        // Action
        sut.handlePreFetchData(request: MainModels.PreFetchData.Request(index: 5))
        
        // Assert
        XCTAssertEqual(6, sut.currentFetchedPage)
        XCTAssertEqual(response, presenterSpy.presentedData)
    }
    
    func testHandleRefreshData() {
        // Arrange
        let response = ServiceResponseModel(items: [ServiceResponseModelItem(name: "name", stargazers_count: 1, html_url: "url", owner: nil)], total_count: 1)
        repositorySpy.fetchDataResponse = response
        sut.currentFetchedPage = 5
        
        // Action
        sut.handleRefreshData(request: MainModels.RefreshData.Request())
        
        // Assert
        XCTAssertEqual(2, sut.currentFetchedPage)
        XCTAssertEqual(response, presenterSpy.presentedData)
    }
    
    func testHandleDownloadImage() {
        // Arrange
        let cell = MainTableViewCell()
        let imageData = UIImage(named: "images")!.pngData()
        repositorySpy.imageData = imageData
        
        // Action
        sut.handleDownloadImage(request: MainModels.DownloadImage.Request(cell: cell, url: ""))
        
        // Assert
        XCTAssertEqual(cell, presenterSpy.cell)
        XCTAssertEqual(imageData, presenterSpy.imageData)
    }
}

class MainPresentationLogicSpy: MainPresentationLogic {
    
    var presentedData: ServiceResponseModel!
    var imageData: Data!
    var cell: MainTableViewCell!
    var calledError = false
    
    func presentData(response: MainModels.ShowGitData.Response) {
        presentedData = response.data
    }
    
    func presentCellImage(response: MainModels.DownloadImage.Response) {
        imageData = response.imageData
        cell = response.cell
    }
    
    func presentRepository(response: MainModels.OpenRepository.Response) {
        
    }
    
    func presentAlert(response: MainModels.Alert.Response) {
        calledError = true
    }
}
