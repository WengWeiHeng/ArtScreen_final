//
//  UserExhibitionView.swift
//  ArtScreen_final
//
//  Created by Heng on 2020/10/23.
//

import UIKit
import WaterfallLayout

protocol UserExhibitionViewDelegate: class {
    func handlePushToDetailPage(exhibition: ExhibitionDetail)
    func exhibitionCount(exhibitionCount: Int)
}

private let reuseIdentifier = "ExhibitionCell"

class UserExhibitionView: UIView {
    
    //MARK: - Properties
    var user: User? {
        didSet {
            fetchUserExhibition()
        }
    }
    
    weak var delegate: UserExhibitionViewDelegate?
    
    var exhibitions = [ExhibitionDetail]()
    
    private lazy var collectionView: UICollectionView = {
        let layout = WaterfallLayout()
        layout.delegate = self
        layout.sectionInset = UIEdgeInsets(top: 0, left: 12, bottom: 12, right: 12)
        layout.minimumLineSpacing = 8.0
        layout.minimumInteritemSpacing = 8.0
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.delegate = self
        cv.dataSource = self
        
        
        return cv
    }()
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        collectionView.backgroundColor = .mainDarkGray
        collectionView.register(ExhibitionCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.showsHorizontalScrollIndicator = false
        addSubview(collectionView)
        collectionView.addConstraintsToFillView(self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - API
    func fetchUserExhibition() {
        guard let user = user else { return }
        ExhibitionService.shared.fetchUserExhibition(forUser: user) { exhibitions in
            self.exhibitions = exhibitions
            
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                self.delegate?.exhibitionCount(exhibitionCount: exhibitions.count)
            }
        }
    }
}

//MARK: - UICollectionViewDataSource
extension UserExhibitionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return exhibitions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ExhibitionCell
        cell.exhibition = exhibitions[indexPath.row]
        return cell
    }
}

//MARK: - UICollectionViewDelegate
extension UserExhibitionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("DEBUG: Exhibition cell did selected..")
        let selectedCell = exhibitions[indexPath.row]
        delegate?.handlePushToDetailPage(exhibition: selectedCell)
    }
}

//MARK: - WaterfallLayoutDelegate
extension UserExhibitionView: WaterfallLayoutDelegate {
    func collectionViewLayout(for section: Int) -> WaterfallLayout.Layout {
        return .waterfall(column: 2, distributionMethod: .balanced)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout: WaterfallLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return WaterfallLayout.automaticSize
    }
}

