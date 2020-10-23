//
//  ExhibitionSendViewCell.swift
//  ArtScreen_final
//
//  Created by Heng on 2020/10/23.
//

import UIKit

class ExhibitionSendViewCell: UITableViewCell {
    
    //MARK: - Properties
    private let userImageView: UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.setDimensions(width: 52, height: 52)
        iv.backgroundColor = .mainPurple
        iv.layer.cornerRadius = 52 / 2
        
        return iv
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .mainPurple
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.text = "Heng_Weng"
        
        return label
    }()
    
    private let sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("SEND", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .mainPurple
        button.setDimensions(width: 70, height: 30)
        button.layer.cornerRadius = 30 / 2
        
        return button
    }()
    
    //MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .mainBackground
        
        addSubview(userImageView)
        userImageView.centerY(inView: self)
        userImageView.anchor(left: leftAnchor, paddingLeft: 16)
        
        addSubview(nameLabel)
        nameLabel.centerY(inView: userImageView)
        nameLabel.anchor(left: userImageView.rightAnchor, paddingLeft: 8)
        
        addSubview(sendButton)
        sendButton.centerY(inView: userImageView)
        sendButton.anchor(right: rightAnchor, paddingRight: 16)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

