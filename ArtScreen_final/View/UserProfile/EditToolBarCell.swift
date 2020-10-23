//
//  EditToolBarCell.swift
//  ArtScreen_final
//
//  Created by Heng on 2020/10/23.
//

import UIKit

class EditToolBarCell: UICollectionViewCell {
    
    //MARK: - Properties
    var option: ToolBarOption! {
        didSet {
            iconImageView.image = UIImage(named: option.iconName)
            toolTitleLabel.text = option.description
        }
    }
    
    private let iconImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.setDimensions(width: 26, height: 26)
        
        return iv
    }()
    
    private let toolTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 14)
        
        return label
    }()
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let stack = UIStackView(arrangedSubviews: [iconImageView, toolTitleLabel])
        stack.axis = .vertical
        stack.spacing = 10
        stack.alignment = .center
        
        addSubview(stack)
        stack.centerX(inView: self)
        stack.centerY(inView: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
}

