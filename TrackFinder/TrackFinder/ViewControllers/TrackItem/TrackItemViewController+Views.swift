//
//  TrackItemViewController+Views.swift
//  TrackFinder
//
//  Created by Niels Hoogendoorn on 23/06/2020.
//  Copyright © 2020 Nihoo. All rights reserved.
//

import Foundation

extension TrackItemViewController {
    func setView() {
        setScrollView()
        setCoverImage()
        setTrackInfoView()
        setPlayTrackView()
    }
    
    fileprivate func setScrollView() {
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints {
            $0.leading.centerX.trailing.bottom.equalToSuperview()
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
        }
        scrollView.refreshControl = refreshControl
    }
    
    fileprivate func setCoverImage() {
        scrollView.addSubview(coverImage)
        coverImage.snp.makeConstraints {
            $0.leading.trailing.top.equalToSuperview()
            $0.height.equalTo(coverImageHeight)
            $0.width.equalTo(view)
        }
        
        coverImage.contentMode = .scaleAspectFill
        coverImage.clipsToBounds = true
    }
    
    fileprivate func setTrackInfoView() {
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
    }
    
    fileprivate func setPlayTrackView() {
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
        playImage.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        playImage.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(playButtonPressed))
        playImage.addGestureRecognizer(tapGesture)
        playImage.tintColor = .mainColor
        
        playTextLabel.text = .playTrack
        playTrackStackView.addArrangedSubview(playImage)
        playTrackStackView.addArrangedSubview(playTextLabel)
    }
}
