//
//  MessageView.swift
//  ArtScreen_final
//
//  Created by Heng on 2020/11/17.
//

import UIKit

private let reuseIdentifier = "MessageCell"

protocol MessageViewDelegate: class {
    func handleShowSendView()
}

class MessageView: UIView {
    
    //MARK: - Properties
    weak var delegate: MessageViewDelegate?
    
    let message: [Int] = []
    private var tableView = UITableView()
    private let headerView = NotificationHeaderView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 70))
    
    private lazy var announceView: UIView = {
        let view = Utilities().noArtworkAnnounceView(announceText: "You have no any message yet", buttonSelector: #selector(handleSendMessage), buttonText: "Send", textColor: .mainPurple)
        
        return view
    }()
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .mainBackground
        
        addSubview(headerView)
        headerView.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor)
        headerView.titleLabel.text = "Message"
        
        if message.count == 0 {
            configureAnnounceView()
            
        } else {
            configureTableView()
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Selectors
    @objc func handleSendMessage() {
        delegate?.handleShowSendView()
    }
    
    //MARK: - Helpers
    func configureAnnounceView() {
        addSubview(announceView)
        announceView.centerX(inView: self)
        announceView.centerY(inView: self)
    }
    
    func configureTableView() {
        tableView.backgroundColor = .mainBackground
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MessageCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.rowHeight = 60
        
        tableView.isScrollEnabled = false
        
        addSubview(tableView)
        tableView.addConstraintsToFillView(self)
        
    }
}

extension MessageView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! MessageCell
        
        return cell
    }
}

extension MessageView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("DEBUG: Cell did selected..")
    }
}
