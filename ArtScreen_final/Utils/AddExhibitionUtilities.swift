//
//  AddExhibitionUtilities.swift
//  ArtScreen_final
//
//  Created by Heng on 2020/10/22.
//

import UIKit

class AddExhibitionUtilities {
    
    func customTitleLebael(titleText: String, textColor: UIColor) -> UILabel {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 18)
        label.textColor = textColor
        label.text = titleText
        
        return label
    }
    
    func customLabel(title: String, color: UIColor) -> UILabel {
        let label = UILabel()
        label.text = title
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = color
        
        return label
    }
    
    func customTextField(placeholder: String, textColor: UIColor) -> UITextField {
        let tf = UITextField()
        tf.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        tf.font = UIFont.systemFont(ofSize: 18)
        tf.clearButtonMode = .whileEditing
        tf.returnKeyType = .done
        tf.textColor = textColor
        tf.tintColor = .mainPurple
        
        tf.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: tf.frame.height))
        
        return tf
    }
    
    func customTestView(fontSize: CGFloat, textColor: UIColor) -> UITextView {
        let tv = UITextView()
        tv.backgroundColor = .none
        tv.font = .systemFont(ofSize: fontSize)
        tv.textColor = textColor
        tv.textContainerInset = UIEdgeInsets.zero
        tv.textContainer.lineFragmentPadding = 0
        
        return tv
    }
}
