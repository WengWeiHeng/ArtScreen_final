//
//  ContainerController.swift
//  ArtScreen_final
//
//  Created by Heng on 2020/10/22.
//

import UIKit

let screen = UIScreen.main.bounds
let screenWidth = screen.size.width
let screenHeight = screen.size.height

class ContainerController: UIViewController {
    
    //MARK: - Properties
    var user: User?
    
//    private var mainController: MainViewController!
    private var mainController: MainControllerRenew!
    private var menuController: MenuController!
    private var isExpanded = false
    private lazy var xOrigin = self.view.frame.width - 200
    private lazy var yOrigin = self.view.frame.height * 0.15
    
    //MARK: - Init
    init(user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .mainBackground
//        authenticateUser()
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }
    
    override var prefersStatusBarHidden: Bool{
        return isExpanded
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation{
        return .slide
    }

    //MARK: - Selectors
    @objc func dismissMenu(){
        isExpanded = false
        animateMenu(shouldExpand: isExpanded)
    }
    
    //MARK: - Helpers
    func configureUI() {
        configureMainController()
        configureMenuController()
    }
    
    func configureMainController() {
        guard let user = user else { return }
//        mainController = MainViewController(user: user)
        mainController = MainControllerRenew(user: user)
        addChild(mainController)
        mainController.didMove(toParent: self)
        view.addSubview(mainController.view)
        mainController.delegate = self
    }
    
    func configureMenuController() {
        guard let user = user else { return }
        menuController = MenuController(user: user)
        addChild(menuController)
        menuController.didMove(toParent: self)
        view.insertSubview(menuController.view, at: 0)
        menuController.delegate = self
    }
    
    func animateMenu(shouldExpand: Bool, completion: ((Bool) -> Void)? = nil){
        if shouldExpand{
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                self.mainController.view.frame.origin.x = self.xOrigin
                self.mainController.view.frame.origin.y = self.yOrigin
                self.mainController.view.frame.size.width = self.view.frame.size.width * 0.73
                self.mainController.view.frame.size.height = self.view.frame.size.height * 0.73
            }, completion: nil)
        } else {
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                self.mainController.view.frame.origin.x = 0
                self.mainController.view.frame.origin.y = 0
                self.mainController.view.frame.size.width = self.view.frame.size.width
                self.mainController.view.frame.size.height = self.view.frame.size.height
            }, completion: completion)
        }
        
        animateStatusBar()
    }
    
    func animateStatusBar(){
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.setNeedsStatusBarAppearanceUpdate()
        }, completion: nil)
    }
}

//MARK: - MainController delegate
//extension ContainerController: MainControllerDelegate {
//    func handleMenuToggle() {
//        isExpanded.toggle()
//        animateMenu(shouldExpand: isExpanded)
//    }
//}

extension ContainerController: MainControllerRenewDelegate {
    func handleMenuToggle() {
        isExpanded.toggle()
        animateMenu(shouldExpand: isExpanded)
    }
}

//MARK: - MenuControllerDelegate
extension ContainerController: MenuControllerDelegate {
    func handleMenuDismissal() {
        dismissMenu()
    }
    
    func handleShowProfilePage() {
        guard let user = user else { return }
        let controller = UserProfileController(user: user)
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true) {
            self.dismissMenu()
        }
    }
    
    func handleLogout() {
//        logout()
    }
}
