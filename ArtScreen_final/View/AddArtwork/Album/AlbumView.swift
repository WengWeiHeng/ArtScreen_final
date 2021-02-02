//
//  AlbumViewRenew.swift
//  ArtScreen_final
//
//  Created by Heng on 2021/2/2.
//

import UIKit
import Photos

protocol AlbumViewDelegate: class {
    func uploadArtwork(_ image: UIImage)
}

private let reuseIdentifier = "AlbumCellIdentifier"
private let headerIdentifier = "HeaderIdentifier"

class AlbumView: UIView {
    
    //MARK: - Properties
    weak var delegate: AlbumViewDelegate?
    
    var images = [UIImage]()
    var assets = [PHAsset]()
    var selectedImage: UIImage?
    var header: AlbumHeaderView?
    
    let buttonNext: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "Next"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleTapNextButton), for: .touchUpInside)
        return button
    }()
    
    private let collectionView: UICollectionView = {
        let layout : UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
//        layout.sectionHeadersPinToVisibleBounds = true

        let collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight / 2),collectionViewLayout: layout)
        collectionView.collectionViewLayout = layout
        collectionView.backgroundColor = .white

        return collectionView
    }()
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureCollectionView()
        fetchPhotos()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Selectors
    @objc func handleTapNextButton() {
        guard let image = selectedImage else { return }
        delegate?.uploadArtwork(image)
    }
    
    //MARK: - Helpers
    func configureCollectionView() {
        addSubview(buttonNext)
        buttonNext.anchor(top: topAnchor, right: rightAnchor, paddingTop: 60, paddingRight: 12, width: 12, height: 24)
        
        addSubview(collectionView)
        collectionView.anchor(top: buttonNext.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 20)
        collectionView.register(AlbumCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.register(AlbumHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func getAssetFetchOptions() -> PHFetchOptions {
        let options = PHFetchOptions()
        
        //fetch limit
        options.fetchLimit = 200
        
        // sort photos by date
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false)
        
        // set sort descriptor for options
        options.sortDescriptors = [sortDescriptor]
        
        return options
    }
    
    func fetchPhotos() {
        let allPhotos = PHAsset.fetchAssets(with: .image, options: getAssetFetchOptions())
        
        // fetch images on background thread
        DispatchQueue.global(qos: .background).async {
            
            // enumerate objects
            allPhotos.enumerateObjects { (asset, count, stop) in
                let imageManager = PHImageManager.default()
                let targetSize = CGSize(width: 200, height: 200)
                let options = PHImageRequestOptions()
                options.isSynchronous = true
                
                // request image repressentation for specified asset
                imageManager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFit, options: options) { (image, info) in
                    if let image = image {
                        
                        // append image to data source
                        self.images.append(image)
                        
                        // append asset to data source
                        self.assets.append(asset)
                        
                        // set selected image
                        if self.selectedImage == nil {
                            self.selectedImage = image
                        }
                        
                        // reload collection view with images ince count has completed
                        if count == allPhotos.count - 1 {
                            // reload collection view on main thread
                            DispatchQueue.main.async {
                                self.collectionView.reloadData()
                            }
                        }
                    }
                }
            }
        }
    }
}

//MARK: - UICollectionViewDataSource
extension AlbumView: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! AlbumCell
        cell.photoImageView.image = images[indexPath.row]
        return cell
    }
}

//MARK: - UICollectionViewDelegate
extension AlbumView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath) as! AlbumHeaderView
        self.header = header
        if let selectedImage = selectedImage {
            if let index = self.images.firstIndex(of: selectedImage) {
                let selectedAsset = assets[index]
                let imageManager = PHImageManager.default()
                let targetSize = CGSize(width: 600, height: 600)
                
                imageManager.requestImage(for: selectedAsset, targetSize: targetSize, contentMode: .default, options: nil) { (image, info) in
                    header.photoImageView.image = image
                }
            }
        }
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedImage = images[indexPath.row]
        collectionView.reloadData()
        
        let indexPath = IndexPath(item: 0, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .bottom, animated: true)
    }
}


extension AlbumView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: screenWidth, height: screenWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (screenWidth - 3) / 4
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
}
