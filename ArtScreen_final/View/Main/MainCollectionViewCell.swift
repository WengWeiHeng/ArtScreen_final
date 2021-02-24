//
//  MainCollectionViewCell.swift
//  ArtScreen_final
//
//  Created by Heng on 2020/11/1.
//

import UIKit
import SDWebImage

enum CellState {
    case expanded
    case collapsed
    
    var change: CellState {
        switch self {
        case .expanded: return .collapsed
        case .collapsed: return .expanded
        }
    }
}

protocol MainCollectionViewCellDelegate: class {
    func itemDismissal(isDismissal: Bool)
    func handleShowDetail(artwork: ArtworkDetail)
    func handleMoveUserProfile(user: User, completion: @escaping (() -> Void))
    func openARWorld(exhibition: ExhibitionDetail, completion: @escaping (() -> Void))
    func editExhibition(exhibition: ExhibitionDetail, completion: @escaping (() -> Void))
}

class MainCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Properties
    var user: User? {
        didSet {
            DispatchQueue.main.async {
                self.checkUserIs(user: self.user!)
            }
        }
    }
    
    var exhibition: ExhibitionDetail?
    var isFollowed = false
    var isLike = false
    
    private var exhibitionDetail: ExhibitionDetailController?
    private var artworkInputView = ArtworkInputView()
    
    private var rightConstraint = NSLayoutConstraint()
    private let artworkInputViewWidth: CGFloat = screenWidth
    
    static let cellSize = screenHeight * collectionViewCellHeightCoefficient
    
    private var initialFrame: CGRect?
    private var state: CellState = .collapsed
    
    private let popupOffset: CGFloat = (screenHeight - cellSize) / 2.0
    private var animationProgress: CGFloat = 0
    private var collectionView: UICollectionView?
    private var index: Int?
    
    weak var delegate: MainCollectionViewCellDelegate?
    
    private lazy var animator: UIViewPropertyAnimator = {
        let VPA = UIViewPropertyAnimator(duration: 0.3, curve: .easeInOut)
        
        return VPA
    }()
    
    private lazy var panRecognizer: UIPanGestureRecognizer = {
        let pan = UIPanGestureRecognizer()
        pan.addTarget(self, action: #selector(popupViewPanned(recognizer:)))
        pan.delegate = self

        return pan
    }()
    
    private lazy var tapRecognizer: UITapGestureRecognizer = {
        let tap = UITapGestureRecognizer()
        tap.addTarget(self, action: #selector(popupViewTapped(recognizer:)))
        return tap
    }()
    
    //MARK: - Exhibition Info Properties
    let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "close").withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .white
        button.setDimensions(width: 28, height: 28)
        button.alpha = 0

        return button
    }()
    
    let exhibitionImage: UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .mainDarkGray
        
        return iv
    }()
    
    private let arWorldButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "arCamera").withRenderingMode(.alwaysOriginal), for: .normal)
        button.setDimensions(width: 50, height: 50)
        button.imageView?.setDimensions(width: 20, height: 20)
        button.backgroundColor = .mainDarkGray
        
        return button
    }()
    
    private let likeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "like").withRenderingMode(.alwaysTemplate), for: .normal)
        button.setDimensions(width: 50, height: 50)
        button.imageView?.setDimensions(width: 18, height: 18)
        button.layer.maskedCorners = .layerMaxXMinYCorner
        button.layer.cornerRadius = 15
        
        return button
    }()
    
    private lazy var followerStack: UIStackView = {
        let stack = Utilities().customCountStackView(typeText: "Followers", countText: "6,962", textColor: .mainDarkGray)
        return stack
    }()
    
    private lazy var likesStack: UIStackView = {
        let stack = Utilities().customCountStackView(typeText: "Likes", countText: "25,104", textColor: .mainDarkGray)
        return stack
    }()
    
    private lazy var visitedStack: UIStackView = {
        let stack = Utilities().customCountStackView(typeText: "Visited", countText: "304,501", textColor: .mainDarkGray)
        return stack
    }()

    private let userImageView: UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.setDimensions(width: 36, height: 36)
        iv.layer.cornerRadius = 36 / 2
        iv.backgroundColor = .mainPurple
        iv.image = #imageLiteral(resourceName: "coverImage")
        
        return iv
    }()
    
    private let usernameButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = .boldSystemFont(ofSize: 16)
        button.setTitleColor(.mainPurple, for: .normal)
        
        return button
    }()
    
    private let actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        button.setDimensions(width: 92, height: 32)
        button.layer.cornerRadius = 32 / 2
        button.alpha = 0
        
        return button
    }()
    
    private let exhibitionTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 22)
        label.textColor = .mainPurple
        label.text = "Mauris hendrerit quam orci, sit amet posuere ante vestibulum sodales."
        label.numberOfLines = 3
        return label
    }()
    
    private let exhibitionIntroduction: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .mainPurple
        label.numberOfLines = 0
        label.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Mauris fermentum nulla sit amet elementum iaculis. Donec ac nisi dictum, hendrerit quam ut, consequat neque. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Donec hendrerit facilisis tortor nec pretium. "
        
        return label
    }()
    
    private lazy var introductionButton: UIButton = {
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
    
    private lazy var artworkButton: UIButton = {
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
    private lazy var actionButtonStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [arWorldButton, likeButton])
        stack.axis = .horizontal
        stack.spacing = 0
        stack.alignment = .center
        stack.alpha = 0
        
        return stack
    }()
    
    private lazy var socialDataStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [followerStack, likesStack, visitedStack])
        stack.axis = .horizontal
        stack.spacing = 12
        stack.alpha = 0
        
        return stack
    }()
    
    private lazy var userStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [userImageView, usernameButton])
        stack.axis = .horizontal
        stack.spacing = 10
        stack.alpha = 0
        
        return stack
    }()

    private lazy var exhibitionStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [exhibitionTitleLabel, exhibitionIntroduction])
        stack.axis = .vertical
        stack.spacing = 14
        stack.alpha = 0
        
        return stack
    }()
    
    private lazy var filterButtonStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [introductionButton, artworkButton])
        stack.axis = .horizontal
        stack.spacing = 16
        stack.alpha = 0
        
        return stack
    }()
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .mainBackground
        layer.cornerRadius = 24
        
        addSubview(exhibitionImage)
        exhibitionImage.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor)
        exhibitionImage.setHeight(height: screenHeight * 0.59)
        exhibitionImage.layer.cornerRadius = 24
        
        addSubview(actionButtonStack)
        actionButtonStack.anchor(top: exhibitionImage.bottomAnchor, left: leftAnchor, paddingTop: -25)
        
        addSubview(socialDataStack)
        socialDataStack.anchor(bottom: actionButtonStack.bottomAnchor, right: rightAnchor, paddingRight: 16)
        
        addSubview(userStack)
        userStack.anchor(top: actionButtonStack.bottomAnchor, left: leftAnchor, paddingTop: 30, paddingLeft: 16)
        
        addSubview(actionButton)
        actionButton.centerY(inView: userStack)
        actionButton.anchor(right: socialDataStack.rightAnchor)
        
        addSubview(exhibitionStack)
        exhibitionStack.anchor(top: userStack.bottomAnchor, left: userStack.leftAnchor, right: actionButton.rightAnchor, paddingTop: 16)

        addSubview(artworkInputView)
        artworkInputView.translatesAutoresizingMaskIntoConstraints = false
        artworkInputView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        artworkInputView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        rightConstraint = artworkInputView.rightAnchor.constraint(equalTo: rightAnchor, constant: artworkInputViewWidth)
        rightConstraint.isActive = true
        artworkInputView.widthAnchor.constraint(equalToConstant: artworkInputViewWidth).isActive = true
        artworkInputView.alpha = 0
        artworkInputView.delegate = self
        
        addSubview(filterButtonStack)
        filterButtonStack.anchor(bottom: safeAreaLayoutGuide.bottomAnchor)
        filterButtonStack.centerX(inView: self)
        
        addSubview(closeButton)
        closeButton.anchor(top: safeAreaLayoutGuide.topAnchor, right: rightAnchor, paddingTop: 16, paddingRight: 16)
        closeButton.addTarget(self, action: #selector(handleCloseCell), for: .touchUpInside)
        
        arWorldButton.addTarget(self, action: #selector(openARWorld), for: .touchUpInside)
        usernameButton.addTarget(self, action: #selector(handleShowUserProfile), for: .touchUpInside)
        likeButton.addTarget(self, action: #selector(handleLikeAction), for: .touchUpInside)
        
//        addGestureRecognizer(panRecognizer)
        addGestureRecognizer(tapRecognizer)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - API
    func checkUserIs(user: User) {
        let currentUser = UserDefaults.standard.value(forKey: "parseJSON") as? NSDictionary
        if user.username != currentUser!["username"] as! String {
            checkUserisFollowing(user: user)
        } else {
            actionButton.setTitle("Edit", for: .normal)
            actionButton.setTitleColor(.mainPurple, for: .normal)
            actionButton.layer.borderColor = UIColor.mainPurple.cgColor
            actionButton.layer.borderWidth = 1.25
            actionButton.backgroundColor = .none
            actionButton.addTarget(self, action: #selector(handleEditAction), for: .touchUpInside)
        }
    }
    
    func checkUserisFollowing(user: User) {
        UserService.shared.checkUserIsFollowing(user: user) { (isFollowed) in
            DispatchQueue.main.async {
                self.isFollowed = isFollowed
                self.actionButtonStyle(isFollowed: isFollowed)
                self.actionButton.addTarget(self, action: #selector(self.handleFollowAction), for: .touchUpInside)
            }
        }
    }
    
    func userFollowing() {
        guard let user = user else { return }
        UserService.shared.followingUser(user: user)
        actionButtonStyle(isFollowed: isFollowed)
    }
    
    func unfollowUser() {
        guard let user = user else { return }
        UserService.shared.unfollowUser(user: user)
        actionButtonStyle(isFollowed: isFollowed)
    }
    
    func checkIsUserLike(exhibition: ExhibitionDetail) {
        LikeService.shared.checkUserIsLike(withState: .exhibition, exhibition: exhibition) { (isLike) in
            DispatchQueue.main.async {
                self.isLike = isLike
                self.likeButtonStyle(isLike: isLike)
            }
        }
    }
    
    //MARK: - Selectors
    @objc func popupViewTapped(recognizer: UITapGestureRecognizer) {
        print("DEBUG: tapped..")
        
        switch state {
        case .collapsed:
            toggle()
        case .expanded:
            removeGestureRecognizer(tapRecognizer)
        }
    }
    
    @objc func popupViewPanned(recognizer: UIPanGestureRecognizer) {
        switch recognizer.state{
        case .began:
            toggle()
            animator.pauseAnimation()

            //手勢中斷動畫
            animationProgress = animator.fractionComplete
        case .changed:
            let translation = recognizer.translation(in: collectionView)
            var fraction = -translation.y / popupOffset
            if state == .expanded{ fraction *= 1}
            if animator.isReversed{ fraction *= -1 }
            animator.fractionComplete = fraction

            //手勢中斷動畫
            animator.fractionComplete = fraction + animationProgress

        case .ended:
            let velocity = recognizer.velocity(in: self)
            let shouldComplete = velocity.y > 0
            if velocity.y == 0{
                animator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
                break
            }

            switch state{
            case .expanded:
                if !shouldComplete && !animator.isReversed{ animator.isReversed = !animator.isReversed }
                if shouldComplete && animator.isReversed{ animator.isReversed = !animator.isReversed }
            case .collapsed:
                if shouldComplete && !animator.isReversed{ animator.isReversed = !animator.isReversed }
                if !shouldComplete && animator.isReversed{ animator.isReversed = !animator.isReversed }
            }
            animator.continueAnimation(withTimingParameters: nil, durationFactor: 0)

        default:
            ()
        }
    }
    
    @objc func handleCloseCell() {
        toggle()
    }
    
    @objc func infoButtonAction(_ sender: Any) {
        let transitionAnimator = UIViewPropertyAnimator(duration: 0.6, dampingRatio: 1) {
            self.rightConstraint.constant = self.artworkInputViewWidth
            self.introductionButton.backgroundColor = .mainPurple
            self.introductionButton.setTitleColor(.white, for: .normal)
            self.artworkButton.backgroundColor = .white
            self.artworkButton.setTitleColor(.mainDarkGray, for: .normal)
            
            self.layoutIfNeeded()
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
            
            self.layoutIfNeeded()
        }
        transitionAnimator.startAnimation()
    }
    
    @objc func handleShowUserProfile() {
        guard let user = user else { return }
        delegate?.handleMoveUserProfile(user: user, completion: {
            self.collectionView?.reloadData()
        })
    }
    
    @objc func openARWorld() {
        guard let exhibition = exhibition else { return }
        delegate?.openARWorld(exhibition: exhibition, completion: {
            self.collectionView?.reloadData()
        })
    }
    
    @objc func handleFollowAction() {
        print("DEBUG: handle follow action")
        isFollowed.toggle()
        if isFollowed {
            print("DEBUG: do following")
            userFollowing()
            
        } else {
            print("DEBUG: do unfollow")
            unfollowUser()
        }
    }
    
    @objc func handleEditAction() {
        guard let exhibition = exhibition else { return }
        delegate?.editExhibition(exhibition: exhibition, completion: {
            self.collectionView?.reloadData()
        })
    }
    
    @objc func handleLikeAction() {
        isLike.toggle()
        guard let exhibition = exhibition else { return }
        if isLike {
            LikeService.shared.fetchLikeExhibition(withExhibition: exhibition)
            likeButtonStyle(isLike: isLike)
        } else {
            LikeService.shared.unlike(withState: .exhibition, exhibition: exhibition)
            likeButtonStyle(isLike: isLike)
        }
    }
    
    //MARK: - Helpers
    func configureData(with exhibition: ExhibitionDetail, collectionView: UICollectionView, index: Int) {
        exhibitionImage.sd_setImage(with: URL(string: exhibition.path))
        exhibitionTitleLabel.text = exhibition.exhibitionName
        exhibitionIntroduction.text = exhibition.information
        
        artworkInputView.exhibitionTitleLabel.text = exhibition.exhibitionName
        artworkInputView.exhibitionID = exhibition.exhibitionID
        
        UserService.shared.fetchUserOfExhibition(withExhibition: exhibition) { user in
            self.user = user
            
            DispatchQueue.main.async {
                self.userImageView.sd_setImage(with: user.ava)
                self.usernameButton.setTitle(user.username, for: .normal)
            }
        }

        self.collectionView = collectionView
        self.index = index
    }
    
    func toggle(){
        switch state{
        case .expanded:
            collapse()
        case .collapsed:
            expand()
        }
    }
    
    func collapse(){
        guard let collectionView = self.collectionView, let index = self.index else { return }
        animator.addAnimations {
            self.delegate?.itemDismissal(isDismissal: false)
            self.exhibitionImage.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner]
            self.exhibitionImage.layer.cornerRadius = 24
            self.exhibitionImage.setHeight(height: 500)
            self.closeButton.alpha = 0
            self.actionButtonStack.alpha = 0
            self.socialDataStack.alpha = 0
            self.userStack.alpha = 0
            self.actionButton.alpha = 0
            self.exhibitionStack.alpha = 0
            self.filterButtonStack.alpha = 0
            self.artworkInputView.alpha = 0
            
            self.frame = self.initialFrame!
            
            if let leftCell = collectionView.cellForItem(at: IndexPath(row: index - 1, section: 0)){
                leftCell.center.x += 50
            }
            
            if let rightCell = collectionView.cellForItem(at: IndexPath(row: index + 1, section: 0)){
                rightCell.center.x -= 50
            }
            
            self.layoutIfNeeded()
        }
        
        animator.addCompletion { (position) in
            switch position{
                case .end:
                self.state = self.state.change
                collectionView.isScrollEnabled = true
                collectionView.allowsSelection = true
            default:
                ()
            }
        }
        animator.startAnimation()
    }
    
    func expand(){
        guard let collectionView = self.collectionView, let index = self.index else{ return }
        
        animator.addAnimations {
            self.initialFrame = self.frame
            self.delegate?.itemDismissal(isDismissal: true)
            self.exhibitionImage.layer.maskedCorners = .layerMaxXMaxYCorner
            self.exhibitionImage.layer.cornerRadius = 60
            self.exhibitionImage.setHeight(height: screenHeight * 0.65)
            self.closeButton.alpha = 1
            self.actionButtonStack.alpha = 1
            self.socialDataStack.alpha = 1
            self.userStack.alpha = 1
            self.actionButton.alpha = 1
            self.exhibitionStack.alpha = 1
            self.filterButtonStack.alpha = 1
            self.artworkInputView.alpha = 1
            
            self.frame = CGRect(x: collectionView.contentOffset.x, y: 0, width: collectionView.frame.width, height: collectionView.frame.height)
            
            if let leftCell = collectionView.cellForItem(at: IndexPath(row: index - 1, section: 0)){
                leftCell.center.x -= 50
            }
            
            if let rightCell = collectionView.cellForItem(at: IndexPath(row: index + 1, section: 0)){
                rightCell.center.x += 50
            }
            
            self.layoutIfNeeded()
        }
        animator.addCompletion { (position) in
            switch position{
            case .end:
                self.state = self.state.change
                collectionView.isScrollEnabled = false
                collectionView.allowsSelection = false
            default:
                ()
            }
        }
        animator.startAnimation()
    }
    
    func actionButtonStyle(isFollowed: Bool) {
        if isFollowed {
            UIView.animate(withDuration: 0.4) {
                self.actionButton.setTitle("Following", for: .normal)
                self.actionButton.backgroundColor = .mainPurple
                self.actionButton.setTitleColor(.white, for: .normal)
                self.actionButton.layer.borderWidth = 0
            }
        } else {
            UIView.animate(withDuration: 0.4) {
                self.actionButton.setTitle("Follow", for: .normal)
                self.actionButton.layer.borderColor = UIColor.mainPurple.cgColor
                self.actionButton.setTitleColor(.mainPurple, for: .normal)
                self.actionButton.layer.borderWidth = 1.25
                self.actionButton.backgroundColor = .none
            }
        }
    }
    
    func likeButtonStyle(isLike: Bool) {
        if isLike {
            UIView.animate(withDuration: 0.4) {
                self.likeButton.backgroundColor = .mainBackground
                self.likeButton.tintColor = .mainPurple
            }
        } else {
            UIView.animate(withDuration: 0.4) {
                self.likeButton.backgroundColor = .mainPurple
                self.likeButton.tintColor = .white
            }
        }
    }
    
    func callBack(exhibition: ExhibitionDetail) {
        DispatchQueue.main.async {
            self.exhibitionTitleLabel.text = exhibition.exhibitionName
            SDImageCache.shared.clearMemory()
            SDImageCache.shared.clearDisk {
                self.exhibitionImage.sd_setImage(with: URL(string: exhibition.path))
            }
            self.exhibitionIntroduction.text = exhibition.information
        }
    }
}

//MARK: - UIGestureRecognizerDelegate
extension MainCollectionViewCell: UIGestureRecognizerDelegate {
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return abs((panRecognizer.velocity(in: panRecognizer.view)).y) > abs((panRecognizer.velocity(in: panRecognizer.view)).x)
    }
}

//MARK: - ArtworkInputViewdelegate
extension MainCollectionViewCell: ArtworkInputViewDelegate {
    func showArtworkDetail(artwork: ArtworkDetail) {
        delegate?.handleShowDetail(artwork: artwork)
    }
}
