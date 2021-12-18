//
//  News.swift
//  NewsApp
//
//  Created by Wahid Hidayat on 18/12/21.
//

import Foundation

struct News: Decodable {
    let title: String
    let url: String
    let description: String
    let imageUrl: String
    let publishedAt: String
    let source: Source
    
    enum CodingKeys: String, CodingKey {
        case title
        case url
        case description
        case imageUrl = "urlToImage"
        case publishedAt
        case source
    }
}

struct NewsResult: Decodable {
    let status: String
    let totalResults: Int
    let articles: [News]
}

struct Source: Decodable {
    let name: String
}
