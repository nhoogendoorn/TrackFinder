//
//  Font+Extension.swift
//  TrackFinder
//
//  Created by Niels Hoogendoorn on 22/06/2020.
//  Copyright © 2020 Nihoo. All rights reserved.
//

import Foundation

enum FontSize {
    case extraLargeTitle
    case largeTitle
    case title
    case subTitle
    case body
    case buttonText
    case label
    
    var value: CGFloat {
        switch self {
        case .extraLargeTitle: return 40
        case .largeTitle: return 28
        case .body: return 14
        case .buttonText: return 14
        case .label: return 12
        case .subTitle: return 18
        case .title: return 24
        }
    }
}
