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
    
    func getNews(page: Int, completion: @escaping (Result<NewsResult, Error>) -> Void) {
        AF.request(Endpoints.getTrending.url, parameters: ApiCall.newsParameters(page: page))
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
