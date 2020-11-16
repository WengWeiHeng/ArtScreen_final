//
//  NotificationController.swift
//  ArtScreen_final
//
//  Created by Heng on 2020/11/13.
//

import UIKit

private let reuseIdentifier = "NotificationCell"

class NotificationController: UITableViewController {
    
    //MARK: - Properties
    private let headerView = NotificationHeaderView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 70))
    
    //MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
        configureTableView()
    }
    
    //MARK: - Selectors
    @objc func handleClose() {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Helpers
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
        tableView.tableFooterView = UIView()
    }
}

extension NotificationController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! NotificationCell
        
        return cell
    }
}

