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
    
    let tableView = UITableView()
    let loader = UIActivityIndicatorView(style: .medium)
    let cellId: String = "SearchItemCell"
        
    let searchController = UISearchController(searchResultsController: nil)
    
    var searchTask: DispatchWorkItem?
    var isLoadingNextPage: Bool = false
    
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
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        self.title = .appTitle
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SearchItemCell.self, forCellReuseIdentifier: cellId)
        tableView.backgroundView = TableViewBackgroundView()
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.keyboardDismissMode = .onDrag
        tableView.addSubview(loader)
        
        loader.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(16)
        }
        loader.hidesWhenStopped = true
        loader.stopAnimating()
        
        modelController.delegate = self
        
    }
    
    func searchStateChanged(state: SearchModelController) {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.tableView.backgroundView = state.data.isEmpty ? TableViewBackgroundView() : nil
            self.loader.stopAnimating()
        }
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
        label.text = .startSearching
        label.textColor = .gray
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SearchScreenViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBarText = searchController.searchBar.text
        guard
            let text = searchBarText,
            text != .empty
        else {
            self.modelController.resetData()
            self.searchTask?.cancel()
            return
        }
        
        if modelController.data.isEmpty {
            loader.startAnimating()
        }        
        throttledSearchTask(text: text)
    }
    
    func throttledSearchTask(text: String) {
        let throttleTime: Double = 0.5
        let deadline: DispatchTime = DispatchTime.now() + throttleTime
        self.searchTask?.cancel()

        let task = DispatchWorkItem { [weak self] in
            self?.modelController.loadData(search: text)
        }
        self.searchTask = task

        DispatchQueue.main.asyncAfter(deadline: deadline, execute: task)

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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard modelController.data.indices.contains(indexPath.row) else { return }
        let item = modelController.data[indexPath.row]
        let detailVC = TrackItemViewController(item: item)
        detailVC.setData()
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(detailVC, animated: true)
        }        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let isLastCell = indexPath.row == modelController.data.count - 1
        // Only continue when there is no active task to load the next page.
        // This to insure that 
        guard isLastCell, isLoadingNextPage == false else { return }
        self.modelController.loadNextPage()
    }
}
