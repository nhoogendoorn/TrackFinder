//
//  SearchScreenViewController+UITableView.swift
//  TrackFinder
//
//  Created by Niels Hoogendoorn on 23/06/2020.
//  Copyright © 2020 Nihoo. All rights reserved.
//

import Foundation

extension SearchScreenViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        modelController.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.tableView.cellId, for: indexPath)
        guard
            let searchItemCell = cell as? SearchItemCell,
            modelController.data.indices.contains(indexPath.row)
        else { return cell }
        
        searchItemCell.setItem(trackItem: modelController.data[indexPath.row])
        return searchItemCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard modelController.data.indices.contains(indexPath.row) else { return }
        let item = modelController.data[indexPath.row]
        let detailVC = TrackItemViewController(item: item)
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(detailVC, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let isLastCell = indexPath.row == modelController.data.count - 1
        // Only continue when there is no previous load next page request in order
        // to not get possible duplicate results.
        guard isLastCell, isLoadingNextPage == false else { return }
        self.modelController.loadNextPage()
    }
}
