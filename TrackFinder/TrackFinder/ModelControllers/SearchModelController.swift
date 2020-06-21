//
//  SearchModelController.swift
//  TrackFinder
//
//  Created by Niels Hoogendoorn on 20/06/2020.
//  Copyright © 2020 Nihoo. All rights reserved.
//

import SwiftUI

class SearchModelController: ObservableObject, DependencyResolver {
    @Published var data: [TrackItem] = []
    var nextPageUrl: String?
    
    private let apiManager: ApiProtocol = ApiManager()
    
    var searchService: SearchServiceProtocol? {
        container?.resolve(SearchServiceProtocol.self)
    }
    
    func loadData(search: String) {
        searchService?.searchTrack(query: search, completion: { (result) in
            if let searchResponse = try? result.get() {
                DispatchQueue.main.async {
                    self.data = searchResponse.tracks.items
                    self.nextPageUrl = searchResponse.tracks.next
                }
            }
        })
    }
    
    func loadNextPage() {
        searchService?.loadNextPage(nextPageUrl: nextPageUrl, completion: { (result) in
                        if let searchResponse = try? result.get() {
                DispatchQueue.main.async {
                    self.data.append(contentsOf: searchResponse.tracks.items)
                    self.nextPageUrl = searchResponse.tracks.next
                }
            }
        })
    }
}
