//
//  MenuController.swift
//  ArtScreen_final
//
//  Created by Heng on 2020/10/22.
//

import UIKit

private let reuseIdentifier = "MenuTableViewCell"

protocol MenuControllerDelegate: class {
    func handleMenuDismissal()
    func handleShowProfilePage()
    func handleLogout()
}

class MenuController: UIViewController {
    
    //MARK: - Properties
    var tableView = UITableView()
    weak var delegate: MenuControllerDelegate?
    
    private lazy var menuHeader: MenuHeader = {
        let frame = CGRect(x: 0, y: 0, width: self.view.frame.width - 80, height: 200)
        let view = MenuHeader(frame: frame)
        view.delegate = self
        
        return view
    }()
    
    //MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    //MARK: - Helpers
    func configureUI() {
        tableView.backgroundColor = .mainPurple
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        tableView.rowHeight = 50
        tableView.register(MenuTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.tableHeaderView = menuHeader
        
        tableView.delegate = self
        tableView.dataSource = self
        
        view.addSubview(tableView)
        tableView.addConstraintsToFillView(view)
    }
}

//MARK: - TableViewDatabase
extension MenuController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MenuOptions.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! MenuTableViewCell
        
        guard let option = MenuOptions(rawValue: indexPath.row) else { return MenuTableViewCell() }
        cell.optionLabel.text = option.description
        cell.iconImageView.image = UIImage(named: option.iconImage)
        
        return cell
    }
}

//MARK: - TableViewDelegate
extension MenuController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let option = MenuOptions(rawValue: indexPath.row)
        
        switch option {
        case .notification:
            print("DEBUG: Show notification page..")
        case .placeMap:
            let controller = ArtMapController()
            let nav = UINavigationController(rootViewController: controller)
            nav.modalPresentationStyle = .fullScreen
            present(nav, animated: true, completion: nil)
        case .arCamere:
            print("DEBUG: ARCamera")
            let controller = ARCameraController()
            let nav = UINavigationController(rootViewController: controller)
            nav.modalPresentationStyle = .fullScreen
            present(nav, animated: true, completion: nil)
        case .setting:
            print("DEBUG: Show setting page..")
        case .instructions:
            print("DEBUG: Show Instructions page..")
        case .logOut:
            print("DEBUG: Logout")
//            UIView.animate(withDuration: 0.8, animations: {
//                self.delegate?.handleMenuDismissal()
//                self.delegate?.handleLogout()
//            }, completion: nil)
        default:
            print("Error..")
        }
    }
}

//MARK: - MenuHeaderDelegate
extension MenuController: MenuHeaderDelegate {
    func handleShowProfilePage() {
        delegate?.handleShowProfilePage()
    }
    
    func handleMenuDismissal() {
        delegate?.handleMenuDismissal()
    }
}
