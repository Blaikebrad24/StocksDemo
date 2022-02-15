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
    
    static let tidyDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        
        return formatter
    }()
}

extension String {
    static func string(from timeInterval: TimeInterval) -> String {
        let date = Date(timeIntervalSince1970: timeInterval)
        return DateFormatter.tidyDateFormatter.string(from: date)
        
    }
}

extension UIImageView {
    func setImage(with url: URL?)
    {
        guard let url = url else {
            return
        }
        
        DispatchQueue.global(qos: .userInteractive).async {
            let task = URLSession.shared.dataTask(with: url){
                [weak self] data, _, error in
                guard let data = data, error == nil else {
                    return
                }
                DispatchQueue.main.async {
                    self?.image = UIImage(data: data)
                }
            }
            task.resume()
        }
    }
}
