//
//  ScaleSettingView.swift
//  ArtScreen_final
//
//  Created by Heng on 2020/10/23.
//

import UIKit

class ScaleSettingView: UIView {
    
    //MARK: - Properties
    weak var delegate: SettingViewDelegate?
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 26)
        label.textColor = .white
        label.text = "Scale setting"
        
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
    
    private let maxLabel: UILabel = {
        let label = Utilities().sliderTitleLabel(withText: "Max size")
        
        return label
    }()
    
    private let minLabel: UILabel = {
        let label = Utilities().sliderTitleLabel(withText: "Min size")
        
        return label
    }()
    
    private let speedLabel: UILabel = {
        let label = Utilities().sliderTitleLabel(withText: "Speed")
        
        return label
    }()
    
    let maxSizeSlider: UISlider = {
        let slider = Utilities().customSlider(withMaxValue: 3, minValue: 0, value: 0)
       
        return slider
   }()
   
   let minSizeSlider: UISlider = {
        let slider = Utilities().customSlider(withMaxValue: 1, minValue: 0, value: 0)
       
        return slider
   }()
   
   let speedSlider: UISlider = {
        let slider = Utilities().customSlider(withMaxValue: 3, minValue: 0, value: 0)
       
        return slider
   }()
   
   private lazy var sizeChangeBarStack: UIStackView = {
       let maxStack = UIStackView(arrangedSubviews: [maxLabel, maxSizeSlider])
       maxStack.axis = .horizontal
       maxStack.alignment = .center
       maxStack.spacing = 8
       
       let minStack = UIStackView(arrangedSubviews: [minLabel, minSizeSlider])
       minStack.axis = .horizontal
       minStack.alignment = .center
       minStack.spacing = 8
       
       let speedStack = UIStackView(arrangedSubviews: [speedLabel, speedSlider])
       speedStack.axis = .horizontal
       speedStack.alignment = .center
       speedStack.spacing = 8
       
       let stack = UIStackView(arrangedSubviews: [maxStack, minStack, speedStack])
       stack.axis = .vertical
       stack.spacing = 4
       
       return stack
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

