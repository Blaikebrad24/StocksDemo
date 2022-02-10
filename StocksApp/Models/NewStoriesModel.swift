//
//  NewStoriesModel.swift
//  StocksApp
//
//  Created by Blaike Bradford on 2/3/22.
//

import Foundation


struct NewStoriesModel : Codable
{
    
        
    let category: String
    let datetime: TimeInterval
    let headline: String
    let image: String
    let related: String
    let source: String
    let summary: String
    let url: String
      
}
