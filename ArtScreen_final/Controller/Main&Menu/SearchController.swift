//
//  SearchController.swift
//  ArtScreen_final
//
//  Created by Heng on 2020/11/16.
//

import UIKit
enum SearchState {
    case searchUser
    case searchArtwork
    case searchExhibition
}

class SearchController: UITableViewController, UISearchDisplayDelegate {

    //MARK: - Properties
    var user: User?
    var users = [User]()
    var artworks = [ArtworkDetail]()
    var exhibitions = [ExhibitionDetail]()
    
    private var state: SearchState = .searchUser
    
    private let reuseIdentifier = "SearchCell"
    private let searchArtworkIdentifier = "SearchArtworkCell"
//    private let searchExhibitionIdentifier = "SearchArtworkCell"
    
    private let searchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.backgroundColor = .mainBackground
        sb.placeholder = "Search.."
        sb.barTintColor = .mainBackground
        sb.backgroundImage = UIImage()

        return sb
    }()
    private let filterView : FilterView = {
        let view = FilterView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), state: .inSearchView)
        return view
    }()
    
    private let searchView = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 112))
    
    //MARK: - Init
    init(user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()

//        fetchAllUser()
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

    func fetchAccountSearch(keywords: String) {
        UserService.shared.fetchAccountSearch(keyword: keywords) { (users) in
            self.users = users
            print("DEBUG: -Keywork count users = \(users.count)")
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    func fetchSearchArtwork(keywords: String) {
        ArtworkService.shared.fetchSearchArtwork(forKeywords: keywords) { (artworks) in
            self.artworks = artworks
            DispatchQueue.main.async {
//                self.configureTableView()
                self.tableView.reloadData()
            }
        }
    }
    func fetchSearchExhibition(keywords: String) {
        ExhibitionService.shared.fetchSearchExhibition(forKeywords: keywords) { (exhibitions) in
            self.exhibitions = exhibitions
            DispatchQueue.main.async {
                self.configureTableView()
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
        configureNavigationBar()
        configureSearchView()
        configureTableView()

        tableView.reloadData()
    }

    func configureNavigationBar() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(handleClosePage))
    }
    func configureSearchView() {
        searchView.addSubview(searchBar)
        searchBar.anchor(top: searchView.topAnchor, left: searchView.leftAnchor, right: searchView.rightAnchor, paddingLeft: 12, paddingRight: 12, height: 60)
        
        searchView.addSubview(filterView)
        filterView.searchDelegate = self
        filterView.anchor(top: searchBar.bottomAnchor, left: searchView.leftAnchor, right: searchView.rightAnchor, paddingTop: 5, paddingLeft: 12, paddingRight: 12, height: 40)
    }

    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        switch state {
        case .searchUser:
            tableView.register(NotificationCell.self, forCellReuseIdentifier: reuseIdentifier)
            tableView.rowHeight = 60
        case .searchArtwork:
            tableView.register(ArtworkSearchCell.self, forCellReuseIdentifier: searchArtworkIdentifier)
            tableView.rowHeight = 110
        case .searchExhibition:
            tableView.register(ArtworkSearchCell.self, forCellReuseIdentifier: searchArtworkIdentifier)
            tableView.rowHeight = UITableView.automaticDimension
            tableView.rowHeight = 110


        }

        tableView.separatorStyle = .none
        tableView.backgroundColor = .mainBackground
        tableView.tableHeaderView = searchView
        tableView.tableFooterView = UIView()

        searchBar.delegate = self
    }
    func moveToExhibitionDetail(exhibition: ExhibitionDetail) {
        guard let user = user else { return }
        let controller = ExhibitionDetailController(user: user)
        controller.exhibition = exhibition
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
    
    func moveToArtworkDetail(artwork: ArtworkDetail) {
        guard let user = user else { return }
        let controller = ArtworkDetailController(user: user, artwork: artwork)
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
}

//MARK: - UITableViewDataSource
extension SearchController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch state {
        case .searchUser:
            return users.count
        case .searchArtwork:
            return artworks.count
        case .searchExhibition:
            return exhibitions.count
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch state {
        case .searchUser:
            let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! NotificationCell
            cell.descriptionLabel.text = users[indexPath.row].username
            cell.profileImageView.sd_setImage(with: users[indexPath.row].ava)
            cell.timeLabel.text = ""
            return cell

        case .searchArtwork:
            let cell = tableView.dequeueReusableCell(withIdentifier: searchArtworkIdentifier, for: indexPath) as! ArtworkSearchCell
            cell.artworkImageView.sd_setImage(with:artworks[indexPath.row].path)
            cell.kindLabel.text = "@Artwork"
            cell.nameLabel.text = artworks[indexPath.row].artworkName
            return cell
        case .searchExhibition:
            let cell = tableView.dequeueReusableCell(withIdentifier: searchArtworkIdentifier, for: indexPath) as! ArtworkSearchCell
            cell.artworkImageView.sd_setImage(with:exhibitions[indexPath.row].path)
            cell.kindLabel.text = "@Exhibition"
            cell.nameLabel.text = exhibitions[indexPath.row].exhibitionName
            return cell
        }
    }
}

//MARK: - UITableViewDelegate
extension SearchController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch state {
        case .searchUser:
            let selectedUser = users[indexPath.row]
            let controller = UserProfileController(user: selectedUser)
            let nav = UINavigationController(rootViewController: controller)
            nav.modalPresentationStyle = .fullScreen
            present(nav, animated: true, completion: nil)
        case .searchArtwork:
            print("DEBUG: - Search Artwork")
            moveToArtworkDetail(artwork: artworks[indexPath.row])
            
//            let selectedExhibition =
        case .searchExhibition:
            print("DEBUG: - Search Exhibition")
            moveToExhibitionDetail(exhibition: exhibitions[indexPath.row])
        }

    }
}

//MARK: - SearchBarDelegate
extension SearchController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count == 0 {
            users.removeAll()
            tableView.reloadData()
        } else {
            switch state {
            case .searchUser:
                fetchAccountSearch(keywords: searchText)
            case .searchArtwork:
                fetchSearchArtwork(keywords: searchBar.text!)
                tableView.reloadData()
                print("DEBUG: - Search Text For Artwork")
            case .searchExhibition:
                fetchSearchExhibition(keywords: searchBar.text!)
                tableView.reloadData()
                print("DEBUG: - Search Text For Exhibition")
            }
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
extension SearchController : SearchViewDelegate {
    func changeStateSearch(state: SearchState) {
        print("DEBUG: - Change State \(state)")
        self.state = state
        configureTableView()
        switch self.state {
        case .searchUser:
            fetchAccountSearch(keywords: searchBar.text!)
        case .searchArtwork:
            fetchSearchArtwork(keywords: searchBar.text!)
        case .searchExhibition:
            fetchSearchExhibition(keywords: searchBar.text!)
        }
        tableView.reloadData()
    }
}
