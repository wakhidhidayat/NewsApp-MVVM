//
//  ApiCall.swift
//  NewsApp
//
//  Created by Wahid Hidayat on 19/12/21.
//

import Foundation

struct ApiCall {
    fileprivate static let baseUrl = "https://newsapi.org/v2/"
    fileprivate static var apiKey: String {
        guard let filePath = Bundle.main.path(forResource: "Api-Info", ofType: "plist") else {
            fatalError("Couldn't find file 'Api-Info.plist'.")
        }
        let plist = NSDictionary(contentsOfFile: filePath)
        guard let value = plist?.object(forKey: "API_KEY") as? String else {
            fatalError("Couldn't find key 'API_KEY' in 'Api-Info.plist'.")
        }
        return value
    }
    
    static func newsParameters(page: Int) -> [String: Any] {
        return [
            "country": "id",
            "apiKey": ApiCall.apiKey,
            "page": page
        ]
    }
}

enum Endpoints {
    case getTrending
    
    var url: String {
        switch self {
        case .getTrending: return ApiCall.baseUrl + "top-headlines"
        }
    }
}
