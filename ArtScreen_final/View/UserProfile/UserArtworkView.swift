//
//  UserArtworkView.swift
//  ArtScreen_final
//
//  Created by Heng on 2020/10/23.
//

import UIKit
import WaterfallLayout

private let reuseIdentifier = "ArtworkCell"

protocol UserArtworkViewDelegate: class {
    func handlePushToDetailPage(artwork: ArtworkDetail)
}

class UserArtworkView: UIView {
    
    //MARK: - Properties
    var user: User? {
        didSet {
            fetchUserArtwork()
        }
    }
    
    private var artworks = [ArtworkDetail]()
    weak var delegate: UserArtworkViewDelegate?
    
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
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        fetchUserArtwork()
        backgroundColor = .mainDarkGray
        collectionView.backgroundColor = .mainDarkGray
        collectionView.register(ArtworkCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.showsVerticalScrollIndicator = false
        
        addSubview(collectionView)
        collectionView.addConstraintsToFillView(self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - API
    func fetchUserArtwork() {
        guard let user = user else { return }
        ArtworkService.shared.fetchUserArtwork(forUser: user) { (artworks) in
            self.artworks = artworks
            
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    //MARK: - Selectors
    @objc func handleAddArtwork() {
        
    }
}

//MARK: - UICollectionViewDataSource
extension UserArtworkView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return artworks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ArtworkCell
        cell.artwork = artworks[indexPath.row]
        
        return cell
    }
}

//MARK: - UICollectionViewDelegate
extension UserArtworkView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedCell = artworks[indexPath.row]
        delegate?.handlePushToDetailPage(artwork: selectedCell)
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

