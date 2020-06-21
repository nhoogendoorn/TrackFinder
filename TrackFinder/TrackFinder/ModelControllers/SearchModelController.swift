//
//  SearchModelController.swift
//  TrackFinder
//
//  Created by Niels Hoogendoorn on 20/06/2020.
//  Copyright © 2020 Nihoo. All rights reserved.
//

import Foundation

class SearchModelController: ObservableObject, DependencyResolver {
    var data: [TrackItem] = []
    var nextPageUrl: String?
    
    var searchService: SearchServiceProtocol? {
        container?.resolve(SearchServiceProtocol.self)
    }
    
    weak var delegate: SearchScreenViewControllerProtocol?
        
    func loadData(search: String?) {
        guard let search = search, search.isEmpty == false else { resetData(); return }
        
        searchService?.searchTrack(query: search, completion: { [weak self] result in
            guard let `self` = self else { return }
            if let searchResponse = try? result.get() {
                DispatchQueue.main.async {
                    self.data = searchResponse.tracks.items
                    self.nextPageUrl = searchResponse.tracks.next
                    self.delegate?.searchStateChanged(state: self)
                }
            }
        })
    }
    
    func loadNextPage() {
        searchService?.loadNextPage(nextPageUrl: nextPageUrl, completion: { [weak self] result in
            guard let `self` = self else { return }
            if let searchResponse = try? result.get() {
                DispatchQueue.main.async {
                    self.data.append(contentsOf: searchResponse.tracks.items)
                    self.nextPageUrl = searchResponse.tracks.next
                    self.delegate?.searchStateChanged(state: self)
                }
            }
        })
    }
    
    func resetData() {
        DispatchQueue.main.async {
            self.data = []
            self.nextPageUrl = nil
            self.delegate?.searchStateChanged(state: self)
        }
    }
}
