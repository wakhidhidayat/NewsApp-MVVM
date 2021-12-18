//
//  NetworkService.swift
//  NewsApp
//
//  Created by Wahid Hidayat on 18/12/21.
//

import Foundation
import Alamofire

class NetworkService {
    static let shared = NetworkService()
    
    private init() { }
    
    func getNews(completion: @escaping (Result<NewsResult, Error>) -> Void) {
        AF.request("https://newsapi.org/v2/top-headlines?country=id&apiKey=2169e45c9cec490b9aaed732d6090a7b")
            .validate()
            .responseDecodable(of: NewsResult.self) { response in
                switch response.result {
                case .success(let newsResult):
                    completion(.success(newsResult))
                case .failure(let error):
                    completion(.failure(error.asAFError!))
                }
            }
    }
}
