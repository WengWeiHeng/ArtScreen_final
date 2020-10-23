//
//  LassoToolBarView.swift
//  ArtScreen_final
//
//  Created by Heng on 2020/10/23.
//

import UIKit

protocol LassoToolBarDelegate: class {
    func backAction()
    func jointAction()
    func undoAction()
    func cutAction()
    func cleanAction()
}

private let reuseIdentifier = "LassoToolBarCell"

class LassoToolBarView: UIView {
    
    //MARK: - Properties
    weak var delegate: LassoToolBarDelegate?
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .none
        cv.delegate = self
        cv.dataSource = self
        cv.showsHorizontalScrollIndicator = false
        
        return cv
    }()
    
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
        backgroundColor = .black
        collectionView.register(LassoToolBarCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        addSubview(collectionView)
        collectionView.addConstraintsToFillView(self)
    }
    
}

extension LassoToolBarView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return LassoToolBarOption.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! LassoToolBarCell
        let option = LassoToolBarOption(rawValue: indexPath.row)
        cell.option = option
        
        return cell
    }
}

extension LassoToolBarView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let option = LassoToolBarOption(rawValue: indexPath.row)
        switch option {
        case .close:
            delegate?.backAction()
        case .joint:
            delegate?.jointAction()
        case .undo:
            delegate?.undoAction()
        case .crop:
            delegate?.cutAction()
        case .clear:
            delegate?.cleanAction()
        case .none:
            print("DEBUG: Error..")
        }
    }
}

extension LassoToolBarView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            
//        let count = CGFloat(LassoToolBarOption.allCases.count)
        return CGSize(width: (frame.width - 18) / 6, height: frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 18
    }

}

