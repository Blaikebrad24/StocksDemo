//
//  NewsHeaderView.swift
//  StocksApp
//
//  Created by Blaike Bradford on 1/28/22.
//

import UIKit

protocol NewsHeaderViewDelegate: AnyObject {
    func newsHeaderViewDidTapAddButton(_ headerView: NewsHeaderView)
}

class NewsHeaderView: UITableViewHeaderFooterView {

    static let indentifier = "NewHeaderView"
    static let preferredHeight: CGFloat = 70
    weak var delegate: NewsHeaderViewDelegate?
    
    struct ViewModel {
        let title: String
        let shouldShowAddButton: Bool
    }
    
    private let label: UILabel = {
       let label = UILabel()
        label.font = .boldSystemFont(ofSize: 32)
        return label
    }()
    
    private let button: UIButton = {
       let btn = UIButton()
        btn.setTitle("+ Watchlist", for: .normal)
        btn.backgroundColor = .systemBlue
        btn.setTitleColor(.white, for: .normal)
        btn.layer.cornerRadius = 6
        btn.layer.masksToBounds = true
        
        return btn
    }()

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.addSubviews(label,button)
        contentView.backgroundColor = .secondarySystemBackground
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
    }

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        label.frame = CGRect(x: 14, y: 0, width: contentView.width-28, height: contentView.height)
        
        button.sizeToFit()
        button.frame = CGRect(x: contentView.width - button.width - 25, y: (contentView.height - button.height)/2, width: button.width + 8, height: button.height)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    public func configure(with viewModel: ViewModel)
    {
        label.text = viewModel.title
        button.isHidden = viewModel.shouldShowAddButton
        
    }
    
    @objc private func didTapButton()
    {
        delegate?.newsHeaderViewDidTapAddButton(self)
    }
    
}
