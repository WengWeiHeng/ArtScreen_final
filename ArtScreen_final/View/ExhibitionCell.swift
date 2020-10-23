//
//  ExhibitionCell.swift
//  ArtScreen_final
//
//  Created by Heng on 2020/10/23.
//

import UIKit

class ExhibitionCell: UICollectionViewCell {
    
    //MARK: - Properties
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        iv.layer.cornerRadius = 12
        
        return iv
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .mainDarkGray
        label.font = .boldSystemFont(ofSize: 16)
        label.numberOfLines = 0
        
        return label
    }()
    
    let introductionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .mainAlphaGray
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        
        return label
    }()
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .mainBackground
        layer.cornerRadius = 15
        
        addSubview(imageView)
        imageView.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, height: self.frame.width)
        
        addSubview(titleLabel)
        titleLabel.anchor(top: imageView.bottomAnchor, left: imageView.leftAnchor, right: imageView.rightAnchor, paddingTop: 12, paddingLeft: 12, paddingRight: 12, width: self.frame.width - 24)
        
        addSubview(introductionLabel)
        introductionLabel.anchor(top: titleLabel.bottomAnchor, left: titleLabel.leftAnchor, bottom: bottomAnchor, right: titleLabel.rightAnchor, paddingTop: 12, paddingBottom: 12)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
    func configureData() {
        print("DEBUG: Loading Exhibition Data")
    }
}
