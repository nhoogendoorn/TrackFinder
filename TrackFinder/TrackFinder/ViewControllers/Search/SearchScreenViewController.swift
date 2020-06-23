//
//  SearchScreenViewController.swift
//  TrackFinder
//
//  Created by Niels Hoogendoorn on 17/06/2020.
//  Copyright © 2020 Nihoo. All rights reserved.
//

import UIKit
import Network

protocol SearchScreenViewControllerProtocol: class {
    var isLoadingNextPage: Bool { get set }
    func searchStateChanged(state: SearchModelController)    
}

class SearchScreenViewController: UIViewController, SearchScreenViewControllerProtocol {
    let modelController = SearchModelController()
    let monitor = NWPathMonitor()
    let queue = DispatchQueue(label: "InternetConnectionMonitor")
    var hasInternetConnection = true
    
    let tableView = SearchResultTableView()
    let loader = UIActivityIndicatorView(style: .medium)
    
    let searchController = UISearchController(searchResultsController: nil)
    
    var searchTask: DispatchWorkItem?
    var isLoadingNextPage: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        navigationController?.setNavigationBarHidden(false, animated: false)
        title = .appTitle
        setView()
        modelController.delegate = self
        addInternetConnectionObserver()
    }
    
    func searchStateChanged(state: SearchModelController) {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.tableView.showBackground(state.showBackground, with: state.errorMessage)
            self.loader.stopAnimating()
        }
    }
}
