//
//  UserArtworkView.swift
//  ArtScreen_final
//
//  Created by Heng on 2020/10/23.
//

import UIKit
import WaterfallLayout

private let reuseIdentifier = "ArtworkCell"

class UserArtworkView: UIView {
    
    //MARK: - Properties
    private lazy var collectionView: UICollectionView = {
        let layout = WaterfallLayout()
        layout.delegate = self
        layout.sectionInset = UIEdgeInsets(top: 0, left: 12, bottom: 12, right: 12)
        layout.minimumLineSpacing = 8.0
        layout.minimumInteritemSpacing = 8.0
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .mainDarkGray
        cv.delegate = self
        cv.dataSource = self
        
        return cv
    }()
    
    private let announceView: UIStackView = {
        let stack = Utilities().noArtworkAnnounceView(announceText: "You don't have any Artwork", buttonSelector: #selector(handleAddArtwork))
        
        return stack
    }()
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .mainDarkGray
        collectionView.backgroundColor = .mainDarkGray
        collectionView.register(ArtworkCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.showsVerticalScrollIndicator = false
        
//        addSubview(announceView)
//        announceView.anchor(top: topAnchor, paddingTop: 100)
//        announceView.centerX(inView: self)
        
        addSubview(collectionView)
        collectionView.addConstraintsToFillView(self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Selectors
    @objc func handleAddArtwork() {
        
    }
}

//MARK: - UICollectionViewDataSource
extension UserArtworkView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ArtworkCell
        
        return cell
    }
}

//MARK: - UICollectionViewDelegate
extension UserArtworkView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("DEBUG: Exhibition cell did selected..")
    }
}

//MARK: - WaterfallLayoutDelegate
extension UserArtworkView: WaterfallLayoutDelegate {
    func collectionViewLayout(for section: Int) -> WaterfallLayout.Layout {
        return .waterfall(column: 2, distributionMethod: .balanced)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout: WaterfallLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return WaterfallLayout.automaticSize
    }
}

