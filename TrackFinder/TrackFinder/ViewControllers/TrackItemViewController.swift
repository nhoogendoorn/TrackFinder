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
    let scrollView = UIScrollView()
    let coverImage = NetworkImageView()
    
    let trackInfoView = UIView()
    let trackInfoStackView = UIStackView()
    let trackTitle = UILabel()
    let trackArtistStackView = UIStackView()
    let trackArtistImageView = NetworkImageView()
    let trackArtistNameLabel = UILabel()
    
    let trackAlbumTitle = UILabel()
    
    let refreshControl = UIRefreshControl()
    let modelController: TrackItemModelController
    
    let playTrackStackView = UIStackView()
    let playImage = UIImageView(image: UIImage(systemName: "play.circle.fill"))
    let playTextLabel = UILabel()
//    let durationText = UILabel()
    
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
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints {
            $0.leading.centerX.trailing.bottom.equalToSuperview()
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
        }
        modelController.delegate = self
        scrollView.addSubview(coverImage)
        coverImage.snp.makeConstraints {
            $0.leading.trailing.top.equalToSuperview()
            $0.height.equalTo(coverImageHeight)
            $0.width.equalTo(view)
        }        
        scrollView.refreshControl = refreshControl
        coverImage.contentMode = .scaleAspectFill
        coverImage.clipsToBounds = true
        
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        
        coverImage.addSubview(trackInfoView)
        trackInfoView.snp.makeConstraints {
            $0.leading.trailing.top.bottom.equalToSuperview()
        }
        trackInfoView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        
        trackInfoView.addSubview(trackInfoStackView)
        trackInfoStackView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(Spacing.large.rawValue)
            $0.trailing.bottom.equalToSuperview().offset(-Spacing.large.rawValue)
        }
        trackInfoStackView.spacing = Spacing.extraSmall.rawValue
        trackInfoStackView.axis = .vertical
        
        trackTitle.font = UIFont.systemFont(ofSize: FontSize.extraLargeTitle.value)
        trackTitle.textColor = .white
        trackTitle.numberOfLines = .zero
        trackTitle.lineBreakMode = .byWordWrapping
        
        trackArtistImageView.snp.makeConstraints {
            $0.width.height.equalTo(Size.large.rawValue)
        }
        trackArtistImageView.clipsToBounds = true
        
        trackArtistNameLabel.font = UIFont.systemFont(ofSize: FontSize.subTitle.value)
        trackArtistNameLabel.textColor = .white
        trackAlbumTitle.font = UIFont.systemFont(ofSize: FontSize.body.value)
        trackAlbumTitle.textColor = .white
        
        trackArtistStackView.spacing = Spacing.small.rawValue
        trackArtistStackView.addArrangedSubview(trackArtistImageView)
        trackArtistStackView.addArrangedSubview(trackArtistNameLabel)
             
        trackInfoStackView.addArrangedSubview(trackTitle)
        trackInfoStackView.addArrangedSubview(trackArtistStackView)
        trackInfoStackView.addArrangedSubview(trackAlbumTitle)
        
        scrollView.addSubview(playTrackStackView)
        playTrackStackView.snp.makeConstraints {
            $0.top.equalTo(coverImage.snp.bottom).offset(Spacing.mediumLarge.rawValue)
            $0.leading.equalToSuperview().offset(Spacing.mediumLarge.rawValue)
            $0.trailing.equalToSuperview().offset(-Spacing.mediumLarge.rawValue)
            $0.bottom.equalToSuperview()
        }
        playTrackStackView.distribution = .fill
        playTrackStackView.spacing = Spacing.small.rawValue
        
        playImage.snp.makeConstraints {
            $0.width.height.equalTo(Size.huge.rawValue)
        }
        //        playImage.contentMode = .scaleAspectFit
        playImage.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        playImage.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(playButtonPressed))
        playImage.addGestureRecognizer(tapGesture)
        playImage.tintColor = .mainColor
        
        playTextLabel.text = .playTrack
//        durationText.text = "3:03"
        //        durationText.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        playTrackStackView.addArrangedSubview(playImage)
        playTrackStackView.addArrangedSubview(playTextLabel)
//        playTrackStackView.addArrangedSubview(durationText)
        
        setData()
        modelController.getArtistInformation()
    }
    
    @objc func playButtonPressed() {
        guard let url = URL(string: modelController.data.uri) else { return }
        UIApplication.shared.open(url)
    }
    
    func setData() {
        trackTitle.text = modelController.data.name
        trackArtistNameLabel.text = modelController.data.artists.first?.name
        trackAlbumTitle.text = modelController.albumTitle
        coverImage.loadImage(with: modelController.data.album.images.randomElement()?.url,
                             cacheKey: modelController.data.album.id)
    }
    
    func setArtistImage() {
        trackArtistImageView.loadImage(with: modelController.artist?.images.first?.url,
                                       cacheKey: modelController.artist?.id)
    }
    
    @objc func handleRefresh() {
        modelController.refreshData()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        trackArtistImageView.layer.cornerRadius = Size.large.rawValue / 2
    }
}
