//
//  MainViewController.swift
//  TesteGitHub
//
//  Created by Victor Rabelo on 19/10/19.
//  Copyright © 2019 Victor. All rights reserved.
//

import UIKit

protocol MainDisplayLogic: class {
    func displayGitData(viewObject: MainModels.ShowGitData.VO)
    func displayCellImage(viewObject: MainModels.DownloadImage.VO)
    func displayRepository(viewObject: MainModels.OpenRepository.VO)
    func displayError(viewObject: MainModels.Alert.VO)
}

// MARK: Lifecycle
class MainViewController: UIViewController {
    
    var interactor: MainBusinessLogic?
    var router: MainRoutingLogic?
    
    fileprivate lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: UITableView.Style.plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        // Delegates
        tableView.delegate = self
        tableView.dataSource = self
        tableView.prefetchDataSource = self
        // Setup
        tableView.addSubview(refreshControl)
        tableView.register(MainTableViewCell.self, forCellReuseIdentifier: reusableCellIdentifier)
        tableView.estimatedRowHeight = 0
        return tableView
    }()
    
    fileprivate lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.handleRefresh(_:)), for: .valueChanged)
        
        return refreshControl
    }()
    
    var gitData: [ServiceResponseModelItem]?
    fileprivate let reusableCellIdentifier = "reusableCell"
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        MainConfigurator.config(self)
        
        setupUI()
        
        interactor?.handleDidLoad(request: MainModels.DidLoad.Request())
    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        gitData = nil
        interactor?.handleRefreshData(request: MainModels.RefreshData.Request())
        refreshControl.endRefreshing()
    }
}

// MARK: UI methods
fileprivate extension MainViewController {
    func setupUI() {
        view.addSubview(tableView)
        do {
            try tableView.toEdges()
        } catch {
            print("Algo deu errado")
        }
    }
}

// MARK: MainDisplayLogic
extension MainViewController: MainDisplayLogic {
    func displayGitData(viewObject: MainModels.ShowGitData.VO) {
        DispatchQueue.main.async {
            if self.gitData == nil {
                self.gitData = viewObject.data.items
                self.tableView.reloadData()
            } else {
                let atualSections = self.tableView.numberOfSections
                let newSections = (viewObject.data.items.count / itensPerPage)
                self.gitData?.append(contentsOf: viewObject.data.items)
                self.tableView.insertSections(IndexSet(integersIn: atualSections-1..<atualSections+newSections-1), with: .none)
            }
        }
    }
    
    func displayCellImage(viewObject: MainModels.DownloadImage.VO) {
        viewObject.cell.setImage(image: viewObject.image)
    }
    
    func displayRepository(viewObject: MainModels.OpenRepository.VO) {
        router?.routeToRepository(repositoryURL: viewObject.url)
    }
    
    func displayError(viewObject: MainModels.Alert.VO) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: viewObject.title, message: viewObject.description, preferredStyle: .alert)
            self.present(alert, animated: true, completion: nil)
        }
    }
}

// MARK: UITableViewDelegate
extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let url = gitData?[indexPath.row].html_url {
            interactor?.handleOpenRepository(request: MainModels.OpenRepository.Request(url: url))
        }
    }
}

// MARK: UITableViewDataSource
extension MainViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return ((gitData?.count ?? 0) / itensPerPage) + 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableView.numberOfSections == section + 1 ? 1 : itensPerPage
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: reusableCellIdentifier) as? MainTableViewCell {
            let index = indexPath.section * itensPerPage + indexPath.row
            if let atualMax = gitData?.count,
                atualMax > index,
                let model = gitData?[index] {
                cell.delegate = self
                cell.setModel(model: model)
            }
            return cell
        }
        return UITableViewCell()
    }
}

// MARK: UITableViewDataSourcePrefetching
extension MainViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        var lastSection = 0
        indexPaths.forEach { item in
            if item.section > lastSection {
                lastSection = item.section
            }
        }
        interactor?.handlePreFetchData(request: MainModels.PreFetchData.Request(index: lastSection))
    }
}

// MARK: MainTableViewCellProtocol
extension MainViewController: MainTableViewCellProtocol {
    func requestImage(_ cell: MainTableViewCell, imageURL: String) {
        interactor?.handleDownloadImage(request: MainModels.DownloadImage.Request(cell: cell, url: imageURL))
    }
}
