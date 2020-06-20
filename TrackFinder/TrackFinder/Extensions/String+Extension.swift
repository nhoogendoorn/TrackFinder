//
//  String+Extension.swift
//  TrackFinder
//
//  Created by Niels Hoogendoorn on 18/06/2020.
//  Copyright © 2020 Nihoo. All rights reserved.
//

import Foundation

extension String {
    static let empty: String = ""
    
    func encodeToURLQuery() -> String? {
        self.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
    }
}
