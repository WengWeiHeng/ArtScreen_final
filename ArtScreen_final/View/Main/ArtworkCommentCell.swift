//
//  ArtworkCommentCell.swift
//  ArtScreen_final
//
//  Created by Heng on 2020/11/12.
//

import UIKit

private let CommentIdentifier = "CommentCell"

class ArtworkCommentCell: UITableViewCell {
    
    //MARK: - Properties
    var artwork: ArtworkDetail? {
        didSet {
            fetchComment()
        }
    }

    var comments = [CommentDetail]()
    private var tableView = UITableView()
    
    private let allCommentButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = .boldSystemFont(ofSize: 14)
        button.setTitleColor(.mainBackground, for: .normal)
        button.setTitle("Read all comment", for: .normal)
        button.setDimensions(width: 120, height: 20)
        
        return button
    }()
//    func configureHeight(bottom: CGFloat) {
//        addSubview(allCommentButton)
//        allCommentButton.anchor(left: leftAnchor, bottom: bottomAnchor, paddingLeft: 16, paddingBottom: bottom)
//
//        addSubview(tableView)
//        tableView.anchor(top: topAnchor, left: leftAnchor, bottom: allCommentButton.topAnchor, right: rightAnchor)
////        tableView.setHeight(height: height)
//        tableView.register(CommentCell.self, forCellReuseIdentifier: CommentIdentifier)
//        tableView.rowHeight = 65
//        tableView.backgroundColor = .none
//        tableView.separatorStyle = .none
//        tableView.isScrollEnabled = false
//        tableView.delegate = self
//        tableView.dataSource = self
//
//
//
////        print("DEBUG: Height is \(height)")
//        print("DEBUG: Height is \(tableView.frame.height)")
//    }
    
    //MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        print("DEBUG: init")
        backgroundColor = .mainDarkGray
        selectionStyle = .none
        
        addSubview(tableView)
        tableView.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor)
        tableView.register(CommentCell.self, forCellReuseIdentifier: CommentIdentifier)
        tableView.rowHeight = 65
        tableView.backgroundColor = .none
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        tableView.delegate = self
        tableView.dataSource = self
        
        addSubview(allCommentButton)
        allCommentButton.anchor(top: tableView.bottomAnchor, left: leftAnchor, paddingTop: 8, paddingLeft: 16)

        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: - API
    func fetchComment() {
        guard let artwork = artwork else { return }
        CommentService.shared.fetchComment(artwork: artwork) { comments in
            self.comments = comments
            DispatchQueue.main.async {
                if comments.isEmpty {
                    self.tableView.removeFromSuperview()
                    self.allCommentButton.removeFromSuperview()
                } else {
                    if comments.count <= 3 {
                        self.tableView.setHeight(height: CGFloat(comments.count * 65))
                    } else {
                        self.tableView.setHeight(height: CGFloat(3 * 65))
                    }
                }
                self.tableView.reloadData()
            }
        }
    }
}

//MARK: - TableViewDelegate
extension ArtworkCommentCell: UITableViewDelegate {
    
}

//MARK: - TableViewDataSource
extension ArtworkCommentCell: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if comments.isEmpty {
            return 0
        } else {
            return comments.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CommentIdentifier, for: indexPath) as! CommentCell
        cell.messageLabel.numberOfLines = 1
        cell.comment = comments[indexPath.row]
        
        return cell
    }
}
