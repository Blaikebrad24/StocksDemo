//
//  NewsHeaderView.swift
//  StocksApp
//
//  Created by Blaike Bradford on 1/28/22.
//

import UIKit

class NewsHeaderView: UITableViewHeaderFooterView {

    static let indentifier = "NewHeaderView"
    static let preferredHeight: CGFloat = 70
    
    struct ViewModel {
        let title: String
        let shouldShowAddButton: Bool
    }

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
    }

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    public func configure(with viewModel: ViewModel)
    {
        
    }
    
}
