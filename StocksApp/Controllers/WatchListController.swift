//
//  ViewController.swift
//  StocksApp
//
//  Created by Blaike Bradford on 1/21/22.
//

import UIKit
import FloatingPanel

class WatchListController: UIViewController {
    
    private var searchTime: Timer?
    private var panel: FloatingPanelController?
    
    //symbol : array of data
    private var watchlistMap: [String:[CandleStick]] = [:]
    
    //ViewModels
    private var viewModels: [WatchListTableViewCell.ViewModel] = []
    
    private let tableView: UITableView = {
        let table = UITableView()
        
        return table
    }()
    
    
    /*
     *
     *
     *
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        setUpSearchController()
        setupTableView()
        fetchWatchListData()
        createViewModels()
        setupFloatingPanel()
        setupTitleView()
    }
    /*
     *
     *
     *
     */
    private func setupFloatingPanel()
    {
        let controller = TopStoriesNewsController(type: .topStories)
        let panel = FloatingPanelController(delegate: self)
        
        panel.set(contentViewController: controller)
        panel.surfaceView.backgroundColor = .secondarySystemBackground
        panel.addPanel(toParent: self)
        panel.track(scrollView: controller.tableView)
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
    
    /*
     *
     *
     *
     */
    private func setupTableView()
    {
        view.addSubviews(tableView)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    /*
     *
     *
     *
     */
private func fetchWatchListData()
    {
        
        let symbols = PersistenceManager.shared.watchlist
        let group = DispatchGroup()
//        print(symbols)
        for symbol in symbols{
            //get market data per symbol
            group.enter()
            APIManager.shared.marketData(for: symbol) { [weak self] result in
                defer {
                    group.leave()
                }
                switch result {
                case .success(let data):
                    let candleSticks = data.candleSticks
                    self?.watchlistMap[symbol] = candleSticks
                case .failure(let error):
                    print(error)
                }
            }
        }
        group.notify(queue: .main){
            [weak self] in
            self?.createViewModels()
            self?.tableView.reloadData()
        }
    }
    /*
     *
     *
     *
     */
    private func createViewModels()
    {
        var viewModels = [WatchListTableViewCell.ViewModel]()

        for(symbol, candleSticks) in watchlistMap {
            let changePercentage = getChangePercentage(for: candleSticks)
            viewModels.append(.init(
                symbol: symbol,
                companyName: UserDefaults.standard.string(forKey: symbol) ?? "Company",
                price: getLatestClosingPrice(from: candleSticks),
                changeColor: changePercentage < 0 ? .systemRed : .systemGreen,
                changePercentage: "\(changePercentage)"))
        }
    }
    

    /*
     *
     *
     *
     */
    private func getChangePercentage(for data: [CandleStick]) -> Double{
        let priorDate = Date().addingTimeInterval(-((3600 * 24) * 2))
      guard let latestClose = data.first?.close,
            let priorClose = data.first(where: {
                Calendar.current.isDate($0.date, inSameDayAs: priorDate)
            })?.close else {return 0}
        print("Current: \(latestClose) | Prior: \(priorClose)")
        return 0.0
    }
    /*
     *
     *
     *
     */
    private func getLatestClosingPrice(from data: [CandleStick]) -> String{
        guard let closingPrice = data.first?.close else {
            return ""
        }
        return "\(closingPrice)"
    }

}

extension WatchListController: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return watchlistMap.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        //open details
    }
}


/*
 *
 *
 *
 *
 */
extension WatchListController: FloatingPanelControllerDelegate {
    
    
    func floatingPanelDidChangeState(_ fpc: FloatingPanelController) {
        navigationItem.titleView?.isHidden = fpc.state == .full
    }
    
}

/*
 *
 *
 *
 *
 */

extension WatchListController: SearchResultsControllerDelegate {
    func searchResultsViewControllerDidSelect(searchResult: SearchResult) {
        print("Did select: \(searchResult.displaySymbol)") // passed back from SearchResultsController
        navigationItem.searchController?.searchBar.resignFirstResponder()
        // create another controller to present
        let stockController = StockDetailsController()
        let navController = UINavigationController(rootViewController: stockController)
        stockController.title = searchResult.description
        present(navController,animated: true)
        
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
        searchTime?.invalidate()// stops and resets times
        searchTime = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false, block: { _ in
            APIManager.shared.search(query: query) { result in
                switch result {
                case .success(let response):
                    // update resultController with results
                    // want to update on main thread
                    DispatchQueue.main.async {
                        
                        resultsVC.update(with: response.result)
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        resultsVC.update(with: [])
                    }
                    print(error)
                }
            }
        })
        
        // reduce api calls we make
        
        // update SearchResultController
      
        
    } // gets called per keystroke ->API CALL OVERLOAD
}
