//
//  SearchResultTableView.swift
//  TrackFinder
//
//  Created by Niels Hoogendoorn on 23/06/2020.
//  Copyright © 2020 Nihoo. All rights reserved.
//

import Foundation

class SearchResultTableView: UITableView {
    
    let cellId: String = "SearchItemCell"
    let customBackgroundView = TableViewBackgroundView()
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        register(SearchItemCell.self, forCellReuseIdentifier: cellId)
        backgroundView = TableViewBackgroundView()
        showsVerticalScrollIndicator = false
        separatorStyle = .none
        keyboardDismissMode = .onDrag
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func showBackground(_ show: Bool) {
        backgroundView = show ? customBackgroundView : nil
    }
    
    class TableViewBackgroundView: UIView {
        let searchTextLabel = UILabel()
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            addSubview(searchTextLabel)
            searchTextLabel.snp.makeConstraints {
                $0.center.equalToSuperview()
            }
            searchTextLabel.text = .startSearching
            searchTextLabel.textColor = .gray
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
}
