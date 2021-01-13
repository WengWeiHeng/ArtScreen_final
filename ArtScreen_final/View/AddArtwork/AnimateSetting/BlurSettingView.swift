//
//  BlurSettingView.swift
//  ArtScreen_final
//
//  Created by Heng on 2021/1/7.
//

import UIKit

class BlurSettingView: UIView {
    
    //MARK: - Properties
    weak var delegate: SettingViewDelegate?
    
    private let titleLabel: UILabel = {
         let label = UILabel()
         label.font = .boldSystemFont(ofSize: 26)
         label.textColor = .white
         label.text = "Blur setting"
         
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
         let slider = Utilities().customSlider(withMaxValue: 2, minValue: 0, value: 0)
        
         return slider
    }()
    
    private lazy var sizeChangeBarStack: UIStackView = {
        let speedStack = UIStackView(arrangedSubviews: [speedLabel, speedSlider])
        speedStack.axis = .horizontal
        speedStack.alignment = .center
        speedStack.spacing = 8
        
        return speedStack
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
        
        addSubview(sizeChangeBarStack)
        sizeChangeBarStack.anchor(top: stack.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 30, paddingLeft: 16, paddingRight: 16)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Selectors
    @objc func handleDismissal() {
        delegate?.dismissSettingView()
    }
}
