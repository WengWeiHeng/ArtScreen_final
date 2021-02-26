//
//  MainControllerRenew.swift
//  ArtScreen_final
//
//  Created by Heng on 2021/2/24.
//

import UIKit

private let reuseIdentifier = "MainCellRenew"

protocol MainControllerRenewDelegate: class {
    func handleMenuToggle()
}

class MainControllerRenew: UIViewController {
    
    //MARK: - Properties
    var user: User?
    var costUser: User?
    
    var exhibitions = [ExhibitionDetail]()
    
    weak var delegate: MainControllerRenewDelegate?
    private var buttonIsActive: Bool = false
    
    private var tableView = UITableView()
    
    private let menuButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "menu").withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .mainPurple
        button.setDimensions(width: 32, height: 20)
        button.addTarget(self, action: #selector(handleMenuAction), for: .touchUpInside)
    
        return button
    }()
    
    private let searchButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "search").withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .mainPurple
        button.setDimensions(width: 22, height: 24)
        button.addTarget(self, action: #selector(handleSearchAction), for: .touchUpInside)

        return button
    }()

    private let uploadButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "add").withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .mainPurple
        button.backgroundColor = .white
        button.imageView?.setDimensions(width: 22, height: 22)
        button.setDimensions(width: 42, height: 42)
        button.layer.cornerRadius = 42 / 2
        button.addTarget(self, action: #selector(handleUploadAction), for: .touchUpInside)
        

        return button
    }()
    
    private let addArtworkButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "addArtwork").withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .mainPurple
        button.backgroundColor = .white
        button.imageView?.setDimensions(width: 22, height: 22)
        button.setDimensions(width: 42, height: 42)
        button.layer.cornerRadius = 42 / 2
        button.addTarget(self, action: #selector(handleAddArtwork), for: .touchUpInside)
        button.alpha = 0
        
        return button
    }()
    
    private let addExhibitionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "addExhibition").withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .mainPurple
        button.backgroundColor = .white
        button.imageView?.setDimensions(width: 22, height: 22)
        button.setDimensions(width: 42, height: 42)
        button.layer.cornerRadius = 42 / 2
        button.addTarget(self, action: #selector(handleAddExhibition), for: .touchUpInside)
        button.alpha = 0
        
        return button
    }()
    
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
        
        fetchExhibitions()
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("DEBUG: View will appear in main controller..")
        fetchExhibitions()
    }
    
    //MARK: - API
    func fetchExhibitions() {
        tableView.refreshControl?.beginRefreshing()
        ExhibitionService.shared.fetchExhibitions { exhibitions in
            self.exhibitions = exhibitions
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.tableView.refreshControl?.endRefreshing()
            }
        }
    }
    
    //MARK: - Selectors
    @objc func handleUploadAction() {
        uploadButtonAnimate()
    }
    
    @objc func handleMenuAction() {
        delegate?.handleMenuToggle()
    }
    
    @objc func handleSearchAction() {
        guard let user = user else { return }
        let controller = SearchController(user: user)
        let nav = UINavigationController(rootViewController: controller)
        present(nav, animated: true, completion: nil)
    }
    
    @objc func handleAddArtwork() {
        guard let user = user else { return }
        let controller = AddArtworkController(user: user)
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true) {
            self.uploadButtonAnimate()
        }
    }
    
    @objc func handleAddExhibition() {
        guard let user = user else { return }
        let controller = AddExhibitionController(user: user)
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true) {
            self.uploadButtonAnimate()
        }
    }
    
    @objc func handleShowUserProfile() {
        guard let costUser = costUser else { return }
        let controller = UserProfileController(user: costUser)
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true, completion: nil)
    }
    
    @objc func handleRefresh() {
        fetchExhibitions()
    }
    
    //MARK: - Helpers
    func configureUI() {
        view.backgroundColor = .mainBackground
        configureTableView()
        
        view.addSubview(menuButton)
        menuButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, paddingTop: 16, paddingLeft: 16)
        
        view.addSubview(searchButton)
        searchButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, right: view.rightAnchor, paddingTop: 16, paddingRight: 16)
        
        view.addSubview(tableView)
        tableView.anchor(top: searchButton.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 16, paddingLeft: 16, paddingRight: 16)
        
        view.addSubview(uploadButton)
        uploadButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, right: searchButton.rightAnchor, paddingBottom: 20)
        
        view.addSubview(addExhibitionButton)
        addExhibitionButton.centerX(inView: uploadButton)
        addExhibitionButton.anchor(bottom: uploadButton.topAnchor, paddingBottom: 26)
        
        view.addSubview(addArtworkButton)
        addArtworkButton.centerX(inView: uploadButton)
        addArtworkButton.anchor(bottom: addExhibitionButton.topAnchor, paddingBottom: 20)
    }
    
    func configureTableView() {
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = .mainBackground
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        tableView.register(MainCellRenew.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self

        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    func buttonAlpha(alpha: CGFloat) {
        addArtworkButton.alpha = alpha
        addExhibitionButton.alpha = alpha
    }
    
    func uploadButtonAnimate() {
        if buttonIsActive == false {
            UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: .curveEaseInOut) {
                self.uploadButton.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi / 4))
                self.buttonAlpha(alpha: 1)
            } completion: { _ in
                self.buttonIsActive = true
            }
        } else {
            UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: .curveEaseInOut) {
                self.uploadButton.transform = CGAffineTransform.identity
                self.buttonAlpha(alpha: 0)
            } completion: { _ in
                self.buttonIsActive = false
            }
        }
    }
}

extension MainControllerRenew: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return exhibitions.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! MainCellRenew
        cell.exhibition = exhibitions[indexPath.section]
        
        return cell
    }
}

extension MainControllerRenew: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 12
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView()
        header.backgroundColor = UIColor.clear
        return header
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selected = exhibitions[indexPath.section]
//        let selected = exhibitions[indexPath.row]
        guard let user = user else { return }
        let controller = ExhibitionDetailController(user: user)
        controller.exhibition = selected
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
}
