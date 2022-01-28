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
    
    /*
     Function - Private setUpSearchController
     Purpose - adds search bar to hierarchy view
     Parameters - none
     */
    private func setUpSearchController()
    {
        let resultVC = SearchResultController()
        resultVC.delegate = self
        let searchVC = UISearchController(searchResultsController: resultVC)
        searchVC.searchResultsUpdater = self
        navigationItem.searchController = searchVC
    }
    
    /*
     Function - Private setupTitleView()
     Purpose - gets called in viewDidLoad for titleview frame
     Parameters - none
     */
    
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

extension WatchListController: SearchResultsControllerDelegate {
    func searchResultsViewControllerDidSelect(searchResult: SearchResult) {
        print("Did select: \(searchResult.displaySymbol)")
    }

}

// captures the searchController text by every keystroke

/*
 Extension WatchListController -> inherits from UISrchRsltUpdating
 Func updateSearchResults - gets called with every user keystroke in searchbar
 Purpose - to display relative dynamic list of stocks based on user input
 Function Parameters - searchController of type UISearchController
 
 */
extension WatchListController: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        guard let query = searchController.searchBar.text,
              let resultsVC = searchController.searchResultsController as? SearchResultController,
              !query.trimmingCharacters(in: .whitespaces).isEmpty else {
                  return
              }
        print(query)
        // call api here to search
        APIManager.shared.search(query: query) { result in
            switch result {
            case .success(let response):
                // update resultController with results
                // want to update on main thread
                DispatchQueue.main.async {
                    
                    resultsVC.update(with: response.result)
                }
            case .failure(let error):
                print(error)
            }
        }
        
        // reduce api calls we make
        // update SearchResultController
      
        
    } // gets called per keystroke
}
