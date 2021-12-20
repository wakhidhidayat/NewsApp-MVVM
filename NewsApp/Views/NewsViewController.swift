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
    
    private let viewModel: NewsViewModel
    private let sections = [CellType.header, CellType.list]
    private let searchController = UISearchController(searchResultsController: nil)
    private var isSearching = false
    
    // Mark: Initialization
    init(viewModel: NewsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "NewsViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationItem.title = "News App"
        errorLabel.isHidden = true
        
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Topic"
        navigationItem.searchController = searchController
        
        newsTable.register(ListTableViewCell.nib, forCellReuseIdentifier: ListTableViewCell.identifier)
        newsTable.register(HeaderTableViewCell.nib, forCellReuseIdentifier: HeaderTableViewCell.identifier)
        newsTable.dataSource = self
        newsTable.delegate = self
        
        activityIndicator.startAnimating()
        
        // Mark: Data Binding
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
            return "Trending"
        case .list:
            return "Top Headlines"
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
            myLabel.text = "Trending"
            return headerView
        case .list:
            myLabel.text = "Top Headlines"
            return headerView
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        switch sections[indexPath.section] {
        case .header: return
        case .list:
            if indexPath.row == viewModel.news.value.count - 2 && viewModel.news.value.count < viewModel.totalData {
                viewModel.page += 1
                if isSearching {
                    viewModel.searchNews(page: viewModel.page, query: viewModel.searchText)
                } else {
                    viewModel.fetchNews(page: viewModel.page)
                }
                print("showing \(viewModel.news.value.count) of \(viewModel.totalData)")
                print("page: \(viewModel.page)")
            }
        }
    }
}

extension NewsViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        activityIndicator.startAnimating()
        viewModel.searchText = searchText
        viewModel.page = 1
        
        if searchText == "" {
            isSearching = false
            viewModel.fetchNews(page: viewModel.page)
        } else {
            isSearching = true
            viewModel.searchNews(query: searchText)
        }
    }
}
