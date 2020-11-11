//
//  MainCollectionViewCell.swift
//  ArtScreen_final
//
//  Created by Heng on 2020/11/1.
//

import UIKit

class MainCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Properties
    private let coverImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 15
        iv.image = #imageLiteral(resourceName: "coverImage")
        
        return iv
    }()
    
    private let exhibitionNameLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 18)
        label.textColor = .white
        label.text = "Mauris hendrerit quam orci, sit amet posuere ante vestibulum sodales."
        label.numberOfLines = 3
        
        return label
    }()
    
    private let gradientView: UIView = {
        let view = UIView()
        
        
        return view
    }()
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.cornerRadius = 15
        
        addSubview(coverImageView)
        coverImageView.addConstraintsToFillView(self)
        
        let gradinentLayer = CAGradientLayer()
        gradinentLayer.colors = [UIColor.mainRed.cgColor, UIColor.mainAlphaWhite.cgColor]
        gradinentLayer.locations = [0, 1]
        layer.addSublayer(gradinentLayer)
        
        addSubview(gradientView)
        gradientView.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, height: 50)
        gradientView.layer.addSublayer(gradinentLayer)
        
        addSubview(exhibitionNameLabel)
        exhibitionNameLabel.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 12, paddingLeft: 12, paddingRight: 12)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
