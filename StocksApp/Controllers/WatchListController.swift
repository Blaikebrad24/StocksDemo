//
//  ViewController.swift
//  StocksApp
//
//  Created by Blaike Bradford on 1/21/22.
//

import UIKit

class WatchListController: UIViewController {

    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        setUpSearchController()
        setupTitleView()
    }

    private func setUpSearchController()
    {
        let resultVC = SearchResultController()
        let searchVC = UISearchController(searchResultsController: resultVC)
        searchVC.searchResultsUpdater = self
        navigationItem.searchController = searchVC
    }
    
    private func setupTitleView()
    {
        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: view.width, height: navigationController?.navigationBar.height ?? 100)) // height defaults to 100
        let label = UILabel(frame: CGRect(x: 10, y: 0, width: titleView.width-20, height: titleView.height))
        label.text = "Stocks"
        label.font = .systemFont(ofSize: 40, weight: .medium)
        titleView.addSubview(label)
        navigationItem.titleView = titleView
    }

}

// captures the searchController text by every keystroke 
extension WatchListController: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        guard let query = searchController.searchBar.text,
              let resultsVC = searchController.searchResultsController as? SearchResultController,
              !query.trimmingCharacters(in: .whitespaces).isEmpty else {
                  return
              }
        
        // call api here to search
         
        
        // reduce api calls we make
        
        // update result controller
        
        
    } // gets called per keystroke
}
