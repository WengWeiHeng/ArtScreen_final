//
//  MapInfoInputView.swift
//  ArtScreen_final
//
//  Created by Heng on 2020/10/26.
//

import UIKit

class MapInfoInputView: UIView {
    
    //MARK: - Properties
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
    func configureUI() {
        backgroundColor = .mainBackground
    }
}
