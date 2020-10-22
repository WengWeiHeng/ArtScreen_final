//
//  MainViewController.swift
//  ArtScreen_final
//
//  Created by Heng on 2020/10/21.
//

import UIKit

protocol MainControllerDelegate: class {
    func handleMenuToggle()
}

class MainViewController: UIViewController {
    
    //MARK: - Properties
    weak var delegate: MainControllerDelegate?
    
    private let menuButton: UIButton = {
         let button = UIButton(type: .system)
         button.setImage(#imageLiteral(resourceName: "menu").withRenderingMode(.alwaysOriginal), for: .normal)
         button.setDimensions(width: 32, height: 20)
         button.addTarget(self, action: #selector(handleMenuAction), for: .touchUpInside)
        
         return button
     }()
    
    private let searchButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "search").withRenderingMode(.alwaysOriginal), for: .normal)
        button.setDimensions(width: 22, height: 24)
        button.addTarget(self, action: #selector(handleSearchAction), for: .touchUpInside)

        return button
    }()

    private let uploadButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "add").withRenderingMode(.alwaysOriginal), for: .normal)
        button.setDimensions(width: 24, height: 24)
        button.addTarget(self, action: #selector(handleUploadAction), for: .touchUpInside)

        return button
    }()
    
    private lazy var addArtworkView: UIView = {
        let view = Utilities().buttonContainerView(withImage: #imageLiteral(resourceName: "addArtwork"), title: "ARTWORK")
        view.alpha = 0
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleAddArtwork))
        view.addGestureRecognizer(tap)
        
        return view
    }()
    
    private lazy var addExhibitionView: UIView = {
        let view = Utilities().buttonContainerView(withImage: #imageLiteral(resourceName: "addExhibition"), title: "EXHIBITION")
        view.alpha = 0
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleAddExhibition))
        view.addGestureRecognizer(tap)
        
        return view
    }()
    
    private let blackButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .mainDarkGray
        button.alpha = 0
        button.addTarget(self, action: #selector(handleDismissal), for: .touchUpInside)
        
        return button
    }()
    
    private let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .mainBackground
        button.setImage(#imageLiteral(resourceName: "close").withRenderingMode(.alwaysTemplate), for: .normal)
        button.imageView?.setDimensions(width: 15, height: 15)
        button.tintColor = .mainPurple
        button.setDimensions(width: 40, height: 40)
        button.layer.cornerRadius = 40 / 2
        button.addTarget(self, action: #selector(handleDismissal), for: .touchUpInside)
        button.alpha = 0
        
        return button
    }()
    
    
    //MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    //MARK: - Selectors
    @objc func handleMenuAction() {
        delegate?.handleMenuToggle()
    }
    
    @objc func handleSearchAction() {
        print("DEBUG: Search..")
    }
    
    @objc func handleUploadAction() {
        UIView.animate(withDuration: 0.4) {
            self.blackButton.alpha = 0.75
            self.addArtworkView.alpha = 1
            self.addExhibitionView.alpha = 1
            self.closeButton.alpha = 1
        }
    }
    
    @objc func handleDismissal() {
        UIView.animate(withDuration: 0.4) {
            self.blackButton.alpha = 0
            self.addArtworkView.alpha = 0
            self.addExhibitionView.alpha = 0
            self.closeButton.alpha = 0
        }
    }
    
    @objc func handleAddArtwork() {
        extractedFunc(animateTime: 0.4)
        
        let controller = AddArtworkController()
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
    
    @objc func handleAddExhibition() {
        extractedFunc(animateTime: 0.4)
        
        let controller = AddExhibitionController()
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
    
    //MARK: - Helper
    func configureUI() {
        view.backgroundColor = .mainBackground

        view.addSubview(menuButton)
        menuButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, paddingTop: 16, paddingLeft: 12)
        
        let stack = UIStackView(arrangedSubviews: [searchButton, uploadButton])
        stack.spacing = 15
        
        view.addSubview(stack)
        stack.centerY(inView: menuButton)
        stack.anchor(right: view.rightAnchor, paddingRight: 12)
        
        configureAddView()
    }
    
    func configureAddView() {
        view.addSubview(blackButton)
        blackButton.addConstraintsToFillView(view)
        
        view.addSubview(closeButton)
        closeButton.centerX(inView: view)
        closeButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, paddingBottom: 20)
        
        view.addSubview(addArtworkView)
        addArtworkView.anchor(left: view.leftAnchor, bottom: closeButton.topAnchor, paddingLeft: 12, paddingBottom: 20)
        
        view.addSubview(addExhibitionView)
        addExhibitionView.anchor(bottom: addArtworkView.bottomAnchor, right: view.rightAnchor, paddingRight: 12)
        
        let size = (view.frame.width - 36) / 2
        addArtworkView.setDimensions(width: size, height: size)
        addExhibitionView.setDimensions(width: size, height: size)
    }

    
    fileprivate func extractedFunc(animateTime: TimeInterval) {
        UIView.animate(withDuration: animateTime) {
            self.blackButton.alpha = 0
            self.addArtworkView.alpha = 0
            self.addExhibitionView.alpha = 0
            self.closeButton.alpha = 0
        }
    }
    
}
