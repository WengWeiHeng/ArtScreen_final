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
    var user: User? {
        didSet {
            fetchUserNoftification()
        }
    }
    var notifications = [NotificationDetail]()

    private var tableView = UITableView()
    private let headerView = NotificationHeaderView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 70))
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .mainPurple
        configureTableView()
    }
    
    init (frame : CGRect, user: User){
        super.init(frame: frame)
        self.user = user
        self.backgroundColor = .mainPurple
        self.configureTableView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - API
    func fetchUserNoftification() {
        guard let user = user else { return }
        NotificationService.share.getNotification(forUser: user) { [self] (notifications) in
            self.notifications = notifications
            DispatchQueue.main.async {
                tableView.reloadData()
            }
        }
    }

    //MARK: - Helper
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
        return notifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! NotificationCell
        cell.notification = notifications[indexPath.row]
        
        return cell
    }
}

extension NotificationView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("DEBUG: Cell did selected..")
    }
}

