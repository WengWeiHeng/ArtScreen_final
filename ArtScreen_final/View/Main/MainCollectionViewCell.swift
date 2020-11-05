//
//  MainCollectionViewCell.swift
//  ArtScreen_final
//
//  Created by Heng on 2020/11/1.
//

import UIKit

class MainCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Properties
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .mainPurple
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
