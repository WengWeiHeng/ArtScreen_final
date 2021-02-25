//
//  MainCellRenew.swift
//  ArtScreen_final
//
//  Created by Heng on 2021/2/24.
//

import UIKit

class MainCellRenew: UITableViewCell {
    
    //MARK: - Properties
    var exhibition: ExhibitionDetail? {
        didSet {
            configureData()
        }
    }
    
    private let exhibitionImageView: UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.setHeight(height: screenWidth * 0.7)
        
        return iv
    }()
    
    private let exhibitionNameLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        label.textColor = .mainPurple
        
        return label
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 14)
        label.textColor = .mainPurple
        
        return label
    }()
    
    private let userImageView: UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.setDimensions(width: 28, height: 28)
        iv.layer.cornerRadius = 28 / 2
        
        return iv
    }()
    
    //MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .white
        layer.cornerRadius = 26
        addShadow()
        
        addSubview(exhibitionImageView)
        exhibitionImageView.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor)
        exhibitionImageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        exhibitionImageView.layer.cornerRadius = 26
        
        
        
        addSubview(exhibitionNameLabel)
        exhibitionNameLabel.anchor(top: exhibitionImageView.bottomAnchor, left: exhibitionImageView.leftAnchor, paddingTop: 8, paddingLeft: 16)
        
        let stack = UIStackView(arrangedSubviews: [userImageView, usernameLabel])
        stack.axis = .horizontal
        stack.spacing = 4
        
        addSubview(stack)
        stack.anchor(top: exhibitionNameLabel.bottomAnchor, left: exhibitionNameLabel.leftAnchor, bottom: bottomAnchor, paddingTop: 8, paddingBottom: 12)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureData() {
        guard let exhibition = exhibition else { return }
        exhibitionImageView.sd_setImage(with: URL(string:exhibition.path))
        exhibitionNameLabel.text = exhibition.exhibitionName
        
        UserService.shared.fetchUserOfExhibition(withExhibition: exhibition) { user in
            DispatchQueue.main.async {
                self.usernameLabel.text = user.username
                self.userImageView.sd_setImage(with: user.ava)
            }
        }
        
    }
}
