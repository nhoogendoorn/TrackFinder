//
//  SearchScreenViewController.swift
//  TrackFinder
//
//  Created by Niels Hoogendoorn on 17/06/2020.
//  Copyright © 2020 Nihoo. All rights reserved.
//

import Foundation

import UIKit
import Combine

class SearchScreenViewController: UIViewController {
    let modelController = SearchModelController()
    
    let tableView = UITableView()
    private var dataSubscriber: AnyCancellable?
    let cellId: String = "SearchItemCell"
    
    let refreshControl = UIRefreshControl()
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        navigationItem.hidesBackButton = true
        
        searchController.searchBar.placeholder = .search
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchResultsUpdater = self
        definesPresentationContext = true
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.leading.trailing.top.bottom.equalToSuperview()
        }
        tableView.addSubview(refreshControl)

        navigationItem.searchController = searchController
        
        dataSubscriber = modelController.$filteredResults.sink(receiveValue: { [weak self] _ in
            self?.stateChanged()
        })
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SearchItemCell.self, forCellReuseIdentifier: cellId)
        
        modelController.loadData()
        
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
    }
    
    func stateChanged() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
        }
    }
    
    @objc func handleRefresh() {
        modelController.loadData()
    }
}

extension SearchScreenViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        modelController.filterData(searchText: searchBar.text ?? .empty)
    }
    
}

extension SearchScreenViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        modelController.filteredResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        guard
            let searchItemCell = cell as? SearchItemCell,
            modelController.filteredResults.indices.contains(indexPath.row)
        else { return cell }
        
        searchItemCell.setText(text: modelController.filteredResults[indexPath.row])
        return searchItemCell
    }
}
