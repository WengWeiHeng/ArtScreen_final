//
//  AAController.swift
//  ArtScreen_final
//
//  Created by Heng on 2020/10/23.
//

import UIKit

class ArtworkInfoSettingController: UIViewController {
    
    //MARK: - Properties
    var user: User?
    
    var customProtocol: CustomProtocol?
    var itemCredentials : ArtworkItemCredentials?
    var artworkImage: UIImage?
    var itemImage: UIImage?
    var heightoriginalImageView: CGFloat!
    var widthoriginalImageView: CGFloat!
    var artworkImageWidth: CGFloat!
    var artworkImageHeight: CGFloat!
    
    let navigationBarView : UIView = {
        let view = UIView()
        let buttonPhotoLibrary : UIButton = {
            let button = UIButton()
            button.setTitleColor(.black, for: .normal)
            button.setImage(#imageLiteral(resourceName: "photo"), for: .normal)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.addTarget(self, action: #selector(tapbuttonPhotoLibrary), for: .touchUpInside)
            return button
        }()
        
        let buttonSendImage : UIButton = {
            let button = UIButton()
            button.setTitleColor(.black, for: .normal)
            button.setImage(#imageLiteral(resourceName: "Send"), for: .normal)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.addTarget(self, action: #selector(tapbuttonSendImage), for: .touchUpInside)
            return button
        }()
        
        view.addSubview(buttonPhotoLibrary)
        view.addSubview(buttonSendImage)
        buttonPhotoLibrary.anchor(top: view.topAnchor, left: view.leftAnchor, paddingLeft: 12, width: 70, height: 40)
        buttonSendImage.anchor(top: view.topAnchor, right: view.rightAnchor, paddingRight: 12, width: 70, height: 40)
        return view
    }()
    
    lazy var imageView : UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .white
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = AddExhibitionUtilities().customLabel(title: "Artwork Name", color: .white)
        
        return label
    }()
    
    private let titleTextField: UITextField = {
        let tf = AddExhibitionUtilities().customTextField(placeholder: "Name", textColor: .white)
        
        return tf
    }()
    
    private let introductionLabel: UILabel = {
        let label = AddExhibitionUtilities().customLabel(title: "Introduction", color: .white)
        
        return label
    }()
    
    private let introductionTextField: UITextField = {
        let tf = AddExhibitionUtilities().customTextField(placeholder: "Introduction", textColor: .white)
        
        return tf
    }()
    
    
    //MARK: - Location Properties
    private var locationLat: Double = 0.0
    private var locationLng: Double = 0.0
    
    private lazy var addLocationView: UIView = {
        let view = UIView()
        
        let iconIV = UIImageView()
        iconIV.clipsToBounds = true
        iconIV.contentMode = .scaleAspectFit
        iconIV.image = #imageLiteral(resourceName: "Next")
        iconIV.setDimensions(width: 16, height: 16)
        
        let stack = UIStackView(arrangedSubviews: [locationLabel, locationAddressLabel])
        stack.axis = .vertical
        stack.spacing = 4
        
        view.addSubview(iconIV)
        iconIV.centerY(inView: view)
        iconIV.anchor(right: view.rightAnchor)
        
        view.addSubview(stack)
        stack.centerY(inView: view)
        stack.anchor(left: view.leftAnchor, right: iconIV.rightAnchor, paddingRight: 12)
        
        return view
    }()
    
    private let locationLabel: UILabel = {
        let label = AddExhibitionUtilities().customLabel(title: "Location", color: .white)
        
        return label
    }()
    
    private let locationAddressLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .mainAlphaGray
        label.numberOfLines = 1
        label.text = "Where are your artwork?"
        
        return label
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
        view.backgroundColor = .black
        configure()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    //MARK: - Selectors
    @objc func tapbuttonPhotoLibrary() {
        for controller in self.navigationController!.viewControllers as Array {
            if controller.isKind(of: AddArtworkController.self) {
                self.navigationController!.popToViewController(controller, animated: true)
                break
            }
        }
    }
    
    @objc func tapbuttonSendImage() {
        guard let artworkname = titleTextField.text else { return }
        guard let information = introductionTextField.text else { return }
        guard let artworkImage = artworkImage else { return }
        guard let width = artworkImageWidth else { return }
        guard let height = artworkImageHeight else { return }
        
        guard let user = user else { return }

        let credentials = ArtworkCredentials(artworkName: artworkname, information: information, artworkImage: artworkImage, width: Float(width), height: Float(height), lat: locationLat, lng: locationLng)
        
        showLoader(true, withText: "Loading..")
        
        if itemCredentials == nil {
            ArtworkService.shared.uploadArtwork(artworkCredentials: credentials, user: user)
        } else {
            ArtworkService.shared.uploadArtwork(artworkCredentials: credentials, user: user, artworkItemCredentials: itemCredentials)
        }
        dismiss(animated: true) {
            self.showLoader(false)
        }
        
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight = keyboardSize.height
            if view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardHeight
            }
        }
    }
    
    @objc func keyboardWillHide() {
        if view.frame.origin.y != 0 {
            view.frame.origin.y = 0
        }
    }
    
    @objc func addLocation() {
        let controller = AddLocationController()
        controller.delegate = self
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
    
    //MARK: - Helpers
    func configure() {
        view.addSubview(navigationBarView)
        navigationBarView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 10, height: 40)
        
        let centerView = UIView()
        view.addSubview(centerView)
        centerView.anchor(top: navigationBarView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 15, height: screenWidth)
        
        view.addSubview(imageView)
        imageView.anchor(top: centerView.topAnchor)
        imageView.centerX(inView: centerView)
        imageView.setDimensions(width: widthoriginalImageView, height: heightoriginalImageView)
        imageView.image = artworkImage
        
        let titleStack = UIStackView(arrangedSubviews: [titleLabel, titleTextField])
        titleStack.axis = .vertical
        titleStack.spacing = 4
        view.addSubview(titleStack)
        titleStack.anchor(top: imageView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 20, paddingLeft: 16, paddingRight: 16)
        
        let introductionStack = UIStackView(arrangedSubviews: [introductionLabel, introductionTextField])
        introductionStack.axis = .vertical
        introductionStack.spacing = 4
        
        view.addSubview(introductionStack)
        introductionStack.anchor(top: titleStack.bottomAnchor, left: titleStack.leftAnchor, right: titleStack.rightAnchor, paddingTop: 20)
        
        view.addSubview(addLocationView)
        addLocationView.anchor(top: introductionStack.bottomAnchor, left: introductionStack.leftAnchor, right: introductionStack.rightAnchor, paddingTop: 20, height: 40)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(addLocation))
        addLocationView.addGestureRecognizer(tap)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}

extension ArtworkInfoSettingController: AddLocationControllerDelegate {
    func sendLocationData(name: String, address: String, lat: Double, log: Double) {
        locationLabel.text = name
        locationAddressLabel.text = address
        locationLat = lat
        locationLng = log
    }
}
