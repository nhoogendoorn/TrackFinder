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
    
    var searchService: SearchServiceProtocol? {
        container?.resolve(SearchServiceProtocol.self)
    }
    
    weak var delegate: SearchScreenViewControllerProtocol?
        
    func loadData(search: String?) {
        guard let search = search, search.isEmpty == false else { resetData(); return }
        
        searchService?.searchTrack(query: search, completion: { [weak self] result in
            guard let `self` = self else { return }
            switch result {
            case .failure(let error):
                self.handleErrorResponse(error)
            case .success(let response):
                self.handleSuccessfulResponse(response)
            }
        })
    }
    
    fileprivate func handleErrorResponse(_ error: NetworkError) {        
        self.data = []
        self.nextPageUrl = nil
        self.errorMessage = error == .noResults ? .noTracksFound : .generalError
        self.delegate?.searchStateChanged(state: self)
    }
    
    fileprivate func handleSuccessfulResponse(_ response: SearchTrackResponse) {
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
                self.data.append(contentsOf: searchResponse.tracks.items)
                self.nextPageUrl = searchResponse.tracks.next
                self.delegate?.searchStateChanged(state: self)
            }
        })
    }
    
    func resetData() {        
        self.data = []
        self.nextPageUrl = nil
        self.errorMessage = nil
        self.delegate?.searchStateChanged(state: self)
    }
}
