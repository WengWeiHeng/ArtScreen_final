//
//  CommentController.swift
//  ArtScreen_final
//
//  Created by Heng on 2020/11/13.
//

import UIKit

private let reuseIdentifier = "CommentCell"

class CommentController: UITableViewController {
    
    //MARK: - Properties
    var user: User?
    var artwork: ArtworkDetail?
    var comments  = [CommentDetail]()
    
    private lazy var customInputView: CustomInputAccessoryView = {
        let inputView = CustomInputAccessoryView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 50))
        inputView.delegate = self
        
        return inputView
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
        fetchComment()
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
            }
        }
    }
    
    //MARK: - Helpers
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CommentCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 50))
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.isScrollEnabled = true
        tableView.backgroundColor = .mainDarkGray
    }
}

extension CommentController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! CommentCell
        cell.messageLabel.numberOfLines = 0
        cell.comment = comments[indexPath.row]
        
        return cell
    }
}

//MARK: - CustomInputAccessoryViewDelegate
extension CommentController: CustomInputAccessoryViewDelegate {
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
