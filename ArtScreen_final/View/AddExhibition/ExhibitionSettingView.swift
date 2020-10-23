//
//  ExhibitionSettingView.swift
//  ArtScreen_final
//
//  Created by Heng on 2020/10/23.
//

import UIKit

protocol ExhibitionSettingViewDelegate: class {
    func didTappedNewArtwork()
    func didTappedEditInfo()
    func didTappedSend()
    func didTappedCancel()
}

class ExhibitionSettingView: UIView {
    
    //MARK: - Properties
    weak var delegate: ExhibitionSettingViewDelegate?
    
    private var btnNewArtwork: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Add Artwork", for: .normal)
        button.setTitleColor(.mainPurple, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.titleLabel?.textAlignment = .left
        button.addTarget(self, action: #selector(tapNewArtWork), for: .touchUpInside)
        
        return button
    }()
    
    private var btnEditInfo: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Edit Information", for: .normal)
        button.setTitleColor(.mainPurple, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.titleLabel?.textAlignment = .left
        button.addTarget(self, action: #selector(tapEditInfo), for: .touchUpInside)
        
        return button
    }()
    
    private var btnSend: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Send", for: .normal)
        button.setTitleColor(.mainPurple, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.titleLabel?.textAlignment = .left
        button.addTarget(self, action: #selector(tapSend), for: .touchUpInside)
        
        return button
    }()
    
    private var btnCancel: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "cancel_circle_m"), for: .normal)
        button.titleLabel?.textAlignment = .left
        button.addTarget(self, action: #selector(tapCancel), for: .touchUpInside)
        
        return button
    }()
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .mainBackground
        layer.cornerRadius = 24
        
        btnNewArtwork.translatesAutoresizingMaskIntoConstraints = false
        btnNewArtwork.contentHorizontalAlignment = .left
        btnNewArtwork.titleEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
        
        btnEditInfo.translatesAutoresizingMaskIntoConstraints = false
        btnEditInfo.contentHorizontalAlignment = .left
        btnEditInfo.titleEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)

        btnSend.translatesAutoresizingMaskIntoConstraints = false
        btnSend.contentHorizontalAlignment = .left
        btnSend.titleEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
        
        btnCancel = UIButton()
        btnCancel.setImage(UIImage(named: "cancel_circle_m"), for: .normal)
        btnCancel.setTitleColor(.purple, for: .normal)
        btnCancel.addTarget(self, action: #selector(tapCancel), for: .touchUpInside)
        btnCancel.translatesAutoresizingMaskIntoConstraints = false
        btnCancel.setDimensions(width: 36, height: 36)

//        let stackView = UIStackView(frame: .zero)
        let stackView = UIStackView(arrangedSubviews: [btnNewArtwork, btnEditInfo, btnSend])
        addSubview(stackView)
        
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 5
        stackView.layoutMargins = UIEdgeInsets(top: 30, left: 10, bottom: 90, right: 10)
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor)
        
        addSubview(btnCancel)
        btnCancel.centerX(inView: self)
        btnCancel.anchor(bottom: safeAreaLayoutGuide.bottomAnchor, paddingBottom: 20)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Selectors
    @objc func tapNewArtWork() {
        print("btnNewArtWork be tapped")
        delegate?.didTappedNewArtwork()
    }
    
    @objc func tapEditInfo() {
        print("btnEditInfo be tapped")
        self.delegate?.didTappedEditInfo()
    }
    
    @objc func tapSend() {
        print("btnSend be tapped")
        self.delegate?.didTappedSend()
    }
    
    @objc func tapCancel() {
        print("btnCancel be tapped")
        self.delegate?.didTappedCancel()
    }
}

