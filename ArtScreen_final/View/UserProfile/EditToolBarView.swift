//
//  EditToolBarView.swift
//  ArtScreen_final
//
//  Created by Heng on 2020/10/23.
//

import UIKit

protocol EditToolBarViewDelegate: class {
    func showTempleSettingView()
}

private let reuseIdentifier = "EditToorBarCell"

class EditToolBarView: UIView {
    
    //MARK: - Properties
    weak var delegate: EditToolBarViewDelegate?
    
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

extension EditToolBarView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ToolBarOption.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! EditToolBarCell
        
        let option = ToolBarOption(rawValue: indexPath.row)
        cell.option = option
        
        return cell
    }
}

extension EditToolBarView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let option = ToolBarOption(rawValue: indexPath.row)
        
        switch option {
        case .font:
            print("DEBUG: font action..")
        case .typeface:
            print("DEBUG: typeface action..")
        case .color:
            print("DEBUG: color action..")
        case .photo:
            print("DEBUG: photo action..")
        case .template:
            delegate?.showTempleSettingView()
        case .delete:
            print("DEBUG: delete action..")
        case .none:
            print("Error..")
        }
    }
}

extension EditToolBarView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let count = CGFloat(ToolBarOption.allCases.count)
        return CGSize(width: (frame.width - 18) / count, height: frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 18
    }
}

