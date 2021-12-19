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
    private let sections = [CellType.header, CellType.list]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationItem.title = "News App"
        errorLabel.isHidden = true
        
        newsTable.register(ListTableViewCell.nib, forCellReuseIdentifier: ListTableViewCell.identifier)
        newsTable.register(HeaderTableViewCell.nib, forCellReuseIdentifier: HeaderTableViewCell.identifier)
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

enum CellType {
    case header
    case list
}

extension NewsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch sections[section] {
        case .header: return 1
        case .list: return viewModel.news.value.count - 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch sections[indexPath.section] {
        case .header:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: HeaderTableViewCell.identifier,
                for: indexPath
            ) as? HeaderTableViewCell
            if let firstNews = viewModel.news.value.first {
                cell?.configure(with: firstNews)
            }
            return cell ?? UITableViewCell()
        case .list:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: ListTableViewCell.identifier,
                for: indexPath
            ) as? ListTableViewCell
            cell?.configure(with: viewModel.news.value[indexPath.row + 1])
            return cell ?? UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch sections[section] {
        case .header:
            return "Breaking News"
        case .list:
            return "Trending"
        }
    }
}

extension NewsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let section = sections[section]
        let myLabel = UILabel()
        myLabel.frame = CGRect(x: 16, y: 5, width: 320, height: 30)
        myLabel.font = UIFont.boldSystemFont(ofSize: 28)
        
        let headerView = UIView()
        headerView.addSubview(myLabel)
        
        switch section {
        case .header:
            myLabel.text = "Breaking News"
            return headerView
        case .list:
            myLabel.text = "Trending"
            return headerView
        }
    }
}
