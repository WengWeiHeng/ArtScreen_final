//
//  AddLocationCell.swift
//  ArtScreen_final
//
//  Created by Heng on 2020/10/27.
//

import UIKit

class AddLocationCell: UITableViewCell {
    
    //MARK: - Properties
    let locationNameLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        label.textColor = .white
        label.text = "Loading Location"
        
        return label
    }()
    
    let addressLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .mainAlphaGray
        label.text = "Loading Address.."
        
        return label
    }()
    
    //MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .mainDarkGray
        selectionStyle = .none
        
        let stack = UIStackView(arrangedSubviews: [locationNameLabel, addressLabel])
        stack.axis = .vertical
        stack.spacing = 4
        
        addSubview(stack)
        stack.centerY(inView: self)
        stack.anchor(left: leftAnchor, right: rightAnchor, paddingLeft: 16, paddingRight: 16)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
