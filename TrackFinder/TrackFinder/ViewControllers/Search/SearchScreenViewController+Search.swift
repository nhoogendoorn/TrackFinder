//
//  SearchScreenViewController+Search.swift
//  TrackFinder
//
//  Created by Niels Hoogendoorn on 23/06/2020.
//  Copyright © 2020 Nihoo. All rights reserved.
//

import Foundation

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
            self?.modelController.searchQuery(query: text)
        }
        self.searchTask = task

        DispatchQueue.main.asyncAfter(deadline: deadline, execute: task)

    }

}
