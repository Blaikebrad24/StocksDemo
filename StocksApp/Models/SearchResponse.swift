//
//  SearchResponse.swift
//  StocksApp
//
//  Created by Blaike Bradford on 1/27/22.
//

import Foundation

// JSON maps back to this object

struct SearchResponse: Codable {

    let count: Int
    let result: [SearchResult]

}

struct SearchResult: Codable {
    let description: String
    let displaySymbol: String
    let symbol: String
    let type: String
}
