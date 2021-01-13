//
//  AddArtworkController.swift
//  ArtScreen_final
//
//  Created by Heng on 2020/10/22.
//

import UIKit

import UIKit
import AVFoundation

class AddArtworkController: UIViewController, UIScrollViewDelegate {
    
    //MARK: - Properties
    var user: User?
    private var scrollView : UIScrollView!
    var cameraView = CameraView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight))
    var albumView = AlbumView(frame: CGRect(x: screenWidth, y: 0, width: screenWidth, height: screenHeight))
    var captureSession: AVCaptureSession!
    var stillImageOutput: AVCapturePhotoOutput!
    var videoPreviewLayer: AVCaptureVideoPreviewLayer!
    let captureImageView = UIImageView()
    
    private let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "close"), for: .normal)
        button.setDimensions(width: 30, height: 30)
        button.addTarget(self, action: #selector(handleDismissal), for: .touchUpInside)
        
        return button
    }()
    
    let buttonCamera: UIButton = {
        let button = UIButton()
        button.backgroundColor = .mainPurple
        button.setTitleColor(.white, for: .normal)
        button.setTitle("CAMERA", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 14)
        button.layer.masksToBounds = true
        button.setDimensions(width: 100, height: 40)
        button.layer.cornerRadius = 40 / 2
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleTapButtonCamera), for: .touchUpInside)

        return button
    }()
    
    let buttonAlbum: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.setTitleColor(.black, for: .normal)
        button.setTitle("ALBUM", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 14)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.masksToBounds = true
        button.setDimensions(width: 100, height: 40)
        button.layer.cornerRadius = 40 / 2
        button.addTarget(self, action: #selector(handleTapButtonAlbum), for: .touchUpInside)
        
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
        
        configureNavigationBar()
        configureScrollView()
        setupButton()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: - Selectors
    @objc func handleTapButtonAlbum() {
        print("Tap Button Album")
        if scrollView.contentOffset.x == 0 {
            scrollView.contentOffset.x +=  self.view.bounds.width
            buttonAlbum.backgroundColor = .mainPurple
            buttonAlbum.setTitleColor(.white, for: .normal)
            buttonCamera.backgroundColor = .white
            buttonCamera.setTitleColor(.black, for: .normal)
        }
    }
    
    @objc func handleTapButtonCamera() {
        print("Tap Button Camera")
        if scrollView.contentOffset.x > 0 {
            scrollView.contentOffset.x -=  self.view.bounds.width
            buttonCamera.backgroundColor = .mainPurple
            buttonCamera.setTitleColor(.white, for: .normal)
            buttonAlbum.backgroundColor = .white
            buttonAlbum.setTitleColor(.black, for: .normal)
        }
    }
    
    @objc func handleDismissal() {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Helpers
    func configureNavigationBar() {
        view.backgroundColor = .black
        navigationController?.navigationBar.isHidden = true
    }
    
    func setupButton() {
        view.addSubview(buttonCamera)
        view.addSubview(buttonAlbum)
        
        view.addSubview(closeButton)
        closeButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, paddingTop: 10, paddingLeft: 12)
        
        let stack = UIStackView(arrangedSubviews: [buttonCamera, buttonAlbum])
        stack.axis = .horizontal
        stack.spacing = 16
        
        view.addSubview(stack)
        stack.centerX(inView: view)
        stack.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, paddingBottom: 20)
    }
    
    func configureScrollView() {
        scrollView = UIScrollView(frame: self.view.frame)
        let pageSize = 2
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.isPagingEnabled = true
        scrollView.delegate = self
        scrollView.contentSize = CGSize(width: CGFloat(pageSize) * screenWidth, height: screenHeight)
        view.addSubview(scrollView)

        scrollView.addSubview(cameraView)
        scrollView.addSubview(albumView)
        cameraView.delegate = self
        albumView.delegate = self
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        // スクロール数が1ページ分になったら時.
        if fmod(scrollView.contentOffset.x, scrollView.frame.maxX) == 0 {
            // ページの場所を切り替える.
            let page = Int(scrollView.contentOffset.x / scrollView.frame.maxX)
            if page == 0 {
                buttonCamera.backgroundColor = .mainPurple
                buttonCamera.setTitleColor(.white, for: .normal)
                buttonAlbum.backgroundColor = .white
                buttonAlbum.setTitleColor(.black, for: .normal)
            } else {
                buttonAlbum.backgroundColor = .mainPurple
                buttonAlbum.setTitleColor(.white, for: .normal)
                buttonCamera.backgroundColor = .white
                buttonCamera.setTitleColor(.black, for: .normal)
            }
        }
    }
    
    func configureAlert(_ image: UIImage) {
        let alert = UIAlertController(title: "Do you want add AR Animation on your ArtWork",message:"If you don't want to add it now, you can click Edit in your profile page", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Not now", style: .default, handler: { _ in
            guard let user = self.user else { return }
            let viewController =  ArtworkInfoSettingController(user: user)
            let resize: CGSize = CGSize.init(width: screenWidth, height: screenWidth)
            let originalImage = image.resize(size: resize)
            viewController.artworkImage = originalImage
            viewController.heightoriginalImageView = originalImage!.size.height
            viewController.widthoriginalImageView = originalImage!.size.width
            self.navigationController?.pushViewController(viewController, animated: true)
        }))
        
        alert.addAction(UIAlertAction(title: "Do it", style: .default, handler: { _ in
            guard let user = self.user else { return }
            let controller = AnimateController(user: user)
            let resize:CGSize = CGSize.init(width: screenWidth, height:screenHeight - 240)
            let originalImage = image.resize(size: resize)
            controller.originalImageView.image = originalImage
            controller.heightoriginalImageView = originalImage!.size.height
            controller.widthoriginalImageView = originalImage!.size.width
            controller.sampleImageView.image = originalImage
            self.navigationController?.pushViewController(controller, animated: true)
        }))

        self.present(alert, animated: true, completion: nil)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollView.contentOffset.y = 0.0
    }
}

//MARK: - CameraViewDelegate
extension AddArtworkController: CameraViewDelegate {
    func presentPhotoCheck(_ image: UIImage) {
        guard let user = user else { return }
        let controller = ConfirmImageController(user: user)
        controller.image.image = image
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)

    }
}

//MARK: - AlbumViewDelegate
extension AddArtworkController: AlbumViewDelegate {
    func uploadArtwork(_ image: UIImage) {
        self.configureAlert(image)
    }
}
