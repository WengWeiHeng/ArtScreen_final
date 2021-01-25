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
private let searchIdentifier = "SearchViewCell"

protocol FilterViewDelegate: class {
    func moveToArtwork()
    func moveToExhibition()
}
protocol SearchViewDelegate: class {
    func changeStateSearch(state :SearchState)
}

class FilterView: UIView {
    
    //MARK: - Properties
    weak var delegate: FilterViewDelegate?
    weak var searchDelegate : SearchViewDelegate?
    private var state: FilterViewState = .inUserView
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .none
        cv.isScrollEnabled = true
        cv.delegate = self
        cv.dataSource = self
        
        return cv
    }()
    
    //MARK: - Init
    init(frame: CGRect,state: FilterViewState) {
        self.state = state
        super.init(frame: frame)
        switch state {
        case .inUserView:
            collectionView.register(FilterViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
            
        case .inSearchView:
            collectionView.register(SearchViewCell.self, forCellWithReuseIdentifier: searchIdentifier)
        }
        
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
            print("DEBUG - SearchCount = \(SearchOptions.allCases.count)")
            return SearchOptions.allCases.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch state {
        case .inUserView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! FilterViewCell
            let option = FilterOptions(rawValue: indexPath.row)
            cell.option = option
            print("DEBUG - FilterCell : \(indexPath.row)")

            return cell
        case .inSearchView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: searchIdentifier, for: indexPath) as! SearchViewCell
            let option = SearchOptions(rawValue: indexPath.row)
            cell.option = option
            print("DEBUG - SearchCell : \(indexPath.row)")
            return cell
        }
    }
}

//MARK: - CollectionView Delegate
extension FilterView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch state {
        case .inUserView:
            let option = FilterOptions(rawValue: indexPath.row)
            
            switch option {
            case .exhibitions:
                delegate?.moveToExhibition()
            case .artworks:
                delegate?.moveToArtwork()
            case .none:
                print("DEBUG: Error..")
            }
        case .inSearchView:
            let option = SearchOptions(rawValue: indexPath.row)
            
            switch option {
            case .accounts:
                searchDelegate?.changeStateSearch(state: .searchUser)
            print("Chose Account")
                
            case .artworks:
                print("Chose Artwork")
                searchDelegate?.changeStateSearch(state: .searchArtwork)

            case .exhibitions:
                print("Chose Exhibition")
                searchDelegate?.changeStateSearch(state: .searchExhibition)
                
            case .none:
                print("DEBUG: Error..")

            }
        }
        
    }
}

//MARK: - CollectionView Delegate FlowLayout
extension FilterView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        switch state {
        case .inUserView:
            let count = CGFloat(FilterOptions.allCases.count)
//            print("DEBUG: - FrameHight = \(frame.height)")
            return CGSize(width: (frame.width - 16) / count, height: frame.height)
        case .inSearchView:
            let count = CGFloat(SearchOptions.allCases.count)
//            print("DEBUG: - FrameHight = \(frame.height)")
            return CGSize(width: (frame.width - 48) / (count), height: frame.height)
        }
        
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {

        return 16
    }
}

