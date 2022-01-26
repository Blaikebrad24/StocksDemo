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
        
    }
    
    private init(){}
    
    //functionality
    
    public var watchlist: [String]{
        return []
    }
    
    public func addToWatchlist()
    {
        
    }
    
    public func removeFromWatchlist()
    {
        
    
    }
    
    private var hasOnboarded: Bool {
        return false
    }
}
