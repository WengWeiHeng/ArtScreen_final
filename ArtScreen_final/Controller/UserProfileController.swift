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
    let userCoverView = UserCoverView()
    let userContentView = UserContentView()
    let editToolBarView = EditToolBarView()
    
    private let popupOffset: CGFloat = UIScreen.main.bounds.height
    private var bottomConstraint = NSLayoutConstraint()
    
    private var currentState: State = .closed
    private var runningAnimators = [UIViewPropertyAnimator]()
    private var animationProgress = [CGFloat]()
    private var isEditting = false
    
    private let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "close").withRenderingMode(.alwaysOriginal), for: .normal)
        button.setDimensions(width: 24, height: 24)
        button.addTarget(self, action: #selector(handleDismissMenu), for: .touchUpInside)
        
        return button
    }()
    
    private let actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Edit", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1.25
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.addTarget(self, action: #selector(handleEditAction), for: .touchUpInside)
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
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barStyle = .black
    }
    
    //MARK: - Selectors
    @objc func handleDismissMenu() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleEditAction() {
        print("DEBUG: Edit Profile OR Follow me")
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
    
    //MARK: - Helpers
    func configureUI() {
        view.backgroundColor = .mainDarkGray
        
        view.addSubview(userCoverView)
        userCoverView.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, height: view.frame.height - 160)
        
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
        
        view.addSubview(editToolBarView)
        editToolBarView.anchor(left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, height: 160)
        editToolBarView.alpha = 0
        
        view.addSubview(closeButton)
        closeButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, right: view.rightAnchor, paddingTop: 12, paddingRight: 12)
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
}

extension State {
    var opposite: State {
        switch self {
        case .open: return .closed
        case .closed: return .open
        }
    }
}

extension UserProfileController: UserContentViewDelegate {
    func moveToAddExhibition() {
        let controller = AddExhibitionController()
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
    
    func moveToAddArtwork() {
        let controller = AddArtworkController()
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true, completion: nil)
    }
}

