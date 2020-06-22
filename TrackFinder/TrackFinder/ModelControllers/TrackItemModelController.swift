//
//  TrackItemModelController.swift
//  TrackFinder
//
//  Created by Niels Hoogendoorn on 21/06/2020.
//  Copyright © 2020 Nihoo. All rights reserved.
//

import Foundation

class TrackItemModelController: ObservableObject, DependencyResolver {
    var data: TrackItem    
    var artist: CompleteArtist?
    
    var albumTitle: String {
        "\(String.album) \(String.bullet) \(data.album.name)"
    }
    
    weak var delegate: TrackItemViewControllerDelegate?
    
    var trackItemService: TrackItemServiceProtocol? {
        container?.resolve(TrackItemServiceProtocol.self)
    }
    
    init(item: TrackItem) {
        data = item
    }
    
    func refreshData() {
        trackItemService?.getTrackItem(id: data.id, completion: { [weak self] result in
            guard let `self` = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .failure:
                    log.error("Error refreshing data")
                case .success(let item):
                    self.data = item
                    self.delegate?.setData()
                }
                
                self.delegate?.refreshControl.endRefreshing()
            }            
        })
    }
    
    func getArtistInformation() {
        guard let artistId = data.artists.first?.id else { return }
        trackItemService?.getArtist(id: artistId, completion: { [weak self] result in
            guard let `self` = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .failure:
                    log.error("Failed to get artist")
                case .success(let artist):
                    self.artist = artist
                    self.delegate?.setArtistImage()
                }
            }
        })
    }
}
