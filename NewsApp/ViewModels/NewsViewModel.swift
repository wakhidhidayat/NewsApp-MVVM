//
//  NewsViewModel.swift
//  NewsApp
//
//  Created by Wahid Hidayat on 18/12/21.
//

import Foundation

class NewsViewModel {
    var news = Box([News]())
    var error: Box<Error?> = Box(nil)
    var isLoading = Box(true)
    var page = 1
    var totalData = 0
    
    init() {
        fetchNews(page: page)
    }
    
    func fetchNews(page: Int) {
        NetworkService.shared.getNews(page: page) { [weak self] result in
            switch result {
            case .success(let newsResult):
                if page > 1 {
                    self?.news.value.append(contentsOf: newsResult.articles)
                } else {
                    self?.news.value = newsResult.articles
                }
                self?.isLoading.value = false
                self?.totalData = newsResult.totalResults
            case .failure(let error):
                self?.error.value = error
                self?.isLoading.value = false
                debugPrint(error)
            }
        }
    }
}
