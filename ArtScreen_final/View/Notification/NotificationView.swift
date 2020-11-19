//
//  NotifivationView.swift
//  ArtScreen_final
//
//  Created by Heng on 2020/11/17.
//

import UIKit

private let reuseIdentifier = "NotificationCell"

class NotificationView: UIView {
    
    //MARK: - Properties
    private var tableView = UITableView()
    private let headerView = NotificationHeaderView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 70))
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .mainPurple
        configureTableView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureTableView() {
        tableView.backgroundColor = .mainBackground
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(NotificationCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.rowHeight = 60
        tableView.tableHeaderView = headerView
        tableView.isScrollEnabled = false
        headerView.titleLabel.text = "Notification"
        
        addSubview(tableView)
        tableView.addConstraintsToFillView(self)
        
    }
}

extension NotificationView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! NotificationCell
        
        return cell
    }
}

extension NotificationView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("DEBUG: Cell did selected..")
    }
}
