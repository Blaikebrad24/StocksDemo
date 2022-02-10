//
//  Extensions.swift
//  StocksApp
//
//  Created by Blaike Bradford on 1/26/22.
//

import UIKit

extension UIView {
    var width: CGFloat{frame.size.width}
    
    var height: CGFloat{frame.size.height}
    
    var left: CGFloat{frame.origin.x}
    var right: CGFloat{left + width}
    var top: CGFloat{frame.origin.y}
    var bottom: CGFloat{top + height}
}

extension UIView {
    func addSubviews(_ views: UIView...)
    {
        views.forEach {
            addSubview($0)
        }
    }
}

extension DateFormatter {
    static let newsFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd"
        return formatter
    }()
}
