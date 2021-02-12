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
    var user: User?
    var artwork: ArtworkDetail?
    var comments = [CommentDetail]()
    var isLike = false
    
    private lazy var headerView: ArtworkDetailHeaderView = {
        let frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 500)
        let view = ArtworkDetailHeaderView(frame: frame)
        
        return view
    }()
    
    private lazy var customInputView: CustomInputAccessoryView = {
        let inputView = CustomInputAccessoryView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 50))
        inputView.delegate = self
        
        return inputView
    }()
    
    private let footerView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 126))
        return view
    }()
    
    //MARK: - Init
    init(user: User, artwork: ArtworkDetail) {
        self.user = user
        self.artwork = artwork
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
        configureNavigationBar()
        configureArtworkData()
        fetchComment()
    }
    
    override var inputAccessoryView: UIView? {
        get { return customInputView }
    }

    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    //MARK: - API
    func fetchComment() {
        guard let artwork = artwork else { return }
        CommentService.shared.fetchComment(artwork: artwork) { comments in
            self.comments = comments
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    func checkIsUserLike() {
        guard let artwork = artwork else { return }
        LikeService.shared.checkUserIsLike(withState: .artwork, artwork: artwork) { (isLike) in
            self.isLike = isLike
        }
    }

    //MARK: - Selectors
    @objc func handleDismissal() {
        print("DEBUG: dismissal detail controller")
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Helpers
    func configureNavigationBar() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(handleDismissal))
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
        
        tableView.alwaysBounceVertical = true
        tableView.keyboardDismissMode = .interactive
    }
    
    func configureArtworkData() {
        guard let artwork = artwork else { return }
        headerView.artworkImageView.sd_setImage(with: artwork.path)
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
            cell.artworkNameLabel.text = artwork?.artworkName
            cell.introductionLabel.text = artwork?.information
            
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: commentIdentifier, for: indexPath) as! ArtworkCommentCell
            cell.artwork = artwork
            return cell
        default:
            fatalError("Failed to instantiate the table view cell for artwork detail controller")
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 1 {
            guard let user = user else { return }
            guard let artwork = artwork else { return }
            let controller = CommentController(user: user, artwork: artwork)
    //        controller.comments = comments
            navigationController?.pushViewController(controller, animated: true)
        }
    }
}

//MARK: - CustomInputAccessoryViewDelegate
extension ArtworkDetailController: CustomInputAccessoryViewDelegate {
    func inputView(_ inputView: CustomInputAccessoryView, eantsToSend message: String) {
        guard let artwork = artwork else { return }
        guard let user = user else { return }
        CommentService.shared.uploadComment(artwork: artwork, user: user, message: message) { error in
            DispatchQueue.main.async {
                if let error = error {
                    print("DEBUG: Error is \(error.localizedDescription)")
                    return
                }
                inputView.clearMessageText()
                self.fetchComment()
//                self.tableView.reloadData()
            }
        }
    }
}

extension ArtworkDetailController: ArtworkDetailHeaderViewDelegate {
    func handleArtworkLike() {
        isLike.toggle()
        if isLike {
            print("DEBUG: do Like")
            guard let artwork = artwork else { return }
            LikeService.shared.fetchLikeArtwork(withArtwork: artwork)
            
        } else {
            print("DEBUG: do unLike")
            guard let artwork = artwork else { return }
            LikeService.shared.unlike(withState: .artwork, artwork: artwork)
        }
    }
}
