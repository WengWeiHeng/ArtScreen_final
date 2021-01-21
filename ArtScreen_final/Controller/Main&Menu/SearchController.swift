//
//  SearchController.swift
//  ArtScreen_final
//
//  Created by Heng on 2020/11/16.
//

import UIKit

private let reuseIdentifier = "SearchCell"

class SearchController: UITableViewController, UISearchDisplayDelegate {

    //MARK: - Properties
    var users = [User]()
    
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
        
        fetchAllUser()
        configureUI()
    }
    
    //MARK: - API
    func fetchAllUser() {
        UserService.shared.fetchAllUser(completion: { (users) in
            self.users = users
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
    }
    
    func fetchSearch(keywords: String) {
        UserService.shared.fetchSearch(keyword: keywords) { (users) in
            self.users = users
            print("DEBUG: -Keywork count users = \(users.count)")
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
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
        tableView.reloadData()
    }
    
    func configureNavigationBar() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(handleClosePage))
//        navigationItem.searchController?.searchBar = searchBar
    }
    
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(NotificationCell.self, forCellReuseIdentifier: reuseIdentifier)
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
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! NotificationCell

        cell.descriptionLabel.text = users[indexPath.row].username
        cell.profileImageView.sd_setImage(with: users[indexPath.row].ava)
        cell.timeLabel.text = ""

        return cell
    }
}

//MARK: - UITableViewDelegate
extension SearchController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedUser = users[indexPath.row]
        let controller = UserProfileController(user: selectedUser)
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
}

//MARK: - SearchBarDelegate
extension SearchController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count == 0 {
            fetchAllUser()
        } else {
            fetchSearch(keywords: searchText)
        }
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
