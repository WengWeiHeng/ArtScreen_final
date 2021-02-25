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
        view.delegate = self
        
        return view
    }()
    
    private lazy var customInputView: CustomInputAccessoryView = {
        let inputView = CustomInputAccessoryView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 50))
        inputView.delegate = self
        
        return inputView
    }()
    
    private let footerView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 300))

        return view
    }()
    
    //MARK: - Init
    init(user: User, artwork: ArtworkDetail) {
        self.user = user
        self.artwork = artwork
        super.init(nibName: nil, bundle: nil)
        checkIsUserLike()
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchArtworkWithID()
        print("DEBUG: view will appear in Artwork detail controller..")
        tableView.reloadData()

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
//                self.reloadInputViews()
            }
        }
    }
    
    func fetchArtworkWithID() {
        guard let artwork = artwork else { return }
        ArtworkService.shared.fetchArtworkWithID(artwork: artwork) { artwork in
            self.artwork = artwork
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    func checkIsUserLike() {
        guard let artwork = artwork else { return }
        LikeService.shared.checkUserIsLike(withState: .artwork, artwork: artwork) { (isLike) in
            DispatchQueue.main.async {
                self.isLike = isLike
                self.likeButtonStyle(isLike: isLike, button: self.headerView.likeButton)
            }
            
        }
    }

    //MARK: - Selectors
    @objc func handleDismissal() {
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
    
    func likeButtonStyle(isLike: Bool, button: UIButton) {
        if isLike {
            UIView.animate(withDuration: 0.4) {
                button.backgroundColor = .mainBackground
                button.tintColor = .mainPurple
            }
        } else {
            UIView.animate(withDuration: 0.4) {
                button.backgroundColor = .mainPurple
                button.tintColor = .white
            }
        }
    }
}

extension ArtworkDetailController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("DEBUG: tableview number")
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
        print("DEBUG: cell be tapped")
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

//MARK: - ArtworkDetailHeaderDelegate
extension ArtworkDetailController: ArtworkDetailHeaderViewDelegate {
    func handleArtworkLike(button: UIButton) {
        isLike.toggle()
        if isLike {
            print("DEBUG: do Like")
            guard let artwork = artwork else { return }
            LikeService.shared.fetchLikeArtwork(withArtwork: artwork)
            likeButtonStyle(isLike: isLike, button: button)
            
        } else {
            print("DEBUG: do unLike")
            guard let artwork = artwork else { return }
            LikeService.shared.unlike(withState: .artwork, artwork: artwork)
            likeButtonStyle(isLike: isLike, button: button)
        }
    }
    
    func editArtwork() {
        let alert = UIAlertController(title: "Edit Artwork information", message: "", preferredStyle: .actionSheet)
        alert.view.tintColor = .mainPurple
        
        alert.addAction(UIAlertAction(title: "Edit", style: .default, handler: { _ in
            guard let artwork = self.artwork else { return }
            let controller = ArtworkEditController(artwork: artwork)
            controller.delegate = self
            let nav = UINavigationController(rootViewController: controller)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "Delete", style: .default, handler: { _ in
            guard let artwork = self.artwork else { return }
            ArtworkService.shared.deleteArtwork(artworkID: artwork.artworkID)
            
            self.dismiss(animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in

        }))

        self.present(alert, animated: true, completion: nil)
    }
}

extension ArtworkDetailController: ArtworkEditControllerDelegate {
    func reloadTableView() {
        fetchArtworkWithID()
    }
}
