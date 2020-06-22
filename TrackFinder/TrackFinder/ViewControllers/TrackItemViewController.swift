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
        
        trackInfoStackView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(24)
            $0.bottom.equalToSuperview().offset(-24)
        }
        
        trackTitle.font = UIFont.systemFont(ofSize: 20)
        trackTitle.textColor = .white
        
        trackArtistImageView.kf.setImage(with: <#T##Resource?#>)
        
        
    }
    
    func setData() {
        trackTitle.text = modelController.data.name
        
        guard let urlString = modelController.data.album.images.randomElement()?.url, let url = URL(string: urlString) else { return }
        
        let resource = ImageResource(downloadURL: url, cacheKey: modelController.data.id)
        coverImage.kf.setImage(with: resource)
    }
    
    @objc func handleRefresh() {
        modelController.refreshData()
    }
}
