//
//  ExhibitionDetailController.swift
//  ArtScreen_final
//
//  Created by Heng on 2020/12/10.
//

import UIKit

class ExhibitionDetailController: UIViewController {
    
    //MARK: - Properties
    var user: User?
    var exhibition: ExhibitionDetail?
    
    private var artworkInputView = ArtworkInputView()
    private var rightConstraint = NSLayoutConstraint()
    private let artworkInputViewWidth: CGFloat = screenWidth
    
    let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "close").withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .white
        button.setDimensions(width: 28, height: 28)

        return button
    }()
    
    let exhibitionImage: UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .mainDarkGray
        
        return iv
    }()
    
    let shareButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "share").withRenderingMode(.alwaysOriginal), for: .normal)
        button.setDimensions(width: 50, height: 50)
        button.imageView?.setDimensions(width: 18, height: 18)
        button.backgroundColor = .mainDarkGray
        
        return button
    }()
    
    let likeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "like").withRenderingMode(.alwaysOriginal), for: .normal)
        button.setDimensions(width: 50, height: 50)
        button.imageView?.setDimensions(width: 18, height: 18)
        button.backgroundColor = .mainPurple
        button.layer.maskedCorners = .layerMaxXMinYCorner
        button.layer.cornerRadius = 15
        
        return button
    }()
    
    lazy var followerStack: UIStackView = {
        let stack = Utilities().customCountStackView(typeText: "Followers", countText: "6,962", textColor: .mainDarkGray)
        return stack
    }()
    
    lazy var likesStack: UIStackView = {
        let stack = Utilities().customCountStackView(typeText: "Likes", countText: "25,104", textColor: .mainDarkGray)
        return stack
    }()
    
    lazy var visitedStack: UIStackView = {
        let stack = Utilities().customCountStackView(typeText: "Visited", countText: "304,501", textColor: .mainDarkGray)
        return stack
    }()

    let userImageView: UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.setDimensions(width: 28, height: 28)
        iv.layer.cornerRadius = 28 / 2
        iv.backgroundColor = .mainPurple
        iv.image = #imageLiteral(resourceName: "coverImage")
        
        return iv
    }()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 14)
        label.textColor = .mainPurple
        label.text = "Jack Mauris"
        
        return label
    }()
    
    let actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Edit", for: .normal)
        button.setTitleColor(.mainPurple, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.mainPurple.cgColor
        button.setDimensions(width: 80, height: 28)
        button.layer.cornerRadius = 28 / 2
        button.addTarget(self, action: #selector(handleEditAction), for: .touchUpInside)
        
        return button
    }()
    
    let exhibitionTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 22)
        label.textColor = .mainPurple
        label.text = "Mauris hendrerit quam orci, sit amet posuere ante vestibulum sodales."
        label.numberOfLines = 3
        return label
    }()
    
    let exhibitionIntroduction: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .mainPurple
        label.numberOfLines = 0
        label.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Mauris fermentum nulla sit amet elementum iaculis. Donec ac nisi dictum, hendrerit quam ut, consequat neque. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Donec hendrerit facilisis tortor nec pretium. "
        
        return label
    }()
    
    lazy var introductionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Introduction", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.backgroundColor = .mainPurple
        button.setDimensions(width: 100, height: 40)
        button.layer.cornerRadius = 40 / 2
        button.addTarget(self, action: #selector(infoButtonAction(_:)), for: .touchUpInside)
        
        return button
    }()
    
    lazy var artworkButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Artwork", for: .normal)
        button.setTitleColor(.mainDarkGray, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.backgroundColor = .white
        button.setDimensions(width: 100, height: 40)
        button.layer.cornerRadius = 40 / 2
        button.addTarget(self, action: #selector(artworkButtonAction(_:)), for: .touchUpInside)
        
        return button
    }()

    // StackView
    lazy var actionButtonStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [shareButton, likeButton])
        stack.axis = .horizontal
        stack.spacing = 0
        stack.alignment = .center
        
        return stack
    }()
    
    lazy var socialDataStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [followerStack, likesStack, visitedStack])
        stack.axis = .horizontal
        stack.spacing = 12
        
        return stack
    }()
    
    lazy var userStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [userImageView, usernameLabel])
        stack.axis = .horizontal
        stack.spacing = 10
        
        return stack
    }()

    lazy var exhibitionStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [exhibitionTitleLabel, exhibitionIntroduction])
        stack.axis = .vertical
        stack.spacing = 14
        
        return stack
    }()
    
    lazy var filterButtonStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [introductionButton, artworkButton])
        stack.axis = .horizontal
        stack.spacing = 16
        
        return stack
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
        
        configureUI()
        configureData()
        hideNavigationBar(selector: #selector(handleDismissal))
    }
    
    //MARK: - Selectors
    @objc func infoButtonAction(_ sender: Any) {
        let transitionAnimator = UIViewPropertyAnimator(duration: 0.6, dampingRatio: 1) {
            self.rightConstraint.constant = self.artworkInputViewWidth
            self.introductionButton.backgroundColor = .mainPurple
            self.introductionButton.setTitleColor(.white, for: .normal)
            self.artworkButton.backgroundColor = .white
            self.artworkButton.setTitleColor(.mainDarkGray, for: .normal)
            
            self.view.layoutIfNeeded()
        }
        transitionAnimator.startAnimation()
    }
    
    @objc func artworkButtonAction(_ sender: Any) {
        let transitionAnimator = UIViewPropertyAnimator(duration: 0.6, dampingRatio: 1) {
            self.rightConstraint.constant = 0
            self.artworkButton.backgroundColor = .mainPurple
            self.artworkButton.setTitleColor(.white, for: .normal)
            self.introductionButton.backgroundColor = .white
            self.introductionButton.setTitleColor(.mainDarkGray, for: .normal)
            
            self.view.layoutIfNeeded()
        }
        transitionAnimator.startAnimation()
    }
    
    @objc func handleFollow() {
        print("DEBUG: Handle Follow..")
    }
    
    @objc func handleDismissal() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleEditAction() {
        guard let user = user else { return }
        guard let exhibition = exhibition else { return }
        let controller = ExhibitionUploadController(user: user)
        controller.exhibitionID = exhibition.exhibitionID
        controller.exhibitionTitleText = exhibition.exhibitionName
        
        
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true, completion: nil)
    }
    
    //MARK: - Helpers
    func configureData() {
        guard let exhibition = exhibition else { return }
        exhibitionImage.sd_setImage(with: exhibition.path)
        exhibitionTitleLabel.text = exhibition.exhibitionName
        exhibitionIntroduction.text = exhibition.information
        
        UserService.shared.fetchUserOfExhibition(withExhibition: exhibition) { user in
            self.user = user
            
            DispatchQueue.main.async {
                self.userImageView.sd_setImage(with: user.ava)
                self.usernameLabel.text = user.username
            }
        }
        artworkInputView.exhibitionID = exhibition.exhibitionID
    }
    
    func configureUI() {
        view.backgroundColor = .mainBackground
        
        view.addSubview(exhibitionImage)
        exhibitionImage.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor)
        exhibitionImage.setHeight(height: 500)
        exhibitionImage.layer.cornerRadius = 24
        
        view.addSubview(actionButtonStack)
        actionButtonStack.anchor(top: exhibitionImage.bottomAnchor, left: view.leftAnchor, paddingTop: -25)
        
        view.addSubview(socialDataStack)
        socialDataStack.anchor(bottom: actionButtonStack.bottomAnchor, right: view.rightAnchor, paddingRight: 16)
        
        view.addSubview(userStack)
        userStack.anchor(top: actionButtonStack.bottomAnchor, left: view.leftAnchor, paddingTop: 30, paddingLeft: 16)
        
        view.addSubview(actionButton)
        actionButton.centerY(inView: userStack)
        actionButton.anchor(right: socialDataStack.rightAnchor)
        
        view.addSubview(exhibitionStack)
        exhibitionStack.anchor(top: userStack.bottomAnchor, left: userStack.leftAnchor, right: actionButton.rightAnchor, paddingTop: 16)

        view.addSubview(artworkInputView)
        artworkInputView.translatesAutoresizingMaskIntoConstraints = false
        artworkInputView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        artworkInputView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        rightConstraint = artworkInputView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: artworkInputViewWidth)
        rightConstraint.isActive = true
        artworkInputView.widthAnchor.constraint(equalToConstant: artworkInputViewWidth).isActive = true
        artworkInputView.delegate = self
        
        view.addSubview(filterButtonStack)
        filterButtonStack.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor)
        filterButtonStack.centerX(inView: view)
    }
}

//MARK: - ArtworkInputViewDelegate
extension ExhibitionDetailController: ArtworkInputViewDelegate {
    func showArtworkDetail(artwork: ArtworkDetail) {
        let controller = ArtworkDetailController()
        controller.artwork = artwork
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
        
    }
}