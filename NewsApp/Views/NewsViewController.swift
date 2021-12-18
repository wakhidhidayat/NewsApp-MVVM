//
//  NewsViewController.swift
//  NewsApp
//
//  Created by Wahid Hidayat on 18/12/21.
//

import UIKit

class NewsViewController: UIViewController {

    @IBOutlet weak var newsTable: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var errorLabel: UILabel!
    
    private let viewModel = NewsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationItem.title = "News App"
        errorLabel.isHidden = true
        
        newsTable.register(ListTableViewCell.nib, forCellReuseIdentifier: ListTableViewCell.identifier)
        newsTable.dataSource = self
        newsTable.delegate = self
        
        activityIndicator.startAnimating()
        
        // binding view model with outlet
        viewModel.news.bind { [weak self] news in
            self?.newsTable.reloadData()
        }
        
        viewModel.isLoading.bind { [weak self] isLoading in
            if !isLoading {
                self?.activityIndicator.stopAnimating()
            }
        }
        
        viewModel.error.bind { [weak self] error in
            if let error = error {
                self?.errorLabel.isHidden = false
                self?.errorLabel.text = "Oops, Something Went Wrong\nError Code: \(error.asAFError?.responseCode ?? 500)"
            }
        }
    }
}

extension NewsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.news.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: ListTableViewCell.identifier,
            for: indexPath
        ) as? ListTableViewCell
        cell?.configure(with: viewModel.news.value[indexPath.row])
        return cell ?? UITableViewCell()
    }
}

extension NewsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
