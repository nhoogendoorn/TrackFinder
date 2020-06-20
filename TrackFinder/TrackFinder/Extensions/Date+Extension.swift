//
//  Date+Extension.swift
//  TrackFinder
//
//  Created by Niels Hoogendoorn on 20/06/2020.
//  Copyright © 2020 Nihoo. All rights reserved.
//

import Foundation

extension Date {
    static func now(_ component: Calendar.Component, offset: Int = 0) -> Date {
        Calendar.current.date(byAdding: component, value: offset, to: Date()) ?? Date()
    }
    
    func toString() -> String {
        let dateFormatter = StandardDateFormatter()        
        return dateFormatter.string(from: self)
    }
    
    static func fromString(_ dateAsString: String) -> Date? {
        let dateFormatter = StandardDateFormatter()
        return dateFormatter.date(from: dateAsString)
    }
}
