//
//  ArtworkInputCell.swift
//  ArtScreen_final
//
//  Created by Heng on 2020/10/23.
//

import UIKit

class ArtworkInputViewCell: UICollectionViewCell {
    
    //MARK: - Properties
    var artwork: ArtworkDetail? {
        didSet {
            configureData()
        }
    }
    
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 15
        iv.backgroundColor = .mainBackground
        
        return iv
    }()
    
    private let artworkName: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 14)
        label.numberOfLines = 0
        label.textColor = .mainBackground
        label.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit."
        
        return label
    }()
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(imageView)
        imageView.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, height: frame.width)
        
        addSubview(artworkName)
        artworkName.anchor(top: imageView.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 8)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
    
    func configureData() {
        guard let artwork = artwork else { return }
        imageView.sd_setImage(with: artwork.path)
        artworkName.text = artwork.artworkName
    }
}
