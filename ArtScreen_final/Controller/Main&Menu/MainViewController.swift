//
//  MainViewController.swift
//  ArtScreen_final
//
//  Created by Heng on 2020/10/21.
//

import UIKit
import AnimatedCollectionViewLayout

protocol MainControllerDelegate: class {
    func handleMenuToggle()
}

private let reuseIdentifier = "MainCollectionViewCell"

class MainViewController: UIViewController {
    
    //MARK: - Properties
    weak var delegate: MainControllerDelegate?
    private var buttonIsActive: Bool = false
    var addArtworkButtonCenter: CGPoint!
    var addExhibitionButtonCenter: CGPoint!
    
    private let menuButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "menu").withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .white
        button.setDimensions(width: 32, height: 20)
        button.addTarget(self, action: #selector(handleMenuAction), for: .touchUpInside)
    
        return button
    }()
    
    private let searchButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "search").withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .white
        button.setDimensions(width: 22, height: 24)
        button.addTarget(self, action: #selector(handleSearchAction), for: .touchUpInside)

        return button
    }()

    private let uploadButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "add").withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .white
        button.setDimensions(width: 24, height: 24)
        button.addTarget(self, action: #selector(handleUploadAction), for: .touchUpInside)

        return button
    }()
    
    private let addArtworkButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "addArtwork").withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .white
        button.setDimensions(width: 32, height: 32)
        button.addTarget(self, action: #selector(handleAddArtwork), for: .touchUpInside)
        button.alpha = 0
        
        return button
    }()
    
    private let addExhibitionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "addExhibition").withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .white
        button.setDimensions(width: 32, height: 32)
        button.addTarget(self, action: #selector(handleAddExhibition), for: .touchUpInside)
        button.alpha = 0
        
        return button
    }()
    
    private let barBGView: UIView = {
        let view = UIView()
        view.backgroundColor = .mainPurple
        view.alpha = 0
        
        return view
    }()
    
    private lazy var scrollView: UIScrollView = {
        let sv = UIScrollView()
        
        //scroll view顯示範圍
        sv.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        
        //內容物實際大小
        sv.contentSize = CGSize(width: screenWidth * 2.18 + 48, height: screenHeight * 1.55 + 48)
        
        //起始位置
        sv.contentOffset = CGPoint(x: screenWidth * 0.65, y: screenHeight * 0.35)
        
        //滾動條顯示
        sv.showsVerticalScrollIndicator = false
        sv.showsHorizontalScrollIndicator = false
        
        //可滑動
        sv.isScrollEnabled = true
        
        //解鎖單一方向
        sv.isDirectionalLockEnabled = false
        
        //彈回特效
        sv.bounces = true
        
        //預設縮放大小
        sv.zoomScale = 1.0
        
        //可縮小到的最小倍數
        sv.minimumZoomScale = 0.5
        
        //可縮小的最大倍數
        sv.maximumZoomScale = 2.0
        
        //縮放超過極限後的彈回特效設定
        sv.bouncesZoom = true
        
        //以一頁為單位滑動
        sv.isPagingEnabled = false
        
        
        return sv
    }()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let frame = CGRect(x: 0, y: 0, width: screenWidth * 2.18 + 48, height: screenHeight * 1.55 + 48)
        let cv = UICollectionView(frame: frame, collectionViewLayout: layout)
        cv.isScrollEnabled = false
        
        return cv
    }()
    
    //MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        
        print("DEBUG: scrollView Width is \(screenWidth * 2.18 + 48)")
        print("DEBUG: scrollView Height is \(screenHeight * 1.55 + 48)")
        print("DEBUG: scrollView center is \(scrollView.center)")
    }
    
    //MARK: - Selectors
    @objc func handleMenuAction() {
        delegate?.handleMenuToggle()
    }
    
    @objc func handleSearchAction() {
        print("DEBUG: Search..")
    }
    
    @objc func handleUploadAction() {
        if buttonIsActive == false {
            UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: .curveEaseInOut) {
                self.uploadButton.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi / 4))
                self.buttonAlpha(alpha: 1)
            } completion: { _ in
                self.buttonIsActive = true
            }
        } else {
            UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: .curveEaseInOut) {
                self.uploadButton.transform = CGAffineTransform.identity
                self.buttonAlpha(alpha: 0)
            } completion: { _ in
                self.buttonIsActive = false
            }
        }
        print("DEBUG: buttonIsActive is \(buttonIsActive)")
    }
    
    @objc func handleDismissal() {

    }
    
    @objc func handleAddArtwork() {
        let controller = AddArtworkController()
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
    
    @objc func handleAddExhibition() {
        let controller = AddExhibitionController()
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
    
    //MARK: - Helper
    func configureUI() {
        view.backgroundColor = .mainDarkGray
        configureCollectionView()
        
        view.addSubview(menuButton)
        menuButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, paddingTop: 16, paddingLeft: 16)
        
        view.addSubview(barBGView)
        barBGView.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingRight: 12, width: 48, height: 170)
        barBGView.layer.cornerRadius = 48 / 2
        
        view.addSubview(uploadButton)
        uploadButton.centerX(inView: barBGView)
        uploadButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, paddingBottom: 16)
        
        view.addSubview(addExhibitionButton)
        addExhibitionButton.centerX(inView: uploadButton)
        addExhibitionButton.anchor(bottom: uploadButton.topAnchor, paddingBottom: 26)
        
        view.addSubview(addArtworkButton)
        addArtworkButton.centerX(inView: uploadButton)
        addArtworkButton.anchor(bottom: addExhibitionButton.topAnchor, paddingBottom: 20)
        
        view.addSubview(searchButton)
        searchButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, right: uploadButton.rightAnchor, paddingTop: 16)
    }
    
    func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .none
        collectionView.register(MainCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        view.addSubview(scrollView)
        scrollView.addSubview(collectionView)
    }
    
    func buttonAlpha(alpha: CGFloat) {
        addArtworkButton.alpha = alpha
        addExhibitionButton.alpha = alpha
        barBGView.alpha = alpha
    }
}


extension MainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 25
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MainCollectionViewCell
        
        return cell
    }
}

extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("DEBUG: NO. \(indexPath) was selected..")
    }
}

extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (screenWidth - 52) / 2, height: (screenHeight - 69) / 3)
    }
}
