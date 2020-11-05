//
//  TemplateSettingView.swift
//  ArtScreen_final
//
//  Created by Heng on 2020/11/5.
//

import UIKit

protocol TempleSettingViewDelegate: class {
    func handleDismissal()
}

private let reuseIdentifier = "TempleSettingCell"

class TempleSettingView: UIView {
    
    //MARK: - Properties
    weak var delegate: TempleSettingViewDelegate?
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .none
        cv.delegate = self
        cv.dataSource = self
        
        return cv
    }()
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .black
        collectionView.register(EditToolBarCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        let selectedIndexPath = IndexPath(row: 0, section: 0)
        collectionView.selectItem(at: selectedIndexPath, animated: true, scrollPosition: .left)
        
        addSubview(collectionView)
        collectionView.addConstraintsToFillView(self)
        collectionView.showsHorizontalScrollIndicator = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TempleSettingView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return TempleSettingOption.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! EditToolBarCell
        
        let option = TempleSettingOption(rawValue: indexPath.row)
        cell.templeOption = option
        
        return cell
    }
}

extension TempleSettingView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let option = TempleSettingOption(rawValue: indexPath.row)
        
        switch option {
        case .close:
            delegate?.handleDismissal()
        case .style1:
            print("DEBUG: style 1 is selected..")
        case .style2:
            print("DEBUG: style 2 is selected..")
        case .style3:
            print("DEBUG: style 3 is selected..")
        case .none:
            print("Error..")
        }
    }
}

extension TempleSettingView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let count = CGFloat(ToolBarOption.allCases.count)
        return CGSize(width: (frame.width - 18) / count, height: frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 18
    }
}
