//
//  ArtworkSearchCell.swift
//  ArtScreen_final
//
//  Created by Heng on 2021/1/25.
//

import UIKit

class ArtworkSearchCell : UITableViewCell {
    
    let artworkImageView: UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .mainPurple
        iv.setDimensions(width: 130, height: 98)
        iv.layer.cornerRadius = 16
        
        return iv
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 13)
        label.textColor = .mainPurple
        label.text = "@Content Artwork ..."
        label.numberOfLines = 0

        return label
    }()
    
    let kindLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 11)
        label.textColor = .mainAlphaGray
        label.text = "3s"
        
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        backgroundColor = .mainBackground
        
        addSubview(artworkImageView)
        artworkImageView.anchor(left: leftAnchor, paddingLeft: 16)
        artworkImageView.centerY(inView: self)

        addSubview(kindLabel)
        kindLabel.anchor(top: artworkImageView.topAnchor, left: artworkImageView.rightAnchor,paddingTop: 8, paddingLeft: 12)

        addSubview(nameLabel)
        nameLabel.anchor(top: kindLabel.bottomAnchor, left: kindLabel.leftAnchor, right: rightAnchor, paddingTop: 4, paddingRight: 16)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
