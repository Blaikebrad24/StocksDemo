//
//  SearchResultsController.swift
//  StocksApp
//
//  Created by Blaike Bradford on 1/21/22.
//

import Foundation
import UIKit

// delegate to proxy back TableCell data to WatchListController
// to present specified data
protocol SearchResultsControllerDelegate: AnyObject
{
    func searchResultsViewControllerDidSelect(searchResult: SearchResult)
}

class SearchResultController: UIViewController {
    
    weak var delegate: SearchResultsControllerDelegate?
    
    private var results: [SearchResult] = []
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(SearchResultTableViewCell.self, forCellReuseIdentifier: SearchResultTableViewCell.identifier)
        
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupTable()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    private func setupTable()
    {
        view.addSubview(tableView)
        // data and interactions will be controlled in this class
        tableView.delegate = self
        tableView.dataSource = self
    }
    public func update(with results: [SearchResult])
    {
        // tell the table to reload
        //
        self.results = results
        tableView.reloadData()
    }
}

extension SearchResultController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: SearchResultTableViewCell.identifier, for: indexPath)
        let model = results[indexPath.row]
        cell.textLabel?.text = model.displaySymbol
        cell.detailTextLabel?.text = model.description
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // using the protocol instance of SearchResultsControllerDelegate
        let model = results[indexPath.row]
        delegate?.searchResultsViewControllerDidSelect(searchResult: model)
    }
    
}
