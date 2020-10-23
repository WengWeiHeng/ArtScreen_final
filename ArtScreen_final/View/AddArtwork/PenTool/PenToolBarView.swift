//
//  PenToolBarView.swift
//  ArtScreen_final
//
//  Created by Heng on 2020/10/23.
//

import UIKit

protocol PenToolBarDelegate: class {
    func penCloseAction()
    func penClearAction()
    func penCropAction()
    func penJointAction()
}

private let reuseIdentifier = "PenToolBarCell"

class PenToolBarView: UIView {
    
    //MARK: - Properties
    weak var delegate: PenToolBarDelegate?
    
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
        collectionView.register(PenToolBarCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        addSubview(collectionView)
        collectionView.addConstraintsToFillView(self)
    }
}

extension PenToolBarView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return PenToolBarOption.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PenToolBarCell
        let option = PenToolBarOption(rawValue: indexPath.row)
        cell.option = option
        
        return cell
    }
}

extension PenToolBarView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let option = PenToolBarOption(rawValue: indexPath.row)
        switch option {
        case .close:
            delegate?.penCloseAction()
        case .crop:
            delegate?.penCropAction()
        case .joint:
            delegate?.penJointAction()
        case .clear:
            delegate?.penClearAction()
        case .none:
            print("DEBUG: Error..")
        }

    }
}

extension PenToolBarView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            
        return CGSize(width: (frame.width - 18) / 6, height: frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 18
    }

}

