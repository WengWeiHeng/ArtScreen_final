//
//  NotificationController.swift
//  ArtScreen_final
//
//  Created by Heng on 2020/11/13.
//

import UIKit

class NotificationController: UIViewController {
    
    //MARK: - Properties
    var user : User?
    var notificationView : NotificationView!

    private var messageView = MessageView()
    
    private let sendView = ExhibitionSendView()
    private var sendViewBottom = NSLayoutConstraint()
    private let sendViewHeight: CGFloat = screenHeight * 0.5
    
    //MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    //MARK: - Selectors
    @objc func handleClose() {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Helpers
    func configureUI() {
        configureNavigationBar()
        notificationView = NotificationView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight), user: user!)
        
        view.addSubview(notificationView)
        notificationView.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, height: 400)
        notificationView.user = user
        
        view.addSubview(messageView)
        messageView.anchor(top: notificationView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 40, height: 300)
        messageView.delegate = self
        
        view.addSubview(sendView)
        sendView.translatesAutoresizingMaskIntoConstraints = false
        sendView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        sendView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        sendViewBottom = sendView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: sendViewHeight)
        sendViewBottom.isActive = true
        sendView.heightAnchor.constraint(equalToConstant: sendViewHeight).isActive = true
        sendView.layer.cornerRadius = 24
        sendView.delegate = self
        
    }
    
    func configureNavigationBar() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(handleClose))
        
        view.backgroundColor = .mainBackground
    }
}

extension NotificationController: MessageViewDelegate {
    func handleShowSendView() {
        let transitionAnimator = UIViewPropertyAnimator(duration: 0.6, dampingRatio: 1) {
            self.sendViewBottom.constant = 0
            self.view.layoutIfNeeded()
        }
        transitionAnimator.startAnimation()
    }
}

extension NotificationController: ExhibitionSendViewDelegate {
    func didTappedExhibiSetting_Send_cancel() {
        let transitionAnimator = UIViewPropertyAnimator(duration: 0.6, dampingRatio: 1) {
            self.sendViewBottom.constant = self.sendViewHeight
            self.view.layoutIfNeeded()
        }
        transitionAnimator.startAnimation()
    }
}
