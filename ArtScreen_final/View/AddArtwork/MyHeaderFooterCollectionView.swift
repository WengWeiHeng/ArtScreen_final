//
//  MyHeaderFooterCollectionView.swift
//  ArtScreen_final
//
//  Created by Heng on 2020/10/23.
//

import UIKit

protocol MyHeaderFooterCollectionViewDelegate: class {

    // 2. create a function that will do something when the header is tapped
    func doSomething(_ headerView : UIView)
}
class MyHeaderFooterCollectionView: UICollectionReusableView {
    weak var delegate: MyHeaderFooterCollectionViewDelegate?
        override init(frame: CGRect) {
           super.init(frame: frame)
           // Customize here
        }
        required init?(coder aDecoder: NSCoder) {
           super.init(coder: aDecoder)
        }
}
