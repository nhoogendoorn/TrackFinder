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
}

class TrackItemViewController: UIViewController, TrackItemViewControllerDelegate {
    let scrollView = UIScrollView()
    let coverImage = UIImageView()
    
    let trackInfoView = UIView()
    let trackInfoStackView = UIStackView()
    let trackTitle = UILabel()
    let trackArtistStackView = UIStackView()
    let trackArtistImageView = UIImageView()
    let trackArtistNameLabel = UILabel()
    
    let trackAlbumTitle = UILabel()
    
    let refreshControl = UIRefreshControl()
    let modelController: TrackItemModelController
    
    let playTrackStackView = UIStackView()
    let playImage = UIImageView(image: UIImage(systemName: "play.circle.fill"))
    let playTextLabel = UILabel()
    let durationText = UILabel()
    
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
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints {
            $0.leading.centerX.trailing.bottom.equalToSuperview()
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
        }
        modelController.delegate = self
        scrollView.addSubview(coverImage)
        coverImage.snp.makeConstraints {
            $0.leading.trailing.top.equalToSuperview()
            $0.height.equalTo(304)
            $0.width.equalTo(view)
        }        
        scrollView.refreshControl = refreshControl
        coverImage.contentMode = .scaleAspectFill
        coverImage.clipsToBounds = true
        setData()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        
        coverImage.addSubview(trackInfoView)
        trackInfoView.snp.makeConstraints {
            $0.leading.trailing.top.bottom.equalToSuperview()
        }
        trackInfoView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        
        trackInfoView.addSubview(trackInfoStackView)
        trackInfoStackView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(32)
            $0.trailing.bottom.equalToSuperview().offset(-32)
        }
        trackInfoStackView.spacing = 4
        trackInfoStackView.axis = .vertical
        
        trackTitle.font = UIFont.systemFont(ofSize: 40)
        trackTitle.textColor = .white
        trackTitle.numberOfLines = 0
        trackTitle.lineBreakMode = .byWordWrapping
        
        trackArtistNameLabel.font = UIFont.systemFont(ofSize: 18)
        trackArtistNameLabel.textColor = .white
        trackAlbumTitle.font = UIFont.systemFont(ofSize: 18)
        trackAlbumTitle.textColor = .white
        
        trackInfoStackView.addArrangedSubview(trackTitle)
        trackInfoStackView.addArrangedSubview(trackArtistNameLabel)
        trackInfoStackView.addArrangedSubview(trackAlbumTitle)
        
        scrollView.addSubview(playTrackStackView)
        playTrackStackView.snp.makeConstraints {
            $0.top.equalTo(coverImage.snp.bottom).offset(24)
            $0.leading.equalToSuperview().offset(24)
            $0.trailing.equalToSuperview().offset(-24)
            $0.bottom.equalToSuperview()
        }
        playTrackStackView.distribution = .fill
        playTrackStackView.spacing = 8
        
        playImage.snp.makeConstraints {
            $0.width.height.equalTo(24)
        }
//        playImage.contentMode = .scaleAspectFit
        playImage.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        
        playTextLabel.text = .playTrack
        durationText.text = "3:03"
//        durationText.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        playTrackStackView.addArrangedSubview(playImage)
        playTrackStackView.addArrangedSubview(playTextLabel)
        playTrackStackView.addArrangedSubview(durationText)
    }
    
    func setData() {
        trackTitle.text = modelController.data.name
        trackArtistNameLabel.text = modelController.data.artists.first?.name
        trackAlbumTitle.text = modelController.data.album.name
        setCoverImage()
    }
    
//    func setArtistImage() {
//        guard let urlString = modelController.data.artists.first.co.images.randomElement()?.url, let url = URL(string: urlString) else { return }
//
//        let resource = ImageResource(downloadURL: url, cacheKey: modelController.data.id)
//        trackArtistImageView.kf.setImage(with: resource)
//    }
    
    func setCoverImage() {
        guard let urlString = modelController.data.album.images.randomElement()?.url, let url = URL(string: urlString) else { return }
        
        let resource = ImageResource(downloadURL: url, cacheKey: modelController.data.id)
        coverImage.kf.indicatorType = .activity
        coverImage.kf.setImage(with: resource)
    }
    
    @objc func handleRefresh() {
        modelController.refreshData()
    }
}
