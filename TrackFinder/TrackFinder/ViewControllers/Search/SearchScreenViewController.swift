//
//  SearchScreenViewController.swift
//  TrackFinder
//
//  Created by Niels Hoogendoorn on 17/06/2020.
//  Copyright © 2020 Nihoo. All rights reserved.
//

import UIKit

protocol SearchScreenViewControllerProtocol: class {
    var isLoadingNextPage: Bool { get set }
    func searchStateChanged(state: SearchModelController)
}

class SearchScreenViewController: UIViewController, SearchScreenViewControllerProtocol {
    let modelController = SearchModelController()
    
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
    }
    
    func searchStateChanged(state: SearchModelController) {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.tableView.showBackground(!state.data.isEmpty)
            self.loader.stopAnimating()
        }
    }
}
