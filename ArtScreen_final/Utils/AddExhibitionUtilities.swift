//
//  AddExhibitionUtilities.swift
//  ArtScreen_final
//
//  Created by Heng on 2020/10/22.
//

import UIKit

class AddExhibitionUtilities {
    
    func customLabel(title: String) -> UILabel {
        let label = UILabel()
        label.text = title
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = .white
        
        return label
    }
    
    func customTextField(placeholder: String) -> UITextField {
        let tf = UITextField()
        tf.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        tf.font = UIFont.systemFont(ofSize: 18)
        tf.clearButtonMode = .whileEditing
        tf.returnKeyType = .done
        tf.textColor = .white
        tf.tintColor = .mainPurple
        
        tf.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: tf.frame.height))
        
        return tf
    }
}
