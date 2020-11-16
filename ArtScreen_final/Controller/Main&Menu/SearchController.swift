//
//  SearchController.swift
//  ArtScreen_final
//
//  Created by Heng on 2020/11/16.
//

import UIKit

private let reuseIdentifier = "SearchCell"

class SearchController: UITableViewController {
    
    //MARK: - Properties
    private let searchBar: UISearchBar = {
        let sb = UISearchBar(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 60))
        sb.backgroundColor = .mainBackground
        sb.placeholder = "Search.."
        sb.barTintColor = .mainBackground
        
        return sb
    }()
    
    //MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    //MARK: - Selectors
    @objc func handleClosePage() {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Helpers
    func configureUI() {
        view.backgroundColor = .mainBackground
        
        configureTableView()
        configureNavigationBar()
    }
    
    func configureNavigationBar() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(handleClosePage))
    }
    
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.rowHeight = 60
        tableView.separatorStyle = .none
        tableView.backgroundColor = .mainBackground
        tableView.tableHeaderView = searchBar
        tableView.tableFooterView = UIView()
        
        searchBar.delegate = self
    }
}

//MARK: - UITableViewDataSource
extension SearchController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        cell.backgroundColor = .mainBackground
        cell.textLabel?.text = "Search Results.."
        cell.selectionStyle = .none
        
        return cell
    }
}

//MARK: - SearchBarDelegate
extension SearchController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
//            searchResults = searchAllResults
        } else {
//            var temp = [MKMapItem]()
//            for result in searchResults {
//                if (result.name?.lowercased().hasPrefix(searchText.lowercased()))! {
//                    temp.append(result)
//                }
//            }
//
//            self.searchResults = []
//            self.searchResults = temp
        }
        
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
//        searchResults = searchAllResults
        tableView.reloadData()
    }
}
