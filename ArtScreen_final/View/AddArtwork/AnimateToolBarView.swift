//
//  AnimateToolBarView.swift
//  ArtScreen_final
//
//  Created by Heng on 2020/10/23.
//

import UIKit

private let reuseIdentifier = "AnimateToorBarCell"

protocol AnimateToolBarViewDelegate: class {
    func moveSetting()
    func rotateSetting()
    func scaleSetting()
    func opacitySetting()
    func emitterSetting()
}

class AnimateToolBarView : UIView {
    
    //MARK: - Properties
    weak var delegate: AnimateToolBarViewDelegate?
    
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
       
    //MARK: - Selectors
   
    //MARK: - Helpers
    func configureUI() {
        backgroundColor = .black
        collectionView.register(AnimateToolBarCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        let selectedIndexPath = IndexPath(row: 0, section: 0)
        collectionView.selectItem(at: selectedIndexPath, animated: true, scrollPosition: .left)
        
        addSubview(collectionView)
        collectionView.addConstraintsToFillView(self)
    }
}

//MARK: - UICollectionViewDelegate
extension AnimateToolBarView : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let option = AnimateToolBarOption(rawValue: indexPath.row)
        switch option {
        case .path:
            delegate?.moveSetting()
        case .rotate:
            delegate?.rotateSetting()
        case .scale:
            delegate?.scaleSetting()
        case .opacity:
            delegate?.opacitySetting()
        case .emitter:
            delegate?.emitterSetting()
        case .none:
            print("DEBUG: Error..")
        }
    }
    
}

//MARK: - UICollectionViewDataSource
extension AnimateToolBarView : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return AnimateToolBarOption.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! AnimateToolBarCell
        
        let option = AnimateToolBarOption(rawValue: indexPath.row)
        cell.option = option
        
        return cell
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension AnimateToolBarView : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       
//        let count = CGFloat(AnimateToolBarOption.allCases.count)
        return CGSize(width: (frame.width - 18) / 6, height: frame.height)
   }
       
   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
       return 18
   }
}

