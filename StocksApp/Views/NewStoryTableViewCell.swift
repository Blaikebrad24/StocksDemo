//
//  NewStoryTableViewCell.swift
//  StocksApp
//
//  Created by Blaike Bradford on 2/10/22.
//

import UIKit
import SDWebImage

class NewStoryTableViewCell: UITableViewCell {

    static let identifier = "NewStoryTableViewCell"
    static let preferredHeight: CGFloat = 140
    
    struct ViewModel {
        let source : String
        let headline: String
        let date: String
        let imageURL: URL?
        
        init(model: NewStoriesModel){
            // what we get back from API Call
            self.source = model.source
            self.headline = model.headline
            self.date = .string(from: model.datetime)
            self.imageURL = URL(string: model.image)
        }
    }
    
    //source
    private let sourceLabel : UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .heavy)
        return label
    }()
    //headline
    private let headlineLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .medium)
        label.numberOfLines = 0
        return label
    }()
    
    //Date
    private let dateLabel: UILabel = {
       let label = UILabel()
    label.font = .systemFont(ofSize: 14, weight: .medium)
        label.font = .systemFont(ofSize: 24, weight: .regular)
        return label
    }()
    //Image
    private let storyImageView: UIImageView = {
       let image = UIImageView()
        image.clipsToBounds = true
        image.backgroundColor = .systemBackground
        image.contentMode = .scaleAspectFit
        image.layer.cornerRadius = 6
        image.layer.masksToBounds = true
        return image
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = .secondarySystemBackground
        backgroundColor = .secondarySystemBackground
        addSubviews(sourceLabel,headlineLabel,dateLabel,storyImageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let imagesize: CGFloat = contentView.height-6
        storyImageView.frame = CGRect(x: contentView.width-imagesize-10, y: 3, width: imagesize, height: imagesize)
        //adding frames
        let availableWidth: CGFloat = contentView.width - separatorInset.left - imagesize - 10 - 15
        dateLabel.frame = CGRect(x: separatorInset.left, y: contentView.height - 40, width: availableWidth, height: 40)
        
        sourceLabel.sizeToFit()
        sourceLabel.frame = CGRect(x: separatorInset.left, y: 4, width: availableWidth, height: sourceLabel.height)
        
        headlineLabel.frame = CGRect(x: separatorInset.left, y: sourceLabel.bottom + 5, width: availableWidth, height: contentView.height - sourceLabel.bottom - dateLabel.height - 10)
        
        storyImageView.frame = CGRect(x: contentView.width-imagesize-10, y: 3, width: imagesize, height: imagesize)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        sourceLabel.text = nil
        headlineLabel.text = nil
        dateLabel.text = nil
        storyImageView.image = nil
    }
    
    public func configure(with viewModel: ViewModel)
    {
        headlineLabel.text = viewModel.headline
        sourceLabel.text = viewModel.source
        dateLabel.text = viewModel.date
        storyImageView.sd_setImage(with: viewModel.imageURL, completed: nil)
        //manually set image
        //storyImageView.setImage(with: viewModel.imageURL)
    }

}
