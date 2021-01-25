//
//  UserContentView.swift
//  ArtScreen_final
//
//  Created by Heng on 2020/10/23.
//

import UIKit
import WaterfallLayout

private let exhibitionIdentifier = "ExhibitionCell"
private let artworkIdentifier = "ArtworkCell"

private enum ActionOption{
    case addExhibition
    case addArtwork
}

protocol UserContentViewDelegate: class {
    func moveToAddExhibition()
    func moveToAddArtwork()
    func moveToExhibitionDetail(exhibition: ExhibitionDetail)
    func moveToArtworkDetail(artwork: ArtworkDetail)
}

class UserContentView: UIView {
    
    //MARK: - Properties
    weak var delegate: UserContentViewDelegate?
    var user: User? {
        didSet {
            configureUserData()
            userExhibitionView.user = user
            userArtworkView.user = user
        }
    }
    
    private var screenOffset: CGFloat = UIScreen.main.bounds.width
    private var rightConstraint = NSLayoutConstraint()
    private var option: ActionOption = .addExhibition
    
    private let userInfoView = UserInfoView()
    private let filterBar = FilterView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), state: .inUserView)
    
    private let userExhibitionView = UserExhibitionView()
    private let userArtworkView = UserArtworkView()
    
    private let editButton: UIButton = {
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
    
    lazy var profileInfoView: UIView = {
        let view = UIView()
        view.backgroundColor = .mainAlphaGray
        
        view.addSubview(profileImageView)
        profileImageView.anchor(top: view.topAnchor, left: view.leftAnchor, paddingTop: 60, paddingLeft: 12, width: 50, height: 50)
        profileImageView.layer.cornerRadius = 50 / 2
        
        let stack = UIStackView(arrangedSubviews: [fullnameLabel, usernameLabel])
        stack.distribution = .fillEqually
        stack.spacing = 4
        stack.axis = .vertical
        
        view.addSubview(stack)
        stack.centerY(inView: profileImageView, leftAnchor: profileImageView.rightAnchor, paddingLeft: 12)
        
        view.addSubview(bioLabel)
        bioLabel.anchor(top: profileImageView.bottomAnchor, left: view.leftAnchor, paddingTop: 16, paddingLeft: 12, width: 150)
        
        view.addSubview(editButton)
        editButton.anchor(bottom: bioLabel.bottomAnchor, right: view.rightAnchor, paddingRight: 12)
        
        view.addSubview(userInfoView)
        userInfoView.anchor(left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
        
        return view
    }()
    
    private let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .white
        iv.setDimensions(width: 52, height: 52)
        
        return iv
    }()
    
    private let fullnameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .white
        label.text = "翁 偉恆"
        
        return label
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .white
        label.text = "@Heng_Weng"
        
        return label
    }()
    
    private let bioLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .white
        label.numberOfLines = 0
        label.text = "#Graphic Designer #Calligraphy #Programer #iOS #Swift"
        
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 26)
        label.textColor = .white
        label.text = "Exhibition"
        
        return label
    }()
    
    private let addButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "add").withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .white
        button.setDimensions(width: 24, height: 24)
        button.addTarget(self, action: #selector(handleAddAction), for: .touchUpInside)
        
        return button
    }()
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Selectors
    @objc func handleDismissMenu() {
        //dismiss(animated: true, completion: nil)
        print("DEBUG: dismissal..")
    }
    
    @objc func handleEditAction() {
        print("DEBUG: Profile Cover is Editting..")
    }
    
    @objc func handleAddAction() {
        switch option {
        case .addExhibition:
            delegate?.moveToAddExhibition()
        case .addArtwork:
            delegate?.moveToAddArtwork()
        }
    }
    
    //MARK: - Helpers
    func configureUserData() {
        guard let user = user else { return }
        fullnameLabel.text = user.fullname
        usernameLabel.text = user.username
        profileImageView.sd_setImage(with: user.ava)
    }
    
    func configureUI() {
        backgroundColor = .mainDarkGray
        
        addSubview(profileInfoView)
        profileInfoView.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, height: 280)
        profileInfoView.alpha = 0
        
        let stack = UIStackView(arrangedSubviews: [titleLabel, addButton])
        stack.axis = .horizontal
        
        addSubview(stack)
        stack.anchor(top: profileInfoView.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 20, paddingLeft: 12, paddingRight: 12)
        
        addSubview(userExhibitionView)
        userExhibitionView.anchor(top: stack.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, paddingTop: 20, width: screenOffset)
        userExhibitionView.delegate = self
        
        addSubview(userArtworkView)
        userArtworkView.translatesAutoresizingMaskIntoConstraints = false
        userArtworkView.topAnchor.constraint(equalTo: userExhibitionView.topAnchor).isActive = true
        userArtworkView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        rightConstraint = userArtworkView.rightAnchor.constraint(equalTo: rightAnchor, constant: screenOffset)
        rightConstraint.isActive = true
        userArtworkView.widthAnchor.constraint(equalToConstant: screenOffset).isActive = true
        userArtworkView.delegate = self

        addSubview(filterBar)
        filterBar.centerX(inView: self)
        filterBar.anchor(bottom: safeAreaLayoutGuide.bottomAnchor, paddingBottom: 0, width: 230, height: 40)
        filterBar.delegate = self
    }
}

extension UserContentView: FilterViewDelegate {
    func moveToArtwork() {
        let transitionAnimator = UIViewPropertyAnimator(duration: 0.6, dampingRatio: 1) {
            self.rightConstraint.constant = 0
            self.titleLabel.text = "Artwork"
            self.layoutIfNeeded()
        }
        transitionAnimator.startAnimation()
        
        self.option = .addArtwork
    }
    
    func moveToExhibition() {
        let transitionAnimator = UIViewPropertyAnimator(duration: 0.6, dampingRatio: 1) {
            self.rightConstraint.constant = self.screenOffset
            self.titleLabel.text = "Exhibition"
            self.layoutIfNeeded()
        }
        transitionAnimator.startAnimation()
        
        self.option = .addExhibition
    }
}

//MARK: - UserExhibitionViewDelegate
extension UserContentView: UserExhibitionViewDelegate {
    func handlePushToDetailPage(exhibition: ExhibitionDetail) {
        delegate?.moveToExhibitionDetail(exhibition: exhibition)
    }
}

extension UserContentView: UserArtworkViewDelegate {
    func handlePushToDetailPage(artwork: ArtworkDetail) {
        delegate?.moveToArtworkDetail(artwork: artwork)
    }
}
