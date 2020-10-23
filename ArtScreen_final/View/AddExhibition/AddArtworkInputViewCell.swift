//
//  AddArtworkInputViewCell.swift
//  ArtScreen_final
//
//  Created by Heng on 2020/10/23.
//

import UIKit

class AddArtworkInputViewCell: UICollectionViewCell {
    
    //MARK: - Properties
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .mainPurple
        iv.layer.cornerRadius = 15
        
        return iv
    }()
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(imageView)
        imageView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helper
    func configureData() {
        print("DEBUG: Loading Artwork Data")
    }
}
