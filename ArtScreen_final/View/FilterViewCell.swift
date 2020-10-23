//
//  FilterViewCell.swift
//  ArtScreen_final
//
//  Created by Heng on 2020/10/23.
//

import UIKit

class FilterViewCell: UICollectionViewCell {
    
    //MARK: - Properties
    var option: FilterOptions! {
        didSet { titleLabel.text = option.description }
    }
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .mainDarkGray
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.text = "Text filter"
        
        return label
    }()
    
    lazy var actionView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 40 / 2
        view.addSubview(titleLabel)
        titleLabel.centerX(inView: view)
        titleLabel.centerY(inView: view)
        
        return view
    }()
    
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(actionView)
        actionView.addConstraintsToFillView(self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var isSelected: Bool{
        didSet{
            titleLabel.textColor = isSelected ? .white : .mainDarkGray
            actionView.backgroundColor = isSelected ? .mainPurple : .white
        }
    }
}

