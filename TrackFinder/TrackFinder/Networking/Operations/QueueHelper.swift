//
//  QueueHelper.swift
//  TrackFinder
//
//  Created by Niels Hoogendoorn on 23/06/2020.
//  Copyright © 2020 Nihoo. All rights reserved.
//

import Foundation

enum QueueHelper {
    static func shouldSuspendQueue(_ queue: ApiOperationQueue) -> Bool {
        !queue.hasInternetConnection || queue.currentTokenIsExpired
    }
}
