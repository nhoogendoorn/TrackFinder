//
//  SearchScreenViewController+Views.swift
//  TrackFinder
//
//  Created by Niels Hoogendoorn on 23/06/2020.
//  Copyright © 2020 Nihoo. All rights reserved.
//

import Foundation

extension SearchScreenViewController {
    func setView() {
        setSearchBarView()
        setTableView()
    }
    
    fileprivate func setTableView() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.leading.trailing.top.bottom.equalToSuperview()
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.addSubview(loader)
        
        loader.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(Spacing.medium.rawValue)
        }
        loader.hidesWhenStopped = true
        loader.stopAnimating()
    }
    
    fileprivate func setSearchBarView() {
        searchController.searchBar.placeholder = .search
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
    }
}
