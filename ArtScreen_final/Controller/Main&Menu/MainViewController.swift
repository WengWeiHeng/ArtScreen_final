//
//  MainViewController.swift
//  ArtScreen_final
//
//  Created by Heng on 2020/10/21.
//

import UIKit

private let reuseIdentifier = "MainCollectionViewCell"
let collectionViewCellHeightCoefficient: CGFloat = 1.1
let collectionViewCellWidthCoefficient: CGFloat = 0.7

protocol MainControllerDelegate: class {
    func handleMenuToggle()
}

class MainViewController: UIViewController {
    
    //MARK: - Properties
    var user: User?
    
    var exhibitions = [ExhibitionDetail]()
    
    weak var delegate: MainControllerDelegate?
    private var buttonIsActive: Bool = false
    
    private let menuButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "menu").withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .mainPurple
        button.setDimensions(width: 32, height: 20)
        button.addTarget(self, action: #selector(handleMenuAction), for: .touchUpInside)
    
        return button
    }()
    
    private let searchButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "search").withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .mainPurple
        button.setDimensions(width: 22, height: 24)
        button.addTarget(self, action: #selector(handleSearchAction), for: .touchUpInside)

        return button
    }()

    private let uploadButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "add").withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .mainPurple
        button.setDimensions(width: 32, height: 32)
        button.addTarget(self, action: #selector(handleUploadAction), for: .touchUpInside)

        return button
    }()
    
    private let addArtworkButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "addArtwork").withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .mainPurple
        button.setDimensions(width: 32, height: 32)
        button.addTarget(self, action: #selector(handleAddArtwork), for: .touchUpInside)
        button.alpha = 0
        
        return button
    }()
    
    private let addExhibitionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "addExhibition").withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .mainPurple
        button.setDimensions(width: 32, height: 32)
        button.addTarget(self, action: #selector(handleAddExhibition), for: .touchUpInside)
        button.alpha = 0
        
        return button
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = GravitySliderFlowLayout(with: CGSize(width: screenWidth * collectionViewCellWidthCoefficient, height: screenWidth * collectionViewCellHeightCoefficient))
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .none
        cv.decelerationRate = UIScrollView.DecelerationRate(rawValue: 0)
        cv.dataSource = self
        cv.delegate = self
        
        return cv
    }()
    
    //MARK: - CellInfoView Properties
    private let userImageView: UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.setDimensions(width: 28, height: 28)
        iv.layer.cornerRadius = 28 / 2
        iv.backgroundColor = .mainDarkGray
        
        return iv
    }()
    
    private lazy var usernameLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        label.textColor = .mainPurple
        label.text = "@Loading user information"
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleShowUserProfile))
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(tap)
        
        return label
    }()
    
    private let followButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Follow", for: .normal)
        button.setTitleColor(.mainPurple, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.mainPurple.cgColor
        button.setDimensions(width: 80, height: 28)
        button.layer.cornerRadius = 28 / 2
        button.addTarget(self, action: #selector(handleFollow), for: .touchUpInside)
        
        return button
    }()
    
    private let exhibitionTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 22)
        label.textColor = .mainPurple
        label.numberOfLines = 3
        label.text = "@Loading exhibition Information"
        
        return label
    }()
    
    private let moreButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("More Exhibition", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .mainPurple
        button.setDimensions(width: 150, height: 40)
        button.layer.cornerRadius = 40 / 2
        button.addTarget(self, action: #selector(handleExhibitionMore), for: .touchUpInside)
        
        return button
    }()
    
    //MARK: - Init
    init(user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        fetchExhibitions()
    }
    
    //MARK: - API
    func fetchExhibitions() {
        ExhibitionService.shared.fetchExhibitions { exhibitions in
            self.exhibitions = exhibitions
            
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    //MARK: - Selectors
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
    
    @objc func handleMenuAction() {
        delegate?.handleMenuToggle()
    }
    
    @objc func handleSearchAction() {
        let controller = SearchController()
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
    
    @objc func handleAddArtwork() {
        guard let user = user else { return }
        let controller = AddArtworkController(user: user)
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
    
    @objc func handleAddExhibition() {
        guard let user = user else { return }
        let controller = AddExhibitionController(user: user)
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
    
    @objc func handleExhibitionMore() {
        print("DEBUG: More Exhibition..")
    }
    
    @objc func handleShowUserProfile() {
        guard let user = user else { return }
        let controller = UserProfileController(user: user)
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true, completion: nil)
    }
    
    @objc func handleFollow() {
        print("DEBUG: handle follow..")
    }
    
    //MARK: - Helper
    func configureUI() {
        view.backgroundColor = .mainBackground
        view.addSubview(collectionView)
        collectionView.addConstraintsToFillView(view)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(MainCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        view.addSubview(menuButton)
        menuButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, paddingTop: 16, paddingLeft: 16)
        
        view.addSubview(searchButton)
        searchButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, right: view.rightAnchor, paddingTop: 16, paddingRight: 16)
        
        view.addSubview(exhibitionTitleLabel)
        exhibitionTitleLabel.anchor(top: menuButton.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 26, paddingLeft: 16, paddingRight: 12)
        
        view.addSubview(userImageView)
        userImageView.anchor(top: exhibitionTitleLabel.bottomAnchor, left: view.leftAnchor, paddingTop: 12, paddingLeft: 12)
        
        view.addSubview(usernameLabel)
        usernameLabel.anchor(left: userImageView.rightAnchor, paddingLeft: 8)
        usernameLabel.centerY(inView: userImageView)
        
        view.addSubview(followButton)
        followButton.anchor(right: view.rightAnchor, paddingRight: 16)
        followButton.centerY(inView: userImageView)

        view.addSubview(moreButton)
        moreButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, paddingBottom: 40)
        moreButton.centerX(inView: view)
        
        view.addSubview(uploadButton)
        uploadButton.centerX(inView: searchButton)
        uploadButton.centerY(inView: moreButton)
        
        view.addSubview(addExhibitionButton)
        addExhibitionButton.centerX(inView: uploadButton)
        addExhibitionButton.anchor(bottom: uploadButton.topAnchor, paddingBottom: 26)
        
        view.addSubview(addArtworkButton)
        addArtworkButton.centerX(inView: uploadButton)
        addArtworkButton.anchor(bottom: addExhibitionButton.topAnchor, paddingBottom: 20)
    }
    
    func buttonAlpha(alpha: CGFloat) {
        addArtworkButton.alpha = alpha
        addExhibitionButton.alpha = alpha
    }
}


extension MainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return exhibitions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MainCollectionViewCell
        cell.configureData(with: exhibitions[indexPath.row], collectionView: collectionView, index: indexPath.row)
        cell.delegate = self
        
        return cell
    }
}

extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("DEBUG: Selected Cell item..")
        let selectedCell = collectionView.cellForItem(at: indexPath) as! MainCollectionViewCell
        print("DEBUG: \(selectedCell)")
        selectedCell.toggle()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let locationFirst = CGPoint(x: collectionView.center.x + scrollView.contentOffset.x, y: collectionView.center.y + scrollView.contentOffset.y)
        
        if let indexPathFirst = collectionView.indexPathForItem(at: locationFirst), indexPathFirst.row == indexPathFirst.row {
            print("DEBUG: indexPathFirst..")
//            self.animateChangingTitle(for: indexPathFirst)
        }
    }
}


//MARK: - MainCollectionViewCellDelegate
extension MainViewController: MainCollectionViewCellDelegate {
    func itemDismissal(isDismissal: Bool) {
        if isDismissal {
            self.menuButton.alpha = 0
            self.searchButton.isHidden = true
            self.uploadButton.isHidden = true
            self.userImageView.alpha = 0
            self.usernameLabel.alpha = 0
            self.followButton.alpha = 0
            self.exhibitionTitleLabel.alpha = 0
            self.moreButton.alpha = 0
        } else {
            self.menuButton.alpha = 1
            self.searchButton.isHidden = false
            self.uploadButton.isHidden = false
            self.userImageView.alpha = 1
            self.usernameLabel.alpha = 1
            self.followButton.alpha = 1
            self.exhibitionTitleLabel.alpha = 1
            self.moreButton.alpha = 1
        }
    }
    
    func handleShowDetail(artwork: ArtworkDetail) {
        print("DEBUG: show Detail in main controller")
        let controller = ArtworkDetailController()
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        controller.artwork = artwork
        present(nav, animated: true, completion: nil)
    }
}
