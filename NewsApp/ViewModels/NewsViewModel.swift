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
    var searchText = ""
    
    init() {
        fetchNews(page: page)
    }
    
    func fetchNews(page: Int) {
        NetworkService.shared.getNews(page: page) { [weak self] result in
            switch result {
            case .success(let newsResult):
                self?.successHandler(for: newsResult)
            case .failure(let error):
                self?.errorHandler(for: error)
            }
        }
    }
    
    func searchNews(page: Int = 1, query: String) {
        NetworkService.shared.searchNews(page: page, query: query) { [weak self] result in
            switch result {
            case .success(let newsResult):
                self?.successHandler(for: newsResult)
            case .failure(let error):
                self?.errorHandler(for: error)
            }
        }
    }
    
    private func successHandler(for newsResult: NewsResult) {
        if page > 1 {
            news.value.append(contentsOf: newsResult.articles)
        } else {
            news.value = newsResult.articles
        }
        isLoading.value = false
        totalData = newsResult.totalResults
    }
    
    private func errorHandler(for error: Error) {
        self.error.value = error
        isLoading.value = false
        debugPrint(error.localizedDescription)
    }
}
