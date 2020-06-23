//
//  TrackItemViewController.swift
//  TrackFinder
//
//  Created by Niels Hoogendoorn on 21/06/2020.
//  Copyright © 2020 Nihoo. All rights reserved.
//

import UIKit
import Kingfisher

protocol TrackItemViewControllerDelegate: class {
    var refreshControl: UIRefreshControl { get }
    func setData()
    func setArtistImage()
}

class TrackItemViewController: UIViewController, TrackItemViewControllerDelegate {
    let modelController: TrackItemModelController
    let refreshControl = UIRefreshControl()
    
    let scrollView = UIScrollView()
    let coverImage = NetworkImageView()
    
    let trackInfoView = UIView()
    let trackInfoStackView = UIStackView()
    let trackTitle = UILabel()
    let trackArtistStackView = UIStackView()
    let trackArtistImageView = NetworkImageView()
    let trackArtistNameLabel = UILabel()
    let trackAlbumTitle = UILabel()
    
    let playTrackStackView = UIStackView()
    let playImage = UIImageView(image: UIImage(systemName: "play.circle.fill"))
    let playTextLabel = UILabel()
    
    let coverImageHeight: CGFloat = 304
    
    init(item: TrackItem) {
        self.modelController = TrackItemModelController(item: item)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = modelController.data.name
        modelController.delegate = self
        setView()
        refreshControl.addTarget(self,
                                 action: #selector(handleRefresh),
                                 for: .valueChanged)
        setData()        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        trackArtistImageView.layer.cornerRadius = Size.large.rawValue / 2
    }
    
    func setData() {
        trackTitle.text = modelController.data.name
        trackArtistNameLabel.text = modelController.data.artists.first?.name
        trackAlbumTitle.text = modelController.albumTitle
        coverImage.loadImage(with: modelController.data.album.images.randomElement()?.url,
                             cacheKey: modelController.data.album.id)
        modelController.getArtistInformation()
    }
    
    func setArtistImage() {
        trackArtistImageView.loadImage(with: modelController.artist?.images.first?.url,
                                       cacheKey: modelController.artist?.id)
    }
    
    @objc func playButtonPressed() {
        guard let url = URL(string: modelController.data.uri) else { return }
        UIApplication.shared.open(url)
    }
    
    @objc func handleRefresh() {
        modelController.refreshData()
    }
}
