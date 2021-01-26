//
//  UserInfoView.swift
//  ArtScreen_final
//
//  Created by Heng on 2020/10/23.
//

import UIKit

class UserInfoView: UICollectionReusableView {
    
    //MARK: - Properties
    var exhibitionCount: Int = 0 {
        didSet {
            exhibitionCountLabel.text = String(exhibitionCount)
        }
    }
    var artworkCount: Int = 0 {
        didSet {
            artworkCountLabel.text = String(artworkCount)
        }
    }
    
    var followerCount: Int = 0 {
        didSet {
            followCountLabel.text = String(followerCount)
        }
    }
    
    private let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "close").withRenderingMode(.alwaysOriginal), for: .normal)
        button.setDimensions(width: 24, height: 24)
        button.addTarget(self, action: #selector(handleDismissMenu), for: .touchUpInside)
        button.alpha = 0
        
        return button
    }()
    
    private let followCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .white
        label.text = "25.602"
        
        return label
    }()
    
    let exhibitionCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .white
//        label.text = "162"
        
        return label
    }()

    let artworkCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .white
//        label.text = "203,301"
        
        return label
    }()
    
    private let followerLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.textColor = .white
        label.text = "Followers"
        
        return label
    }()
    
    private let exhibitionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.textColor = .white
        label.text = "Exhibitions"
        
        return label
    }()
    
    private let artworkLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.textColor = .white
        label.text = "Artworks"
        
        return label
    }()

    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .mainAlphaGray
        
        addSubview(closeButton)
        closeButton.anchor(top: safeAreaLayoutGuide.topAnchor, right: rightAnchor, paddingTop: 12, paddingRight: 12)
        
        let followerStack = UIStackView(arrangedSubviews: [followCountLabel, followerLabel])
        followerStack.axis = .vertical
        followerStack.spacing = 4
        followerStack.alignment = .center
        
        let artworkStack = UIStackView(arrangedSubviews: [exhibitionCountLabel, exhibitionLabel])
        artworkStack.axis = .vertical
        artworkStack.spacing = 4
        artworkStack.alignment = .center
        
        let visitedStack = UIStackView(arrangedSubviews: [artworkCountLabel, artworkLabel])
        visitedStack.axis = .vertical
        visitedStack.spacing = 4
        visitedStack.alignment = .center
        
        let stack = UIStackView(arrangedSubviews: [followerStack, artworkStack, visitedStack])
        stack.spacing = 70
        
        addSubview(stack)
        stack.centerX(inView: self)
        stack.anchor(top: topAnchor, bottom: bottomAnchor, paddingTop: 24, paddingBottom: 24)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Selectors
    @objc func handleDismissMenu() {
        print("DEBUG: Dismissal..")
    }
    
    @objc func handleEditAction() {
        print("DEBUG: Profile Cover is Editting..")
    }
}


