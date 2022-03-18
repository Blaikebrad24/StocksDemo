//
//  WatchListTableViewCell.swift
//  StocksApp
//
//  Created by Blaike Bradford on 3/8/22.
//

import UIKit

class WatchListTableViewCell: UITableViewCell{
    static let identifier = "WatchListIdentifier"
    static let preferredHeight : CGFloat = 60
    
    struct ViewModel{
        let symbol: String
        let companyName: String
        let price: String // formatted
        let changeColor: UIColor // red or green
        let changePercentage: String // formatted
//        let chartViewModel: StockChartView.ViewModel
    }
    
    //symbol label
    private let symbolLabel: UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .medium)
        return label
    }()
    //company label
    private let companyLabel: UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .regular)
        return label
    }()
    //mini chart view
    private let miniChartView = StockChartView()
    //price label
    private let priceLabel: UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .regular)
        return label
    }()
    //change in price label
    private let changePriceLabel: UILabel = {
       let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 15, weight: .regular)
        return label
    }()
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubviews(symbolLabel, companyLabel, miniChartView, priceLabel, changePriceLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        symbolLabel.text = nil
        companyLabel.text = nil
        changePriceLabel.text = nil
        priceLabel.text = nil
        miniChartView.reset()
    }
    
    public func configure(with viewModel: ViewModel)
    {
        symbolLabel.text = viewModel.symbol
        companyLabel.text = viewModel.companyName
        priceLabel.text = viewModel.price
        changePriceLabel.text = viewModel.changePercentage
        changePriceLabel.backgroundColor = viewModel.changeColor
        
    }
}
