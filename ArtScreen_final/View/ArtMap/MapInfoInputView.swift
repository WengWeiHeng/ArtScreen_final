//
//  MapInfoInputView.swift
//  ArtScreen_final
//
//  Created by Heng on 2020/10/26.
//

import UIKit

class MapInfoInputView: UIView {
    
    //MARK: - Properties
    var artwork: ArtworkDetail?
    
    private let userImageView: UIImageView = {
        let image = UIImageView()
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        image.setDimensions(width: 40, height: 40)
        image.backgroundColor = .mainDarkGray
        image.layer.cornerRadius = 40 / 2
        
        return image
    }()
    
    private let fullnameLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        label.textColor = .mainPurple
        label.text = "Heng_Weng"
        
        return label
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .mainPurple
        label.text = "@heng_9940"
        
        return label
    }()
    
    private let followButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Follow", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 16)
        button.setDimensions(width: 60, height: 20)
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.mainPurple.cgColor
        button.layer.cornerRadius = 20 / 2
        
        return button
    }()
    
    private let artworkImageVew: UIImageView = {
        let image = UIImageView()
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        image.setDimensions(width: 200, height: 200)
        image.backgroundColor = .mainDarkGray
        image.layer.cornerRadius = 24
        
        return image
    }()
    
    private let artworkTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 20)
        label.textColor = .mainPurple
        label.text = "Commemorating the 70th Anniversary of his death Yoshida Hiroshi-Longing for Nature"
        label.numberOfLines = 3
        
        return label
    }()
    
    private let readMoreButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Read More", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 16)
        button.backgroundColor = .mainPurple
        button.setTitleColor(.white, for: .normal)
        button.setDimensions(width: 120, height: 36)
        button.layer.cornerRadius = 36 / 2
        
        return button
    }()
    
    private let topBarLine: UIView = {
        let view = UIView()
        view.backgroundColor = .mainPurple
        view.setDimensions(width: 36, height: 7)
        view.layer.cornerRadius = 7 / 2
        
        return view
    }()
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
    func configureUI() {
        backgroundColor = .mainBackground
        layer.cornerRadius = 36
        addShadow()
        
        addSubview(topBarLine)
        topBarLine.anchor(top: topAnchor, paddingTop: 16)
        topBarLine.centerX(inView: self)
        
        addSubview(artworkImageVew)
        artworkImageVew.anchor(right: rightAnchor, paddingRight: 16)
        artworkImageVew.centerY(inView: self)
        
        let userInfoStack = UIStackView(arrangedSubviews: [fullnameLabel, usernameLabel])
        userInfoStack.spacing = 4
        userInfoStack.axis = .vertical
        
        let userStack = UIStackView(arrangedSubviews: [userImageView, userInfoStack])
        userStack.axis = .horizontal
        userStack.spacing = 12
        
        addSubview(userStack)
        userStack.anchor(top: artworkImageVew.topAnchor, left: leftAnchor, right: artworkImageVew.leftAnchor, paddingLeft: 16, paddingRight: 16)
        
        addSubview(artworkTitleLabel)
        artworkTitleLabel.anchor(top: userStack.bottomAnchor, left: userStack.leftAnchor, right: userStack.rightAnchor, paddingTop: 14)
        
        addSubview(readMoreButton)
        readMoreButton.anchor(left: userStack.leftAnchor, bottom: artworkImageVew.bottomAnchor)
    }
}
