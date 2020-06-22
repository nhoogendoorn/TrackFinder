//
//  StandardDateFormatter.swift
//  TrackFinder
//
//  Created by Niels Hoogendoorn on 20/06/2020.
//  Copyright © 2020 Nihoo. All rights reserved.
//

import Foundation

class StandardDateFormatter: DateFormatter {
    
    override init() {
        super.init()
        let dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        self.dateFormat = dateFormat
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
