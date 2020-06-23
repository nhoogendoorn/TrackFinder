//
//  SearchModelController.swift
//  TrackFinder
//
//  Created by Niels Hoogendoorn on 20/06/2020.
//  Copyright © 2020 Nihoo. All rights reserved.
//

import Foundation

class SearchModelController: DependencyResolver {
    var data: [TrackItem] = []
    var nextPageUrl: String?
    var errorMessage: String?
    
    var searchService: SearchServiceProtocol?
    
    var showBackground: Bool { SearchModelHelper.showBackground(data: data) }
    
    weak var delegate: SearchScreenViewControllerProtocol?
    
    init() {
        searchService = container?.resolve(SearchServiceProtocol.self)
    }
    
    func searchQuery(query: String?) {
        guard
            SearchModelHelper.allowedToStartSearch(query: query),
            let query = query
        else {
            resetData()
            return
        }
        
        searchService?.searchTrack(query: query, completion: { [weak self] result in
            guard let `self` = self else { return }
            switch result {
            case .failure(let error):
                self.handleErrorResponse(error)
            case .success(let response):
                self.handleSuccessfulResponse(response)
            }
        })
    }
    
    func handleErrorResponse(_ error: NetworkError) {
        self.data = []
        self.nextPageUrl = nil
        self.errorMessage = SearchModelHelper.getErrorMessage(error)
        self.delegate?.searchStateChanged(state: self)
    }
    
    func handleSuccessfulResponse(_ response: SearchTrackResponse) {
        self.data = response.tracks.items
        self.nextPageUrl = response.tracks.next
        self.errorMessage = nil
        self.delegate?.searchStateChanged(state: self)
    }
    
    func loadNextPage() {
        delegate?.isLoadingNextPage = true
        searchService?.loadNextPage(nextPageUrl: nextPageUrl, completion: { [weak self] result in
            guard let `self` = self else { return }
            self.delegate?.isLoadingNextPage = false
            if let searchResponse = try? result.get() {
                self.handleLoadNextPageResponse(searchResponse)
            }
        })
    }
    
    func handleLoadNextPageResponse(_ response: SearchTrackResponse) {
        self.data.append(contentsOf: response.tracks.items)
        self.nextPageUrl = response.tracks.next
        self.delegate?.searchStateChanged(state: self)
    }
    
    func resetData() {        
        self.data = []
        self.nextPageUrl = nil
        self.errorMessage = nil
        self.delegate?.searchStateChanged(state: self)
    }
}
