//
//  UserProfileController.swift
//  ArtScreen_final
//
//  Created by Heng on 2020/10/22.
//

import UIKit

private enum State {
    case closed
    case open
}

class UserProfileController: UIViewController {
    
    //MARK: - Properties
    var user: User?
    var isFollowed = false
    
    let userCoverView = UserCoverView()
    let userContentView = UserContentView()
    
    private let popupOffset: CGFloat = UIScreen.main.bounds.height
    private var bottomConstraint = NSLayoutConstraint()
    
    private var currentState: State = .closed
    private var runningAnimators = [UIViewPropertyAnimator]()
    private var animationProgress = [CGFloat]()
    private var isEditting = false
    
    // SettingBar Properties
    let editToolBarView = EditToolBarView()
    let templeSettingView = TempleSettingView()
    
    private let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "close").withRenderingMode(.alwaysOriginal), for: .normal)
        button.setDimensions(width: 24, height: 24)
        button.addTarget(self, action: #selector(handleDismissMenu), for: .touchUpInside)
        
        return button
    }()
    
    private let actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setDimensions(width: 100, height: 36)
        button.layer.cornerRadius = 36 / 2

        return button
    }()
    
    private let userInfoView = UserInfoView()
    
    private lazy var panRecognizer: UIPanGestureRecognizer = {
        let recognizer = UIPanGestureRecognizer()
        recognizer.addTarget(self, action: #selector(contentViewPanned(recognizer:)))
        
        return recognizer
    }()
    
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
        
        guard let user = user else { return }
        checkUserIs(user: user)
        configureUI()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barStyle = .black
    }
    
    //MARK: - API
    func checkUserIs(user: User) {
        let currentUser = UserDefaults.standard.value(forKey: "parseJSON") as? NSDictionary
        if user.username != currentUser!["username"] as! String {
            checkUserisFollowing(user: user)
        } else {
            actionButton.setTitle("Edit", for: .normal)
            actionButton.layer.borderColor = UIColor.white.cgColor
            actionButton.layer.borderWidth = 1.25
            actionButton.addTarget(self, action: #selector(handleEditAction), for: .touchUpInside)
        }
    }
    
    func checkUserisFollowing(user: User) {
        UserService.shared.checkUserIsFollowing(user: user) { (isFollowed) in
            DispatchQueue.main.async {
                self.isFollowed = isFollowed
                self.actionButtonStyle(isFollowed: isFollowed)
            }
        }
    }
    
    func userFollowing() {
        guard let user = user else { return }
        UserService.shared.followingUser(user: user)
        actionButtonStyle(isFollowed: true)
    }
    
    func unfollowUser() {
        guard let user = user else { return }
        UserService.shared.unfollowUser(user: user)
        actionButtonStyle(isFollowed: false)
    }
    
    //MARK: - Selectors
    @objc func handleDismissMenu() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleEditAction() {
        isEditting.toggle()
        if isEditting {
            actionButton.backgroundColor = .mainPurple
            actionButton.setTitle("Save", for: .normal)
            actionButton.layer.borderWidth = 0
            
            UIView.animate(withDuration: 0.3) {
                self.userInfoView.alpha = 0
                self.closeButton.alpha = 0
                self.editToolBarView.alpha = 1
            }
        } else {
            actionButton.backgroundColor = .none
            actionButton.setTitle("Edit", for: .normal)
            actionButton.layer.borderWidth = 1.25
            
            UIView.animate(withDuration: 0.3) {
                self.userInfoView.alpha = 1
                self.closeButton.alpha = 1
                self.editToolBarView.alpha = 0
            }
        }
    }
    
    @objc private func contentViewPanned(recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            animateTransitionIfNeeded(to: currentState.opposite, duration: 1)
            runningAnimators.forEach { $0.pauseAnimation() }
            animationProgress = runningAnimators.map { $0.fractionComplete }
        case .changed:
            let translation = recognizer.translation(in: userContentView)
            var fraction = -translation.y / popupOffset
            if currentState == .open { fraction *= -1 }
            if runningAnimators[0].isReversed { fraction *= -1 }
            
            for (index, animator) in runningAnimators.enumerated() {
                animator.fractionComplete = fraction + animationProgress[index]
            }
        case .ended:
            let yVelocity = recognizer.velocity(in: userContentView).y
            let shouldClose = yVelocity > 0
            
            if yVelocity == 0 {
                runningAnimators.forEach { $0.continueAnimation(withTimingParameters: nil, durationFactor: 0) }
                break
            }
            
            switch currentState {
            case .open:
                if !shouldClose && !runningAnimators[0].isReversed { runningAnimators.forEach {
                    $0.isReversed = !$0.isReversed
                }}
                
                if shouldClose && runningAnimators[0].isReversed { runningAnimators.forEach {
                    $0.isReversed = !$0.isReversed
                }}
            case .closed:
                if shouldClose && !runningAnimators[0].isReversed { runningAnimators.forEach {
                    $0.isReversed = !$0.isReversed
                }}
                
                if !shouldClose && runningAnimators[0].isReversed { runningAnimators.forEach {
                    $0.isReversed = !$0.isReversed
                }}
            }
            runningAnimators.forEach{ $0.continueAnimation(withTimingParameters: nil, durationFactor: 0) }
        default:
            ()
        }
    }
    
    @objc func handleFollowAction() {
        userFollowing()
    }
    
    @objc func handleUnfollowAction() {
        unfollowUser()
    }
    
    //MARK: - Helpers
    func configureUI() {
        view.backgroundColor = .mainDarkGray
        
        view.addSubview(userCoverView)
        userCoverView.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, height: view.frame.height - 160)
        userCoverView.delegate = self
        userCoverView.user = user
        
        view.addSubview(userInfoView)
        userInfoView.anchor(top: userCoverView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor)
        
        view.addSubview(actionButton)
        actionButton.anchor(bottom: userCoverView.bottomAnchor, right: view.rightAnchor, paddingBottom: 16, paddingRight: 12)
        
        userContentView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(userContentView)
        userContentView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        userContentView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        bottomConstraint = userContentView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: popupOffset - 75)
        bottomConstraint.isActive = true
        userContentView.heightAnchor.constraint(equalToConstant: popupOffset).isActive = true
        userContentView.addGestureRecognizer(panRecognizer)
        userContentView.delegate = self
        userContentView.user = user
        
        view.addSubview(closeButton)
        closeButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, right: view.rightAnchor, paddingTop: 12, paddingRight: 12)
        
        configureAllSettingBars()
    }
    
    func configureAllSettingBars() {
        view.addSubview(editToolBarView)
        editToolBarView.anchor(left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, height: 160)
        editToolBarView.alpha = 0
        editToolBarView.delegate = self
        
        view.addSubview(templeSettingView)
        templeSettingView.anchor(left: editToolBarView.leftAnchor, bottom: editToolBarView.bottomAnchor, right: editToolBarView.rightAnchor, height: 160)
        templeSettingView.alpha = 0
        templeSettingView.delegate = self
    }
    
    // popup animate
    private func animateTransitionIfNeeded(to state: State, duration: TimeInterval) {
        
        guard runningAnimators.isEmpty else { return }
        let state = currentState.opposite
        
        let transitionAnimator = UIViewPropertyAnimator(duration: 1, dampingRatio: 1) {
            switch state {
            case .open:
                self.bottomConstraint.constant = 0
                self.userContentView.profileInfoView.alpha = 1
                self.userInfoView.alpha = 0
            case .closed:
                self.bottomConstraint.constant = self.popupOffset - 65
                self.userContentView.profileInfoView.alpha = 0
                self.userInfoView.alpha = 1
            }
            self.view.layoutIfNeeded()
        }
        
        transitionAnimator.addCompletion { position in
            switch position {
            case .start:
                self.currentState = state.opposite
            case .end:
                self.currentState = state
            default:
                ()
            }
            
            switch self.currentState {
            case .open:
                self.bottomConstraint.constant = 0
            case .closed:
                self.bottomConstraint.constant = self.popupOffset - 65
            }
            
            self.runningAnimators.removeAll()
        }
        
        transitionAnimator.startAnimation()
        runningAnimators.append(transitionAnimator)
    }
    
    func settingViewAnimate(open: Bool) {
        if open {
            UIView.animate(withDuration: 0.3) {
                self.templeSettingView.alpha = 1
                self.editToolBarView.alpha = 0
            }
        } else {
            UIView.animate(withDuration: 0.3) {
                self.editToolBarView.alpha = 1
                self.templeSettingView.alpha = 0
            }
        }
    }
    
    func actionButtonStyle(isFollowed: Bool) {
        if isFollowed {
            UIView.animate(withDuration: 0.4) {
                self.actionButton.setTitle("Unfollow", for: .normal)
                self.actionButton.backgroundColor = .mainPurple
                self.actionButton.layer.borderWidth = 0
                self.actionButton.addTarget(self, action: #selector(self.handleUnfollowAction), for: .touchUpInside)
                self.isFollowed = false
            }
        } else {
            UIView.animate(withDuration: 0.4) {
                self.actionButton.setTitle("follow", for: .normal)
                self.actionButton.layer.borderColor = UIColor.white.cgColor
                self.actionButton.layer.borderWidth = 1.25
                self.actionButton.backgroundColor = .none
                self.actionButton.addTarget(self, action: #selector(self.handleFollowAction), for: .touchUpInside)
                self.isFollowed = true
            }
        }
    }
}

extension State {
    var opposite: State {
        switch self {
        case .open: return .closed
        case .closed: return .open
        }
    }
}

//MARK: - UserContentViewDelegate
extension UserProfileController: UserContentViewDelegate {
    func moveToAddExhibition() {
        guard let user = user else { return }
        let controller = AddExhibitionController(user: user)
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
    
    func moveToAddArtwork() {
        guard let user = user else { return }
        let controller = AddArtworkController(user: user)
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true, completion: nil)
    }
    
    func moveToExhibitionDetail(exhibition: ExhibitionDetail) {
        guard let user = user else { return }
        let controller = ExhibitionDetailController(user: user)
        controller.exhibition = exhibition
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
    
    func moveToArtworkDetail(artwork: ArtworkDetail) {
        guard let user = user else { return }
        let controller = ArtworkDetailController(user: user, artwork: artwork)
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
}

//MARK: - EditToolBarViewDelegate
extension UserProfileController: EditToolBarViewDelegate {
    func showTempleSettingView() {
        settingViewAnimate(open: true)
    }
}

//MARK: - TempleSettingViewDelegate
extension UserProfileController: TempleSettingViewDelegate {
    func handleDismissal() {
        settingViewAnimate(open: false)
    }
}

//MARK: - UserCoverViewDelegate
extension UserProfileController: UserCoverViewDelegate {
    func panGestureaction(label: UILabel) {
//       configurePanGesture(label: label)
    }
}
