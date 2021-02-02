//
//  AblumHeaderView.swift
//  ArtScreen_final
//
//  Created by Heng on 2021/2/2.
//

import UIKit

class AlbumHeaderView: UICollectionReusableView {
    
    //MARK: - Properties
    let photoImageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.backgroundColor = .mainPurple
        
        return image
    }()
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(photoImageView)
        photoImageView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }}
