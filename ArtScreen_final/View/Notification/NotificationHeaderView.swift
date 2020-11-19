//
//  NotificationHeaderView.swift
//  ArtScreen_final
//
//  Created by Heng on 2020/11/15.
//

import UIKit

class NotificationHeaderView: UIView {
    
    //MARK: - Properties
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 32)
        label.textColor = .mainPurple
        
        return label
    }()
    
    //MARK: - Init    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(titleLabel)
        titleLabel.anchor(left: leftAnchor, bottom: bottomAnchor, paddingLeft: 16, paddingBottom: 16)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Selectors
    @objc func handleMoreAction() {
        print("DEBUG: more action..")
    }
}
