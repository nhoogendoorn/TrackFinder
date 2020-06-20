//
//  SearchModelController.swift
//  TrackFinder
//
//  Created by Niels Hoogendoorn on 20/06/2020.
//  Copyright © 2020 Nihoo. All rights reserved.
//

import SwiftUI

class SearchModelController: ObservableObject, DependencyResolver {
    
    var data: [String] = []
    @Published var filteredResults: [String] = []
    
    private let apiManager: ApiProtocol = ApiManager()
    
    func loadData() {
        DispatchQueue.main.async {
            var newData: [String] {
                Range(0...50).compactMap { _ in
                    return UUID().uuidString
                }
            }
            self.data = newData
            self.filteredResults = newData
        }
        self.filterData(searchText: .empty)
    }
    
    func filterData(searchText: String) {
        DispatchQueue.main.async {
            if searchText.isEmpty {
                self.filteredResults = self.data
            } else {
                self.filteredResults = self.data.filter({ $0.lowercased().contains(searchText.lowercased()) })
            }
        }
    }
}
