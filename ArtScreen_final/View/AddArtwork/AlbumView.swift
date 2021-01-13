//
//  AlbumView.swift
//  ArtScreen_final
//
//  Created by Heng on 2020/10/23.
//

import UIKit
import Photos
import AVFoundation

protocol AlbumViewDelegate: class {
    func uploadArtwork(_ image: UIImage)
}

class AlbumView: UIView {
    
    //MARK: - Properties
    weak var delegate: AlbumViewDelegate?
    let collectionViewHeaderFooterReuseIdentifier = "MyHeaderFooterClass"
    var captureSession: AVCaptureSession!
    var stillImageOutput: AVCapturePhotoOutput!
    var videoPreviewLayer: AVCaptureVideoPreviewLayer!
    var photoAssets: [PHAsset] = []
    
    var headerImageView: UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        
        return iv
    }()
    
    let buttonNext: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "Next"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleTapNextButton), for: .touchUpInside)
        return button
    }()
    
    let collectionView: UICollectionView = {
        let layout : UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.sectionHeadersPinToVisibleBounds = true

        let collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight / 2),collectionViewLayout: layout)
        collectionView.collectionViewLayout = layout
        collectionView.backgroundColor = .white
        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: "CollectionViewCell")
        collectionView.register(MyHeaderFooterCollectionView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "MyHeaderFooterClass")

        return collectionView
    }()

    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        loadPhotos()
        print(photoAssets.count)
        backgroundColor = .black
        
        addSubview(buttonNext)
        buttonNext.anchor(top: topAnchor, right: rightAnchor, paddingTop: 60, paddingRight: 12, width: 12, height: 24)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        addSubview(collectionView)
        collectionView.anchor(top: buttonNext.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 20)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Selectors
    @objc func handleTapNextButton() {
        print("Tap NextButton ...")
//        self.showNotification(imageView)
        
//        delegate?.presentPhotoCheckFromAlbum(headerImageView.image!)
        guard let image = headerImageView.image else { return }
        delegate?.uploadArtwork(image)
    }
    
    //MARK: - Helpers
    func loadPhotos() {
        // 取得するものをimageに指定
        // 取得したい順番などあれば options に指定する
        let assets: PHFetchResult = PHAsset.fetchAssets(with: .image, options: nil)
        // PHAssetを一つ一つ格納
        assets.enumerateObjects { [weak self] (asset, index, stop) in
            ////fixed start
            self?.photoAssets.insert(assets[index], at: 0)
            //fixed end
        }
    }
}

//MARK: - UICollectionViewDataSource / MyHeaderFooterCollectionViewDelegate
extension AlbumView: UICollectionViewDataSource, MyHeaderFooterCollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoAssets.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        cell.setupContents(photo: photoAssets[indexPath.row])

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: screenWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: collectionViewHeaderFooterReuseIdentifier, for: indexPath) as? MyHeaderFooterCollectionView
            headerView?.addSubview(headerImageView)
            headerImageView.anchor(top: headerView?.topAnchor, left: headerView?.leftAnchor, bottom: headerView?.bottomAnchor, right: headerView?.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)

            headerImageView.image = convertImageFromAsset(asset: photoAssets[0])
            return headerView!
        default:
            assert(false, "Unexpected element kind")

        }
    }
    
    func doSomething(_ headerView : UIView) {
        print("hello!")
//        headerView.backgroundColor = . yellow
    }
    
    func convertImageFromAsset(asset: PHAsset) -> UIImage {
         let manager = PHImageManager.default()
         let option = PHImageRequestOptions()
         var image = UIImage()
         option.isSynchronous = true
         manager.requestImage(for: asset, targetSize: PHImageManagerMaximumSize, contentMode: .aspectFit, options: option, resultHandler: {(result, info)->Void in
             image = result!
         })
         return image
     }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Index at \(indexPath.row)")
        if let header = collectionView.supplementaryView(forElementKind: UICollectionView.elementKindSectionHeader, at: IndexPath(item: 0, section: indexPath.section)) as? MyHeaderFooterCollectionView {
            // Do your stuff here

            header.addSubview(headerImageView)
            headerImageView.anchor(top: header.topAnchor, left: header.leftAnchor, bottom: header.bottomAnchor, right: header.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
            headerImageView.image = convertImageFromAsset(asset: photoAssets[indexPath.row])
        }
    }
}

//MARK: - UICollectionViewDelegateFlowLayout / UICollectionViewDelegate
extension AlbumView: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: screenWidth / 4.0, height: screenWidth / 4.0)

    }
}

//MARK: - CollectionViewCell
class CollectionViewCell: UICollectionViewCell {
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.frame = CGRect(x: 0, y: 0, width: screenWidth / 4.0, height: screenWidth / 4.0)
        
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        layer.borderColor = UIColor.darkGray.cgColor
        layer.borderWidth = 0.2
        contentView.addSubview(imageView)
    }
    
    func convertImageFromAsset(asset: PHAsset) -> UIImage {
        let manager = PHImageManager.default()
        let option = PHImageRequestOptions()
        var image = UIImage()
        option.isSynchronous = true
        manager.requestImage(for: asset, targetSize: PHImageManagerMaximumSize, contentMode: .aspectFit, options: option, resultHandler: {(result, info)->Void in
            image = result!
        })
        return image
    }
    
    func setupContents(photo: PHAsset) {
        self.imageView.image = convertImageFromAsset(asset: photo)
    }
}


