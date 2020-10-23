//
//  MoveSettingView.swift
//  ArtScreen_final
//
//  Created by Heng on 2020/10/23.
//

import UIKit

class MoveSettingView: UIView {
    
    //MARK: - Properties
    weak var delegate: SettingViewDelegate?
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 26)
        label.textColor = .white
        label.text = "Move setting"
        
        return label
    }()
    
    private let doneButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Done", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 14)
        button.addTarget(self, action: #selector(handleDismissal), for: .touchUpInside)
        
        return button
    }()
    
    private let speedLabel: UILabel = {
         let label = Utilities().sliderTitleLabel(withText: "Speed")
         
         return label
     }()
     
     let speedSlider: UISlider = {
         let slider = Utilities().customSlider(withMaxValue: 3, minValue: 0, value: 0)
        
         return slider
    }()
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .mainDarkGray
        
        let stack = UIStackView(arrangedSubviews: [titleLabel, doneButton])
        stack.axis = .horizontal
        stack.alignment = .center
        
        addSubview(stack)
        stack.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 20, paddingLeft: 16, paddingRight: 16)
        
        let sliderStack = UIStackView(arrangedSubviews: [speedLabel, speedSlider])
        sliderStack.axis = .horizontal
        sliderStack.alignment = .center
        sliderStack.spacing = 20
        
        addSubview(sliderStack)
        sliderStack.anchor(top: stack.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 20, paddingLeft: 16, paddingRight: 16)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Selectors
    @objc func handleDismissal() {
        delegate?.dismissSettingView()
    }
}
