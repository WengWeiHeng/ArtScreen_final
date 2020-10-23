//
//  Utilities.swift
//  ArtScreen_final
//
//  Created by Heng on 2020/10/21.
//

import UIKit

class Utilities {
    func inputContainerView(withImage image: UIImage, textField: UITextField) -> UIView{
        let view = UIView()
        let iv = UIImageView()
        view.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        iv.image = image
        view.addSubview(iv)
        iv.anchor(left: view.leftAnchor, bottom: view.bottomAnchor, paddingLeft: 8, paddingBottom: 8)
        iv.setDimensions(width: 24, height: 24)
        
        view.addSubview(textField)
        textField.anchor(left: iv.rightAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingLeft: 8, paddingBottom: 8)
        
        let dividerView = UIView()
        dividerView.backgroundColor = .mainPurple
        view.addSubview(dividerView)
        dividerView.anchor(left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingLeft: 8, height: 0.75)
        
        return view
    }
    
    func textField(withPlaceholder placeholder: String) -> UITextField {
        let tf = UITextField()
        tf.placeholder = placeholder
        tf.textColor = .mainPurple
        tf.font = UIFont.systemFont(ofSize: 16)
        tf.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor: UIColor.mainPurple])
        
        return tf
    }
    
    func attributedButton(_ firstPart: String, _ secondPart: String) -> UIButton {
        let button = UIButton(type: .system)
        
        let attributedTitle = NSMutableAttributedString(string: firstPart, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16), NSMutableAttributedString.Key.foregroundColor: UIColor.mainPurple])
        
        attributedTitle.append(NSMutableAttributedString(string: secondPart, attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16), NSMutableAttributedString.Key.foregroundColor: UIColor.mainPurple]))
        
        button.setAttributedTitle(attributedTitle, for: .normal)
        
        return button
    }
    
    func buttonContainerView(withImage image: UIImage, title: String) -> UIView {
        let view = UIView()
        view.backgroundColor = .mainBackground
        view.layer.cornerRadius = 15
        
        let imageView = UIImageView()
        imageView.image = image
        imageView.setDimensions(width: 74, height: 74)
        
        let label = UILabel()
        label.text = title
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .mainPurple
        
        let stack = UIStackView(arrangedSubviews: [imageView, label])
        stack.axis = .vertical
        stack.spacing = 12
        stack.alignment = .center
        
        view.addSubview(stack)
        stack.centerY(inView: view)
        stack.centerX(inView: view)
        
        return view
    }
    
    //MARK: - AddExhibition
    func noArtworkAnnounceView(announceText: String, buttonSelector: Selector) -> UIStackView {
        let iv = UIImageView()
        iv.clipsToBounds = true
        iv.image = #imageLiteral(resourceName: "notice")
        iv.setDimensions(width: 30, height: 30)
        
        let announceLabel = UILabel()
        announceLabel.font = UIFont.systemFont(ofSize: 16)
        announceLabel.textColor = .white
        announceLabel.text = announceText
        announceLabel.textAlignment = .center
        announceLabel.numberOfLines = 0
        
        let button = UIButton(type: .system)
        button.setTitle("ADD", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .mainPurple
        button.setDimensions(width: 80, height: 40)
        button.layer.cornerRadius = 40 / 2
        button.addTarget(self, action: buttonSelector, for: .touchUpInside)
        
        let stack = UIStackView(arrangedSubviews: [iv, announceLabel, button])
        stack.axis = .vertical
        stack.spacing = 10
        stack.alignment = .center
        stack.widthAnchor.constraint(equalToConstant: 160).isActive = true

        return stack
    }
}
