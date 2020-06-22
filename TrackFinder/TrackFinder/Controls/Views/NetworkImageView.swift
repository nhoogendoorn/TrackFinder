//
//  NetworkImageView.swift
//  TrackFinder
//
//  Created by Niels Hoogendoorn on 22/06/2020.
//  Copyright © 2020 Nihoo. All rights reserved.
//

import Foundation
import Kingfisher

class NetworkImageView: UIImageView {
    func loadImage(with urlString: String?, cacheKey: String?) {
        guard
            let urlString = urlString,
            let url = URL(string: urlString)
        else { return }
        
        let resource = ImageResource(downloadURL: url, cacheKey: cacheKey)
        self.kf.indicatorType = .activity
        self.kf.setImage(with: resource, placeholder: UIImage.placeholderImage) { _ in
            self.superview?.layoutIfNeeded()
        }
    }
    
}
