//
//  ArtworkEditController.swift
//  ArtScreen_final
//
//  Created by Heng on 2021/2/19.
//

import UIKit

class ArtworkEditController: UIViewController {
    
    //MARK: - Properties
    var artwork: ArtworkDetail?
    
    private let sendButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.black, for: .normal)
        button.setImage(#imageLiteral(resourceName: "Send"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(tapbuttonSendImage), for: .touchUpInside)
        return button
    }()
    
    lazy var artworkImageView : UIImageView = {
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
    init(artwork: ArtworkDetail) {
        self.artwork = artwork
        super.init(nibName: nil, bundle: nil)
        configureData(artwork: artwork)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigation()
        configureUI()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    //MARK: - Selectors
    @objc func tapbuttonSendImage() {
        
    }
    
    @objc func handleDismissal() {
        dismiss(animated: true, completion: nil)
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
    func configureNavigation() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "Send").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(tapbuttonSendImage))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(handleDismissal))
        navigationItem.leftBarButtonItem?.tintColor = .white
    }
    
    func configureUI() {
        view.backgroundColor = .black
        view.addSubview(artworkImageView)
        artworkImageView.anchor(top: view.safeAreaLayoutGuide.topAnchor)
        artworkImageView.centerX(inView: view)
        artworkImageView.setDimensions(width: screenWidth, height: screenWidth)
        
        let titleStack = UIStackView(arrangedSubviews: [titleLabel, titleTextField])
        titleStack.axis = .vertical
        titleStack.spacing = 4
        view.addSubview(titleStack)
        titleStack.anchor(top: artworkImageView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 20, paddingLeft: 16, paddingRight: 16)
        
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
    
    func configureData(artwork: ArtworkDetail) {
        artworkImageView.sd_setImage(with: artwork.path)
        titleTextField.text = artwork.artworkName
        introductionTextField.text = artwork.information
    }
}

extension ArtworkEditController: AddLocationControllerDelegate {
    func sendLocationData(name: String, address: String, lat: Double, log: Double) {
        locationLabel.text = name
        locationAddressLabel.text = address
        locationLat = lat
        locationLng = log
    }
}
