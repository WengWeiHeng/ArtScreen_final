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
    var view1 = CameraView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight))
    var view2 = AlbumView(frame: CGRect(x: screenWidth, y: 0, width: screenWidth, height: screenHeight))
    var captureSession: AVCaptureSession!
    var stillImageOutput: AVCapturePhotoOutput!
    var videoPreviewLayer: AVCaptureVideoPreviewLayer!
    
    let buttonCamera : UIButton = {
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
    
    let buttonAlbum : UIButton = {
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
    
    let buttonCancel : UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "close"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleTapButtonCancel), for: .touchUpInside)
        button.setDimensions(width: 24, height: 24)
        
        return button

    }()
    
    let captureImageView : UIImageView = {
        let img = UIImageView()
        
        return img
    }()
    
    //MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isHidden = true
        view.backgroundColor = .black
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
    
    @objc func handleTapButtonCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Helpers
    func setupButton() {
        view.addSubview(buttonCamera)
        view.addSubview(buttonAlbum)
        view.addSubview(buttonCancel)
        
        let stack = UIStackView(arrangedSubviews: [buttonCamera, buttonAlbum])
        stack.axis = .horizontal
        stack.spacing = 16
        
        view.addSubview(stack)
        stack.centerX(inView: view)
        stack.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, paddingBottom: 20)

        buttonCancel.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, paddingTop: 10, paddingLeft: 15, width: 24, height: 24)
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

        scrollView.addSubview(view1)
        scrollView.addSubview(view2)
        view1.delegate = self
        view2.delegate = self
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollView.contentOffset.y = 0.0
    }
    
    func configureAlert(_ image: UIImage) {
        let alert = UIAlertController(title: "Do you want add AR Animation on your ArtWork",message:"If you don't want to add it now, you can click Edit in your profile page", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Not now", style: .default, handler: { _ in
            let viewController =  ArtworkInfoSettingController()
            let resize: CGSize = CGSize.init(width: screenWidth, height:screenWidth)
            let originalImage = image.resize(size: resize)
            viewController.artworkImage = originalImage
            viewController.heightoriginalImageView = originalImage!.size.height
            viewController.widthoriginalImageView = originalImage!.size.width
            self.navigationController?.pushViewController(viewController, animated: true)
        }))
        
        alert.addAction(UIAlertAction(title: "Do it", style: .default, handler: { _ in
            let controller = AnimateController()
            let resize:CGSize = CGSize.init(width: screenWidth, height:screenHeight-240)
            let originalImage = image.resize(size: resize)
            controller.originalImageView.image = originalImage
            controller.heightoriginalImageView = originalImage!.size.height
            controller.widthoriginalImageView = originalImage!.size.width
            controller.sampleImageView.image = originalImage
            self.navigationController?.pushViewController(controller, animated: true)
        }))

        self.present(alert, animated: true, completion: nil)
    }
}

//MARK: - CamereViewDelegate
extension AddArtworkController: CameraViewDelegate {
    func presentPhotoCheck(_ image: UIImage) {
        let controller = ConfirmImageController()
        controller.image.image = image
        self.navigationController?.pushViewController(controller, animated: true)

    }
}

//MARK: - AlbumViewDelegate
extension AddArtworkController: AlbumViewDelegate {
    
    func uploadArtwork(_ image: UIImage) {
        self.configureAlert(image)
    }
}
