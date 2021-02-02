//
//  ExhibitionUploadController.swift
//  ArtScreen_final
//
//  Created by Heng on 2020/10/23.
//

import UIKit
import WaterfallLayout

private let reuseIdenfitier = "ArtworkInputViewCell"

class ExhibitionUploadController: UIViewController {
    
    //MARK: - Properties
    var user: User?
    
    private var artworks = [ArtworkDetail]()
    private var selectedArtwork = [ArtworkDetail]()
    var exhibitionID: String!
    
    var exhibitionTitleText: String?
    
    private let addArtworkInputView = AddArtworkInputView()
    private let exhibitionSettingView = ExhibitionSettingView()
    private let exhibitionSendView = ExhibitionSendView()
    
    private var inputViewBottom = NSLayoutConstraint()
    private var settingViewBottom = NSLayoutConstraint()
    private var sendViewBottom = NSLayoutConstraint()
    
    private let inputViewHeight: CGFloat = 350
    private let settingViewHeight: CGFloat = 250
    private let sendViewHeight: CGFloat = screenHeight * 0.5
    
    private lazy var customNavigationBarView: UIView = {
        let view = UIView()
        
        let leftButton = UIButton(type: .system)
        leftButton.setTitle("Done", for: .normal)
        leftButton.setTitleColor(.white, for: .normal)
        leftButton.titleLabel?.font = .boldSystemFont(ofSize: 18)
        leftButton.addTarget(self, action: #selector(handleDoneAction), for: .touchUpInside)
        
        let rightButton = UIButton(type: .system)
        rightButton.setImage(#imageLiteral(resourceName: "more"), for: .normal)
        rightButton.addTarget(self, action: #selector(handleEditMoreAction), for: .touchUpInside)
        rightButton.tintColor = .white
        
        view.addSubview(leftButton)
        leftButton.anchor(left: view.leftAnchor, paddingLeft: 16)
        leftButton.centerY(inView: view)
        
        view.addSubview(rightButton)
        rightButton.centerY(inView: leftButton)
        rightButton.anchor(right: view.rightAnchor, paddingRight: 16)
        
        return view
    }()
    
    private let exhibitionTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.numberOfLines = 0
        label.textColor = .white
        
        return label
    }()
    
    private let announceView: UIStackView = {
        let stack = Utilities().noArtworkAnnounceView(announceText: "You have not added any Artwork", buttonSelector: #selector(handleShowInputView), buttonText: "Add", textColor: .white)
        
        return stack
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = WaterfallLayout()
        layout.delegate = self
        layout.sectionInset = UIEdgeInsets(top: 0, left: 12, bottom: 12, right: 12)
        layout.minimumLineSpacing = 8.0
        layout.minimumInteritemSpacing = 8.0
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .mainDarkGray
        cv.register(ArtworkInputViewCell.self, forCellWithReuseIdentifier: reuseIdenfitier)
        cv.delegate = self
        cv.dataSource = self
        
        return cv
    }()
    
    private let blackViewButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .black
        button.alpha = 0
        button.addTarget(self, action: #selector(handleDismissal), for: .touchUpInside)
        
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
        fetchExhibitionArtwork()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        navigationController?.navigationBar.isHidden = true
    }
    
    //MARK: - API
    func fetchExhibitionArtwork() {
        guard let exhibitionID = exhibitionID else { return }
        ArtworkService.shared.fetchExhibitionArtwork(forExhibitionID: exhibitionID) { artworks in
            self.artworks = artworks
            DispatchQueue.main.async {
                if !self.artworks.isEmpty {
                    self.announceView.isHidden = true
                } else {
                    self.announceView.isHidden = false
                }
                self.collectionView.reloadData()
            }
        }
    }
    
    //MARK: - Selectors
    @objc func handleDoneAction() {
        print("DEBUG: Done - Access Upload ExhibitionID to Artwork")
        for i in 0..<selectedArtwork.count {
            let updateExhibitionID = UpdateArtworkID_Exhibiton(exhibitionID: exhibitionID, artworkID: selectedArtwork[i].artworkID, userID: selectedArtwork[i].userID)
            ExhibitionService.shared.updateArtworkID(updateArtworkID: updateExhibitionID)
        }
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleEditMoreAction() {
        let transitionAnimator = UIViewPropertyAnimator(duration: 0.6, dampingRatio: 1) {
            self.blackViewButton.alpha = 0.75
            self.settingViewBottom.constant = 0
            self.view.layoutIfNeeded()
        }
        transitionAnimator.startAnimation()
    }
    
    @objc func handleDismissal() {
        let transitionAnimator = UIViewPropertyAnimator(duration: 0.6, dampingRatio: 1) {
            self.blackViewButton.alpha = 0
            self.inputViewBottom.constant = self.inputViewHeight
            self.settingViewBottom.constant = self.settingViewHeight
            self.sendViewBottom.constant = self.sendViewHeight
            self.view.layoutIfNeeded()
        }
        transitionAnimator.startAnimation()
    }
    
    @objc func handleShowInputView() {
        let transitionAnimator = UIViewPropertyAnimator(duration: 0.6, dampingRatio: 1) {
            self.blackViewButton.alpha = 0.75
            self.inputViewBottom.constant = 0
            self.view.layoutIfNeeded()
        }
        transitionAnimator.startAnimation()
    }
    
    //MARK: - Helpers
    func configureUI() {
        view.backgroundColor = .mainDarkGray
        view.addSubview(customNavigationBarView)
        customNavigationBarView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 10, height: 30)

        view.addSubview(exhibitionTitleLabel)
        exhibitionTitleLabel.anchor(top: customNavigationBarView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 20, paddingLeft: 16, paddingRight: 16)
        exhibitionTitleLabel.text = exhibitionTitleText

        view.addSubview(collectionView)
        collectionView.anchor(top: exhibitionTitleLabel.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 20)
        
        view.addSubview(blackViewButton)
        blackViewButton.addConstraintsToFillView(view)
        
        configureInputView()
        configureAnnounceView()
    }
    
    func configureAnnounceView() {
        view.addSubview(announceView)
        announceView.centerX(inView: view)
        announceView.centerY(inView: view)
    }
    
    func configureInputView() {
        view.addSubview(addArtworkInputView)
        addArtworkInputView.translatesAutoresizingMaskIntoConstraints = false
        addArtworkInputView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        addArtworkInputView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        inputViewBottom = addArtworkInputView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: inputViewHeight)
        inputViewBottom.isActive = true
        addArtworkInputView.heightAnchor.constraint(equalToConstant: inputViewHeight).isActive = true
        addArtworkInputView.layer.cornerRadius = 24
        addArtworkInputView.delegate = self
        addArtworkInputView.user = user
        
        view.addSubview(exhibitionSettingView)
        exhibitionSettingView.translatesAutoresizingMaskIntoConstraints = false
        exhibitionSettingView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        exhibitionSettingView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        settingViewBottom = exhibitionSettingView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: settingViewHeight)
        settingViewBottom.isActive = true
        exhibitionSettingView.heightAnchor.constraint(equalToConstant: settingViewHeight).isActive = true
        exhibitionSettingView.delegate = self
        
        view.addSubview(exhibitionSendView)
        exhibitionSendView.translatesAutoresizingMaskIntoConstraints = false
        exhibitionSendView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        exhibitionSendView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        sendViewBottom = exhibitionSendView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: sendViewHeight)
        sendViewBottom.isActive = true
        exhibitionSendView.heightAnchor.constraint(equalToConstant: sendViewHeight).isActive = true
        exhibitionSendView.layer.cornerRadius = 24
        exhibitionSendView.delegate = self
    }
}

//MARK: - UICollectionViewDataSource
extension ExhibitionUploadController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return artworks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdenfitier, for: indexPath) as! ArtworkInputViewCell
        cell.artwork = artworks[indexPath.row]
        
        return cell
    }
}

//MARK: - WaterfallLayoutDelegate
extension ExhibitionUploadController: WaterfallLayoutDelegate {
    func collectionViewLayout(for section: Int) -> WaterfallLayout.Layout {
        return .waterfall(column: 2, distributionMethod: .balanced)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout: WaterfallLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return WaterfallLayout.automaticSize
    }
}

//MARK: - AddArtworkInputViewDelegate
extension ExhibitionUploadController: AddArtworkInputViewDelegate {
    func AddInArtwork(artwork: ArtworkDetail) {
        print("DEBUG: Artwork is remove successfully and add in this exhibition..")
//
        UIView.animate(withDuration: 0.3) {
            self.announceView.alpha = 0
            self.view.layoutIfNeeded()
        }
//
        self.selectedArtwork.append(artwork)
        self.artworks.append(artwork)
        self.collectionView.reloadData()
    }
    
    func moveToAddArtworkController() {
        guard let user = user else { return }
        let controller = AddArtworkController(user: user)
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true, completion: nil)
    }
    
    func handleCloseInputView() {
        handleDismissal()
    }
}

//MARK: - ExhibitionSettingViewDelegate
extension ExhibitionUploadController: ExhibitionSettingViewDelegate {
    func didTappedNewArtwork() {
        let transitionAnimator = UIViewPropertyAnimator(duration: 0.8, dampingRatio: 1) {
            self.settingViewBottom.constant = self.settingViewHeight
            self.handleShowInputView()
        }
        transitionAnimator.startAnimation()
    }
    
    func didTappedEditInfo() {
        guard let exhibitionID = exhibitionID else { return }
        let controller = ExhibitionEditController(exhibitionID: exhibitionID)
        let nav = UINavigationController(rootViewController: controller)
        present(nav, animated: true, completion: nil)
    }
    
    func didTappedSend() {
        print("didTappedSend")
        let transitionAnimator = UIViewPropertyAnimator(duration: 0.6, dampingRatio: 1) {
            self.blackViewButton.alpha = 0.75
            self.sendViewBottom.constant = 0
            self.view.layoutIfNeeded()
        }
        transitionAnimator.startAnimation()
    }
    
    func didTappedCancel() {
        print("didTappedCancel")
        handleDismissal()
    }
}

//MARK: - ExhibitionSendViewDelegate
extension ExhibitionUploadController: ExhibitionSendViewDelegate {
    func didTappedExhibiSetting_Send_cancel() {
        handleDismissal()
    }
}

