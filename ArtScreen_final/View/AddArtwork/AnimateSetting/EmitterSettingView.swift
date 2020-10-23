//
//  EmitterSettingView.swift
//  ArtScreen_final
//
//  Created by Heng on 2020/10/23.
//

import UIKit

protocol EmitterSettingViewDelegate: class {
    func sliderValueDidChange()
}

class EmitterSettingView: UIView {
    
    //MARK: - Properties
    weak var delegate: SettingViewDelegate?
    weak var selfDelegate: EmitterSettingViewDelegate?
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 26)
        label.textColor = .white
        label.text = "Emitter setting"
        
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
    
    private let sizeLabel: UILabel = {
         let label = Utilities().sliderTitleLabel(withText: "Size")
         
         return label
     }()
     
     let sizeSlider: UISlider = {
        let slider = Utilities().customSlider(withMaxValue: 500, minValue: 0, value: 250)
        slider.addTarget(self, action: #selector(sliderValueChange(sender:)), for: .valueChanged)
        
        return slider
    }()
    
    private let speedLabel: UILabel = {
         let label = Utilities().sliderTitleLabel(withText: "Speed")
         
         return label
     }()
     
     let speedSlider: UISlider = {
        let slider = Utilities().customSlider(withMaxValue: 100, minValue: 0, value: 50)
        slider.addTarget(self, action: #selector(sliderValueChange(sender:)), for: .valueChanged)
        
        return slider
    }()
    
    private let redLabel: UILabel = {
         let label = Utilities().sliderTitleLabel(withText: "Red")
         
         return label
     }()
     
     let redSlider: UISlider = {
        let slider = Utilities().customSlider(withMaxValue: 255, minValue: 0, value: 255, barColor: .mainRed)
        slider.addTarget(self, action: #selector(sliderValueChange(sender:)), for: .valueChanged)
        
        return slider
    }()
    
    private let greenLabel: UILabel = {
         let label = Utilities().sliderTitleLabel(withText: "Green")
         
         return label
     }()
     
     let greenSlider: UISlider = {
        let slider = Utilities().customSlider(withMaxValue: 255, minValue: 0, value: 255, barColor: .mainGreen)
        slider.addTarget(self, action: #selector(sliderValueChange(sender:)), for: .valueChanged)
        
        return slider
    }()
    
    private let blueLabel: UILabel = {
         let label = Utilities().sliderTitleLabel(withText: "Blue")
         
         return label
     }()
     
     let blueSlider: UISlider = {
        let slider = Utilities().customSlider(withMaxValue: 255, minValue: 0, value: 255, barColor: .mainBlue)
        slider.addTarget(self, action: #selector(sliderValueChange(sender:)), for: .valueChanged)
        
        return slider
    }()
    
    private lazy var sizeChangeBarStack: UIStackView = {
        let sizeStack = UIStackView(arrangedSubviews: [sizeLabel, sizeSlider])
        sizeStack.axis = .horizontal
        sizeStack.alignment = .center
        sizeStack.spacing = 8
        
        let speedStack = UIStackView(arrangedSubviews: [speedLabel, speedSlider])
        speedStack.axis = .horizontal
        speedStack.alignment = .center
        speedStack.spacing = 8
        
        let redStack = UIStackView(arrangedSubviews: [redLabel, redSlider])
        redStack.axis = .horizontal
        redStack.alignment = .center
        redStack.spacing = 8
        
        let greenStack = UIStackView(arrangedSubviews: [greenLabel, greenSlider])
        greenStack.axis = .horizontal
        greenStack.alignment = .center
        greenStack.spacing = 8
        
        let blueStack = UIStackView(arrangedSubviews: [blueLabel, blueSlider])
        blueStack.axis = .horizontal
        blueStack.alignment = .center
        blueStack.spacing = 8
        
        let stack = UIStackView(arrangedSubviews: [sizeStack, speedStack, redStack, greenStack, blueStack])
        stack.axis = .vertical
        stack.spacing = 4
        
        return stack
    }()
    
    private let colorView: UIView = {
        let view = UIView()
        view.backgroundColor = .mainPurple
        view.setDimensions(width: 50, height: 50)
        
        return view
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
    
    @objc func sliderValueChange(sender: UISlider) {
        selfDelegate?.sliderValueDidChange()
    }
}

