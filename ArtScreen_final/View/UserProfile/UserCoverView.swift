//
//  UserCoverView.swift
//  ArtScreen_final
//
//  Created by Heng on 2020/10/23.
//

import UIKit

protocol UserCoverViewDelegate: class {
    func panGestureaction(label: UILabel)
}

class UserCoverView: UIView {
    
    //MARK: - Properties
    weak var delegate: UserCoverViewDelegate?
    var user: User? {
        didSet {
            configureUserData()
        }
    }
    
    private let coverImageView: UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.image = #imageLiteral(resourceName: "coverImage")
    
        return iv
    }()
    
    private let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .white
        
        return iv
    }()
    
    private let fullnameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "翁 偉恆"
        
        return label
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "@Heng_Weng"
        
        return label
    }()
    
    private lazy var bioLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.numberOfLines = 0
        label.text = "#Graphic Designer #Calligraphy #Programer #iOS #Swift"
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(panGestureAction(sender:)))
        label.addGestureRecognizer(pan)
        
        return label
    }()
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        coverStyle1()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func panGestureAction(sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: bioLabel)
        bioLabel.center = CGPoint(x: bioLabel.center.x + translation.x, y: bioLabel.center.y + translation.y)
        sender.setTranslation(CGPoint.zero, in: bioLabel)
    }
    
    //MARK: - Helpers
    func configureUserData() {
        guard let user = user else { return }
        fullnameLabel.text = user.fullname
        usernameLabel.text = user.username
        profileImageView.sd_setImage(with: user.ava)
    }
    
    func coverStyle1() {
        addSubview(coverImageView)
        coverImageView.addConstraintsToFillView(self)
        
        addSubview(bioLabel)
        bioLabel.anchor(left: leftAnchor, bottom: bottomAnchor, paddingLeft: 12, paddingBottom: 16, width: 150)
        bioLabel.font = UIFont.systemFont(ofSize: 14)
        
        addSubview(profileImageView)
        profileImageView.anchor(left: leftAnchor, bottom: bioLabel.topAnchor, paddingLeft: 12, paddingBottom: 16, width: 50, height: 50)
        profileImageView.layer.cornerRadius = 50 / 2
        profileImageView.setDimensions(width: 52, height: 52)
        
        fullnameLabel.font = UIFont.boldSystemFont(ofSize: 20)
        usernameLabel.font = UIFont.systemFont(ofSize: 14)
        let stack = UIStackView(arrangedSubviews: [fullnameLabel, usernameLabel])
        stack.distribution = .fillEqually
        stack.spacing = 4
        stack.axis = .vertical
        
        addSubview(stack)
        stack.centerY(inView: profileImageView, leftAnchor: profileImageView.rightAnchor, paddingLeft: 12)
        
//        delegate?.panGestureaction(label: bioLabel)
//        delegate?.panGestureaction(label: fullnameLabel)
//        delegate?.panGestureaction(label: usernameLabel)
    }
}

