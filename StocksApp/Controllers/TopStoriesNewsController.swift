//
//  TopStoriesNewsController.swift
//  StocksApp
//
//  Created by Blaike Bradford on 1/21/22.
//

import UIKit

class TopStoriesNewsController : UIViewController {
    
    
    let tableView: UITableView = {
        let table = UITableView()
        table.backgroundColor = .clear
        table.register(NewStoryTableViewCell.self, forCellReuseIdentifier: NewStoryTableViewCell.identifier)
        table.register(NewsHeaderView.self, forHeaderFooterViewReuseIdentifier: NewsHeaderView.indentifier)
        return table
    }()
    
    private var stories: [NewStoriesModel] = [
    NewStoriesModel(category: "tech", datetime: 123, headline: "headline", image: "", related: "related", source: "ABC", summary: "", url: "")]
    
    private let type: Type
    
    /*
     *
     *
     *
     *
     */
    enum `Type` {
        case topStories
        case company(symbol: String)
        var title: String {
            switch self{
            case .topStories:
                return "Top Stories"
            case .company(let symbol):
                return symbol.uppercased()
            }
        }
    }
    
    /*
     *
     *
     *
     *
     */
    init(type: Type){
        self.type = type
        super.init(nibName: nil, bundle: nil)
    }
    /*
     *
     *
     *
     *
     */
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addViews()
        setUpTable()
        fetchNewNews()
        
    }
    
    /*
     *
     *
     *
     *
     */
    private func addViews()
    {
        
    }
    
    /*
     *
     *
     *
     *
     */
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    /*
     *
     *
     *
     *
     */
    private func setUpTable()
    {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    /*
     *
     *
     *
     *
     */
    private func fetchNewNews()
    {
        
    }
    
    
    
    
    private func open(url: URL)
    {
        
    }
}

extension TopStoriesNewsController: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NewStoryTableViewCell.identifier, for: indexPath) as? NewStoryTableViewCell else {
            fatalError()
        }
        cell.configure(with: .init(model: stories[indexPath.row]))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stories.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return NewStoryTableViewCell.preferredHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return NewsHeaderView.preferredHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: NewsHeaderView.indentifier) as? NewsHeaderView else {
            return nil
        }
        header.configure(with: .init(title: self.type.title, shouldShowAddButton: false))
        return header
    }
}
