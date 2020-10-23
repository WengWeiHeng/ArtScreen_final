//
//  RotateSettingView.swift
//  ArtScreen_final
//
//  Created by Heng on 2020/10/23.
//

import UIKit

protocol SettingViewDelegate: class {
    func dismissSettingView()
//    func dismissMoveSetting()
}

class RotateSettingView: UIView {
    
    //MARK: - Properties
    weak var delegate: SettingViewDelegate?
    
    var fromeValue: Double = 0
    var toValue: Double = 0
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 26)
        label.textColor = .white
        label.text = "Rotate setting"
        
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
    
    private let leftButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Left", for: .normal)
        button.setTitleColor(.mainDarkGray, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 16)
        button.backgroundColor = .mainBackground
        button.setDimensions(width: 80, height: 40)
        button.layer.cornerRadius = 40 / 2
        button.addTarget(self, action: #selector(handleLeftRotate), for: .touchUpInside)
        
        return button
    }()
    
    private let rightButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Right", for: .normal)
        button.setTitleColor(.mainDarkGray, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 16)
        button.backgroundColor = .mainBackground
        button.setDimensions(width: 80, height: 40)
        button.layer.cornerRadius = 40 / 2
        button.addTarget(self, action: #selector(handleRightRotate), for: .touchUpInside)
        
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
        
        let buttonStack = UIStackView(arrangedSubviews: [leftButton, rightButton])
        buttonStack.axis = .horizontal
        buttonStack.alignment = .center
        buttonStack.spacing = 16
        
        let settingStack = UIStackView(arrangedSubviews: [sliderStack, buttonStack])
        settingStack.axis = .vertical
        settingStack.alignment = .center
        settingStack.spacing = 20
        
        addSubview(settingStack)
        settingStack.anchor(top: stack.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 20, paddingLeft: 16, paddingRight: 16)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - Functionn
    ///fixed srtart
    @objc func resetButton() {
        print("Testttt")
        leftButton.backgroundColor = .mainBackground
        leftButton.setTitleColor(.mainDarkGray, for: .normal)
        rightButton.backgroundColor = .mainBackground
        rightButton.setTitleColor(.mainDarkGray, for: .normal)
    }
    ///fixed start
    
    
    //MARK: - Selectors
    @objc func handleDismissal() {
        delegate?.dismissSettingView()
    }
    
    @objc func handleLeftRotate() {
        fromeValue = 0
        toValue = Double.pi * 2
        UIView.animate(withDuration: 0.3) {
            self.leftButton.backgroundColor = .mainPurple
            self.leftButton.setTitleColor(.mainBackground, for: .normal)
            self.rightButton.backgroundColor = .mainBackground
            self.rightButton.setTitleColor(.mainDarkGray, for: .normal)
        }
    }
    
    @objc func handleRightRotate() {
        fromeValue = Double.pi * 2
        toValue = 0
        UIView.animate(withDuration: 0.3) {
            self.rightButton.backgroundColor = .mainPurple
            self.rightButton.setTitleColor(.mainBackground, for: .normal)
            self.leftButton.backgroundColor = .mainBackground
            self.leftButton.setTitleColor(.mainDarkGray, for: .normal)
        }
    }
}

