//
//  SearchItemCell.swift
//  TrackFinder
//
//  Created by Niels Hoogendoorn on 20/06/2020.
//  Copyright © 2020 Nihoo. All rights reserved.
//

import UIKit
import Kingfisher

class SearchItemCell: UITableViewCell {
    let contentStack = UIStackView()
    let titleStack = UIStackView()
    let trackNameLabel = UILabel()
    let artistNameLabel = UILabel()
    let albumImage = NetworkImageView()
    let arrowRightImage = UIImageView(image: UIImage(systemName: "chevron.right"))

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        setContentStackView()
        setAlbumImage()
        setTrackTitle()
        setArrowImage()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()        
        trackNameLabel.text = .empty
        artistNameLabel.text = .empty
        albumImage.image = nil
    }
    
    func setItem(trackItem: TrackItem) {
        trackNameLabel.text = trackItem.name
        artistNameLabel.text = trackItem.artists.first?.name
        albumImage.loadImage(with: trackItem.album.images.first?.url,
                             cacheKey: trackItem.album.id)        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        albumImage.layer.cornerRadius = 4
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setContentStackView() {
        contentView.addSubview(contentStack)
        contentStack.axis = .horizontal
        contentStack.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(Spacing.medium.rawValue)
            $0.trailing.equalToSuperview().offset(-Spacing.medium.rawValue)
            $0.top.equalToSuperview().offset(Spacing.small.rawValue)
            $0.bottom.equalToSuperview().offset(-Spacing.small.rawValue)
        }
        
        contentStack.addArrangedSubview(albumImage)
        contentStack.distribution = .fill
        contentStack.spacing = Spacing.medium.rawValue
    }
    
    fileprivate func setAlbumImage() {
        let albumSize: CGFloat = 48
        albumImage.snp.makeConstraints {
            $0.width.height.equalTo(albumSize)
        }
        albumImage.contentMode = .scaleAspectFill
        albumImage.clipsToBounds = true
        albumImage.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
    }
    
    fileprivate func setTrackTitle() {
        contentStack.addArrangedSubview(titleStack)
        titleStack.axis = .vertical
        titleStack.distribution = .fillEqually
        titleStack.addArrangedSubview(trackNameLabel)
        titleStack.addArrangedSubview(artistNameLabel)
        trackNameLabel.font = UIFont.systemFont(ofSize: FontSize.body.value)
        artistNameLabel.font = UIFont.systemFont(ofSize: FontSize.label.value)
        artistNameLabel.textColor = .gray
    }
    
    fileprivate func setArrowImage() {
        contentStack.addArrangedSubview(arrowRightImage)
        arrowRightImage.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        arrowRightImage.contentMode = .scaleAspectFit
        arrowRightImage.tintColor = .gray
    }
}
