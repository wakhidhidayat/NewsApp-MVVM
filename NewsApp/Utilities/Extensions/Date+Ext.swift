//
//  Date+Ext.swift
//  NewsApp
//
//  Created by Wahid Hidayat on 18/12/21.
//

import Foundation

extension Date {
    func timeAgoDisplay() -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter.localizedString(for: self, relativeTo: Date())
    }
}
