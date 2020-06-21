//
//  SearchScreenViewController.swift
//  TrackFinder
//
//  Created by Niels Hoogendoorn on 17/06/2020.
//  Copyright © 2020 Nihoo. All rights reserved.
//

import UIKit

protocol SearchScreenViewControllerProtocol: class {
    func searchStateChanged(state: SearchModelController)
}

class SearchScreenViewController: UIViewController, SearchScreenViewControllerProtocol {
    let modelController = SearchModelController()
    
    let tableView = UITableView()
    let cellId: String = "SearchItemCell"
    
    let refreshControl = UIRefreshControl()
    let searchController = UISearchController(searchResultsController: nil)
    
    var searchTask: DispatchWorkItem?
    var nextPageTask: DispatchWorkItem?
    
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
                
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SearchItemCell.self, forCellReuseIdentifier: cellId)
        tableView.backgroundView = TableViewBackgroundView()
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
                
        modelController.delegate = self
        modelController.loadData(search: .empty)
        
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
    }
    
    func searchStateChanged(state: SearchModelController) {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
            self.tableView.backgroundView = state.data.isEmpty ? TableViewBackgroundView() : nil
        }
    }
    
    @objc func handleRefresh() {
        modelController.loadData(search: .empty)
    }
}

class TableViewBackgroundView: UIView {
    let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(label)
        label.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        label.text = "Start searching :)"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SearchScreenViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBarText = searchController.searchBar.text
        guard let text = searchBarText, text != .empty else { self.modelController.resetData(); return }
        throttledSearchTask(text: text)
    }
    
    func throttledSearchTask(text: String) {
        let throttleTime: Double = 0.75
        self.searchTask?.cancel()

        let task = DispatchWorkItem { [weak self] in
            self?.modelController.loadData(search: text)
        }
        self.searchTask = task

        // Execute task in 0.75 seconds (if not cancelled !)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + throttleTime, execute: task)

    }

}

extension SearchScreenViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        modelController.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        guard
            let searchItemCell = cell as? SearchItemCell,
            modelController.data.indices.contains(indexPath.row)
        else { return cell }
        
        searchItemCell.setText(trackItem: modelController.data[indexPath.row])
        return searchItemCell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let isLastCell = indexPath.row == modelController.data.count - 1
        guard isLastCell else { return }
        self.nextPageTask?.cancel()

        let task = DispatchWorkItem { [weak self] in
            self?.modelController.loadNextPage()
        }
        self.searchTask = task
        DispatchQueue.main.async(execute: task)
    }
}
