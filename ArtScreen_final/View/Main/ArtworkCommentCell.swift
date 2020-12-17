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
    
    //MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .mainPurple
        selectionStyle = .none
        
        addSubview(tableView)
        tableView.addConstraintsToFillView(self)
        tableView.setHeight(height: 195)
        tableView.register(CommentCell.self, forCellReuseIdentifier: CommentIdentifier)
        tableView.rowHeight = 65
        tableView.backgroundColor = .none
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        tableView.delegate = self
        tableView.dataSource = self
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
                self.tableView.reloadData()
            }
        }
    }
    
    func configureData() {
        
    }
}

extension ArtworkCommentCell: UITableViewDelegate {
    
}

extension ArtworkCommentCell: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if comments.isEmpty {
            return 0
        } else {
            return 3
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CommentIdentifier, for: indexPath) as! CommentCell
        cell.messageLabel.numberOfLines = 1
        cell.comment = comments[indexPath.row]
        
        return cell
    }
    
    
}
