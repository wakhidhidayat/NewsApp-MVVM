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
    
    init() {
        fetchNews()
    }
    
    private func fetchNews() {
        NetworkService.shared.getNews { [weak self] result in
            switch result {
            case .success(let newsResult):
                self?.news.value = newsResult.articles
                self?.isLoading.value = false
            case .failure(let error):
                self?.error.value = error
                self?.isLoading.value = false
                debugPrint(error)
            }
        }
    }
}
