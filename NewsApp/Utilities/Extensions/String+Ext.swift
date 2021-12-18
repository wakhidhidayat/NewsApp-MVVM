//
//  String+Ext.swift
//  NewsApp
//
//  Created by Wahid Hidayat on 18/12/21.
//

import Foundation

extension String {
    func toDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        return dateFormatter.date(from: self)
    }
}
