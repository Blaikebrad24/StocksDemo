//
//  PersistenceManager.swift
//  StocksApp
//
//  Created by Blaike Bradford on 1/21/22.
//

import Foundation

final class PersistenceManager {
    static let shared = PersistenceManager()
    private let userDefaults: UserDefaults = .standard
    
    private struct Constants {
        // storing symbols
        static let onboardedKey = "hasOnBoarded"
        static let watchlistKey = "watchlist"
    }
    
    private init(){}
    
    //functionality
    
    public var watchlist: [String]{
        if !hasOnboarded{
            userDefaults.set(true, forKey: Constants.onboardedKey)
        }
        return userDefaults.stringArray(forKey: Constants.watchlistKey) ?? []
    }
    
    public func addToWatchlist()
    {
        
    }
    
    public func removeFromWatchlist()
    {
        
    
    }
    
    private var hasOnboarded: Bool {
        return userDefaults.bool(forKey: Constants.onboardedKey)
    }
    
    private func setUpDefaults()
    {
        // so the user sees something when launch
        let map: [String: String] = [
            "AAPL": "Apple Inc",
            "MSFT": "Microsoft Corporation",
            "SNAP": "Snap Inc.",
            "GOOG": "Alphabet",
            "AMZN": "Amazon.com, Inc",
            "WORK": "Slack Technologies",
            "FB": "Facebook Inc.",
            "NVDA": "Nvidia Inc.",
            "NKE": "Nike",
            "PINS": "Pinterest Inc"
        ]
        let symbols = map.keys.map { $0 }
        userDefaults.set(symbols, forKey: Constants.watchlistKey)
        for(symbol, name) in map {
            userDefaults.set(name, forKey: symbol)
        }
    }
}
