//
//  FilterView.swift
//  ArtScreen_final
//
//  Created by Heng on 2020/10/23.
//

import UIKit

enum FilterViewState {
    case inUserView
    case inSearchView
}

private let reuseIdentifier = "FilterViewCell"

protocol FilterViewDelegate: class {
    func moveToArtwork()
    func moveToExhibition()
}

class FilterView: UIView {
    
    //MARK: - Properties
    weak var delegate: FilterViewDelegate?
    
    var state: FilterViewState = .inUserView
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .none
        cv.delegate = self
        cv.dataSource = self
        
        return cv
    }()
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        collectionView.register(FilterViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        let selectedIndexPath = IndexPath(row: 0, section: 0)
        collectionView.selectItem(at: selectedIndexPath, animated: true, scrollPosition: .left)
        
        addSubview(collectionView)
        collectionView.addConstraintsToFillView(self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
//MARK: - CollectionView DataSource
extension FilterView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch state {
        case .inUserView:
            return FilterOptions.allCases.count
        case .inSearchView:
            return SearchOptions.allCases.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! FilterViewCell
        
        let option = FilterOptions(rawValue: indexPath.row)
        cell.option = option
        
        return cell
    }
}

//MARK: - CollectionView Delegate
extension FilterView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let option = FilterOptions(rawValue: indexPath.row)
        
        switch option {
        case .exhibitions:
            delegate?.moveToExhibition()
            
        case .artworks:
            delegate?.moveToArtwork()
            
        case .none:
            print("DEBUG: Error..")
        }
    }
}

//MARK: - CollectionView Delegate FlowLayout
extension FilterView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        switch state {
        case .inUserView:
            let count = CGFloat(FilterOptions.allCases.count)
            return CGSize(width: (frame.width - 16) / count, height: frame.height)
        case .inSearchView:
            let count = CGFloat(SearchOptions.allCases.count)
            return CGSize(width: (frame.width - 16) / count, height: frame.height)
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
}

