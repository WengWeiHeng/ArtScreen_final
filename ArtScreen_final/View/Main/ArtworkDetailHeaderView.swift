//
//  ArtworkDetailHeaderView.swift
//  ArtScreen_final
//
//  Created by Heng on 2020/11/12.
//

import UIKit

protocol ArtworkDetailHeaderViewDelegate: class {
    func handleArtworkLike(button: UIButton)
    func editArtwork()
}

class ArtworkDetailHeaderView: UIView {
    
    //MARK: - Proporties
    weak var delegate: ArtworkDetailHeaderViewDelegate?
    
    var artworkImageView: UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .mainBackground
        
        return iv
    }()
    
    lazy var actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "setting").withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .mainDarkGray
        button.setDimensions(width: 50, height: 50)
        button.imageView?.setDimensions(width: 18, height: 18)
        button.backgroundColor = .mainBackground
        button.isUserInteractionEnabled = true
        button.addTarget(self, action: #selector(handleEditArtwork), for: .touchUpInside)
        
        return button
    }()
    
    lazy var likeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "like").withRenderingMode(.alwaysTemplate), for: .normal)
        button.setDimensions(width: 50, height: 50)
        button.imageView?.setDimensions(width: 18, height: 18)
        button.tintColor = .white
        button.backgroundColor = .mainPurple
        button.layer.maskedCorners = .layerMaxXMinYCorner
        button.layer.cornerRadius = 15
        button.addTarget(self, action: #selector(handleArtworkLike), for: .touchUpInside)
        button.isUserInteractionEnabled = true
        
        return button
    }()
    
    private lazy var followerStack: UIStackView = {
        let stack = Utilities().customCountStackView(typeText: "Followers", countText: "6,962", textColor: .mainBackground)
        return stack
    }()
    
    private let likesStack: UIStackView = {
        let stack = Utilities().customCountStackView(typeText: "Likes", countText: "25,104", textColor: .mainBackground)
        return stack
    }()
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(artworkImageView)
        artworkImageView.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, height: 450)
        
        let actionStack = UIStackView(arrangedSubviews: [actionButton, likeButton])
        actionStack.axis = .horizontal
        actionStack.spacing = 0
        
        addSubview(actionStack)
        actionStack.anchor(top: artworkImageView.bottomAnchor, left: leftAnchor, paddingTop: -25)
        
        let socialStack = UIStackView(arrangedSubviews: [followerStack, likesStack])
        socialStack.spacing = 16
        
        addSubview(socialStack)
        socialStack.anchor(bottom: actionStack.bottomAnchor, right: rightAnchor, paddingRight: 12)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Selectors
    @objc func handleArtworkLike() {
        delegate?.handleArtworkLike(button: likeButton)
    }
    
    @objc func handleEditArtwork() {
        delegate?.editArtwork()
    }
}
