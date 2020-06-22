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
        contentView.addSubview(contentStack)
        contentStack.axis = .horizontal
        contentStack.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.top.equalToSuperview().offset(8)
            $0.bottom.equalToSuperview().offset(-8)
        }
                
        contentStack.addArrangedSubview(albumImage)
        contentStack.distribution = .fill
        contentStack.spacing = 16
        albumImage.snp.makeConstraints {
            $0.width.height.equalTo(48)
        }
        albumImage.contentMode = .scaleAspectFill
        albumImage.clipsToBounds = true
        albumImage.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        
        contentStack.addArrangedSubview(titleStack)
        titleStack.axis = .vertical
        titleStack.distribution = .fillEqually
        titleStack.addArrangedSubview(trackNameLabel)
        titleStack.addArrangedSubview(artistNameLabel)
        trackNameLabel.font = UIFont.systemFont(ofSize: 16)
        artistNameLabel.font = UIFont.systemFont(ofSize: 12)
        artistNameLabel.textColor = .gray
        
        contentStack.addArrangedSubview(arrowRightImage)
        arrowRightImage.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        arrowRightImage.contentMode = .scaleAspectFit
        arrowRightImage.tintColor = .gray
        
        self.selectionStyle = .none
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()        
        trackNameLabel.text = .empty
        artistNameLabel.text = .empty
        albumImage.image = nil
    }
    
    func setText(trackItem: TrackItem) {
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
}
