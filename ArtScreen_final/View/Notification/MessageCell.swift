//
//  MessageCell.swift
//  ArtScreen_final
//
//  Created by Heng on 2020/11/17.
//

import UIKit

class MessageCell: UITableViewCell {
    //MARK: - Properties
    private let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .mainPurple
        iv.setDimensions(width: 32, height: 32)
        iv.layer.cornerRadius = 32 / 2
        
        return iv
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 14)
        label.textColor = .mainPurple
        label.text = "Heng_Weng0034"
        
        return label
    }()
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 14)
        label.textColor = .mainPurple
        label.text = "Mauris hendrerit quam orci, sit amet posuere ante vestibulum sodales."
        label.numberOfLines = 1
        
        return label
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .mainAlphaGray
        label.text = "3s"
        
        return label
    }()
    
    //MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        backgroundColor = .mainBackground
        
        addSubview(profileImageView)
        profileImageView.anchor(left: leftAnchor, paddingLeft: 16)
        profileImageView.centerY(inView: self)
        
        addSubview(timeLabel)
        timeLabel.anchor(right: rightAnchor, paddingRight: 16)
        timeLabel.centerY(inView: profileImageView)
        
        let stack = UIStackView(arrangedSubviews: [usernameLabel, messageLabel])
        stack.axis = .vertical
        stack.spacing = 4
         
        addSubview(stack)
        stack.anchor(left: profileImageView.rightAnchor, right: timeLabel.leftAnchor, paddingLeft: 8, paddingRight: 8)
        stack.centerY(inView: profileImageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
