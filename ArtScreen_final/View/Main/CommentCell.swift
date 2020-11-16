//
//  CommentCell.swift
//  ArtScreen_final
//
//  Created by Heng on 2020/11/12.
//

import UIKit

class CommentCell: UITableViewCell {
    
    //MARK: - Properties
    private let userImageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .mainPurple
        iv.layer.borderWidth = 1.2
        iv.layer.borderColor = UIColor.white.cgColor
        iv.setDimensions(width: 32, height: 32)
        iv.layer.cornerRadius = 32 / 2
        
        return iv
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.text = "@heng_8130"
        label.textColor = .mainBackground
        
        return label
    }()
    
    let messageLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Mauris fermentum nulla sit amet elementum iaculis. Donec ac nisi dictum, hendrerit quam ut, consequat neque. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Donec hendrerit facilisis tortor nec pretium. Mauris eu fringilla orci. Cras in enim lorem."
        label.textColor = .mainBackground
        
        return label
    }()
    
    private let timestampLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.text = ".16m"
        label.textColor = .mainAlphaGray
        
        return label
    }()
    
    //MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .mainDarkGray
        selectionStyle = .none
        
        addSubview(userImageView)
        userImageView.anchor(top: topAnchor, left: leftAnchor, paddingTop: 8, paddingLeft: 12)
        
        addSubview(usernameLabel)
        usernameLabel.anchor(top: userImageView.topAnchor, left: userImageView.rightAnchor, paddingTop: 4, paddingLeft: 10)
        
        addSubview(messageLabel)
        messageLabel.anchor(top: usernameLabel.bottomAnchor, left: usernameLabel.leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 6, paddingBottom: 8, paddingRight: 12)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

