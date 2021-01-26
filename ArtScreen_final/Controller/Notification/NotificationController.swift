//
//  NotificationController.swift
//  ArtScreen_final
//
//  Created by Heng on 2021/1/22.
//

import UIKit

private let reuseIdentifier = "NotificationCell"

class NotificationController: UITableViewController {
    
    //MARK: - Properties
    var user : User?
    var notifications = [NotificationDetail]()
    private let headerView = NotificationHeaderView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 70))
    
    //MARK: - Init
    init(user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
        
        fetchUserNotification()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
        configureUI()
        configureTableView()
    }
    
    //MARK: - API
    func fetchUserNotification() {
        guard let user = user else { return }
        NotificationService.share.getNotification(forUser: user) { notifications in
            self.notifications = notifications
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    //MARK: - Selectors
    @objc func handleClose() {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Helpers
    func configureUI() {
        view.backgroundColor = .mainBackground
    }
    
    func configureNavigationBar() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(handleClose))
        
        view.backgroundColor = .mainBackground
    }
    
    func configureTableView() {
        tableView.backgroundColor = .mainBackground
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(NotificationCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.rowHeight = 60
        tableView.tableHeaderView = headerView
        tableView.isScrollEnabled = false
        tableView.separatorStyle = .none
        headerView.titleLabel.text = "Notification"
    }
}

extension NotificationController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! NotificationCell
        cell.notification = notifications[indexPath.row]

        return cell
    }
}
