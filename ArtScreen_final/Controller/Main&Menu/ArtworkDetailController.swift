//
//  ArtworkDetailController.swift
//  ArtScreen_final
//
//  Created by Heng on 2020/11/12.
//

import UIKit

private let reuseIdentifier = "ArtworkDetailCell"
private let commentIdentifier = "ArtworkCommentCell"

class ArtworkDetailController: UITableViewController {
    
    //MARK: - Properties
    
    private lazy var headerView: ArtworkDetailHeaderView = {
        let frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 500)
        let view = ArtworkDetailHeaderView(frame: frame)
//        view.artworkImageView.sd_setImage(with: artwork?.artworkImageUrl)
        
        return view
    }()
    
    private lazy var footerView: UIView = {
        let frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 80)
        let view = UIView(frame: frame)
        
        let button = UIButton(type: .system)
        button.titleLabel?.font = .boldSystemFont(ofSize: 14)
        button.setTitleColor(.mainBackground, for: .normal)
        button.setTitle("Read all comment", for: .normal)
        button.addTarget(self, action: #selector(handleShowAllComment), for: .touchUpInside)
        button.setDimensions(width: 120, height: 20)
        
        view.addSubview(button)
        button.anchor(top: view.topAnchor, left: view.leftAnchor, paddingTop: 12, paddingLeft: 16)
        
        return view
    }()
    
    //MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
        configureNavigationBar()
    }

    //MARK: - Selectors
    @objc func handleDismissal() {
        print("DEBUG: dismissal detail controller")
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleShowAllComment() {
        let controller = CommentController()
        navigationController?.pushViewController(controller, animated: true)
    }
    
    //MARK: - Helpers
    func configureNavigationBar() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "close").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleDismissal))
    }
    
    func configureTableView() {
        tableView.backgroundColor = .mainDarkGray
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.isScrollEnabled = true
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(ArtworkDetailCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.register(ArtworkCommentCell.self, forCellReuseIdentifier: commentIdentifier)
        tableView.tableHeaderView = headerView
        tableView.tableFooterView = footerView
        tableView.scrollsToTop = true
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension ArtworkDetailController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! ArtworkDetailCell
//            cell.artworkNameLabel.text = artwork?.name
//            cell.introductionLabel.text = artwork?.introduction
            
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: commentIdentifier, for: indexPath) as! ArtworkCommentCell
            return cell
        default:
            fatalError("Failed to instantiate the table view cell for artwork detail controller")
        }
    }
}