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
        
        // This has to be on the main thread because otherwise we will get a
        // threading issue when setting the activitiy indicator.
        DispatchQueue.main.async {
            let resource = ImageResource(downloadURL: url, cacheKey: cacheKey)
            self.kf.indicatorType = .activity
            self.kf.setImage(with: resource, placeholder: UIImage.placeholderImage)
        }
    }
    
}
