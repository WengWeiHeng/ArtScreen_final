//
//  ExhibitionEditController.swift
//  ArtScreen_final
//
//  Created by Heng on 2020/10/28.
//

import UIKit

class ExhibitionEditController: UIViewController {
    
    //MARK: - Properties
    var exhibition: ExhibitionDetail?
    var exhibitionCallBack: ((ExhibitionDetail) -> Void)?
    
    private let imagePicker = UIImagePickerController()
    private var changeImage: UIImage?
    
    private let basicLabel: UILabel = {
        let label = AddExhibitionUtilities().customTitleLebael(titleText: "Basic", textColor: .mainPurple)
        
        return label
    }()
    
    private let privacyLabel: UILabel = {
        let label = AddExhibitionUtilities().customTitleLebael(titleText: "Privacy", textColor: .mainPurple)
        
        return label
    }()
    
    private lazy var exhibitionImageView: UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.setDimensions(width: 100, height: 100)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(selectExhibitionImage))
        iv.isUserInteractionEnabled = true
        iv.addGestureRecognizer(tap)
        
        return iv
    }()
    
    private let exhibitionTitleLabel: UILabel = {
        let label = AddExhibitionUtilities().customLabel(title: "Exhibition Name", color: .mainPurple)
        
        return label
    }()
    
    private let exhibitionTitleTextView: UITextView = {
        let tv = AddExhibitionUtilities().customTestView(fontSize: 15, textColor: .mainPurple)
        tv.setHeight(height: 60)
        
        
        return tv
    }()
    
    private let introduceLabel: UILabel = {
        let label = AddExhibitionUtilities().customLabel(title: "Introduce", color: .mainPurple)
        
        return label
    }()
    
    private let introduceTextView: UITextView = {
        let tv = AddExhibitionUtilities().customTestView(fontSize: 15, textColor: .mainPurple)
        tv.setDimensions(width: screenWidth, height: 60)
        
        return tv
    }()
    
    //MARK: - Init
    init(exhibition: ExhibitionDetail) {
        self.exhibition = exhibition
        super.init(nibName: nil, bundle: nil)
        configureDate()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    //MARK: - API
    func updateExhibition() {
        guard let exhibition = exhibition else { return }
        guard let exhibitionName = exhibitionTitleTextView.text else { return }
        guard let information = introduceTextView.text else { return }
        
        let credential = UpdateExhibitionCredentials(exhibitionID: exhibition.exhibitionID, exhibitionName: exhibitionName, information: information, privacy: 0)
        
        ExhibitionService.shared.updateExhibition(credentials: credential)
        
        dismiss(animated: true) {
            guard let exhibition = self.exhibition else { return }
            ExhibitionService.shared.fetchExhibitionCallBack(exhibition: exhibition) { (exhibition) in
                self.exhibitionCallBack?(exhibition)
            }
        }
    }
    
    //MARK: - Selectors
    @objc func handleDone() {
        let alert = UIAlertController(title: "Upload new information", message:"Are you sure to change your exhibition information?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "No", style: .default, handler: { _ in
            print("DEBUG: 編集続ける")
        }))
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { _ in
            // exhibition update function
            self.updateExhibition()
        }))

        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func selectExhibitionImage() {
        print("DEBUG: select image..")
        present(imagePicker, animated: true, completion: nil)
    }
    
    //MARK: - Helpers
    func configureUI() {
        view.backgroundColor = .mainBackground
        configureNavigationBar()
        configureImagePicker()
        
        let titleStack = UIStackView(arrangedSubviews: [exhibitionTitleLabel, exhibitionTitleTextView])
        titleStack.axis = .vertical
        titleStack.spacing = 4
        
        let imageStack = UIStackView(arrangedSubviews: [exhibitionImageView, titleStack])
        imageStack.axis = .horizontal
        imageStack.spacing = 12
        imageStack.alignment = .top
        
        let introduceStack = UIStackView(arrangedSubviews: [introduceLabel, introduceTextView])
        introduceStack.axis = .vertical
        introduceStack.spacing = 4
        
        let allStack = UIStackView(arrangedSubviews: [imageStack, introduceStack])
        allStack.axis = .vertical
        allStack.spacing = 10
        
        view.addSubview(basicLabel)
        basicLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, paddingTop: 12, paddingLeft: 16)
        
        view.addSubview(allStack)
        allStack.anchor(top: basicLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 12, paddingLeft: 16, paddingRight: 16)
        
        view.addSubview(privacyLabel)
        privacyLabel.anchor(top: allStack.bottomAnchor, left: view.leftAnchor, paddingTop: 20, paddingLeft: 16)
    }
    
    func configureNavigationBar() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.mainPurple]
        navigationItem.title = "Edit"
        
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(handleDone))
        navigationItem.rightBarButtonItem?.tintColor = .mainPurple
    }
    
    func configureDate() {
        guard let exhibition = exhibition else { return }
        DispatchQueue.main.async {
            self.exhibitionImageView.sd_setImage(with: exhibition.path)
            self.exhibitionTitleTextView.text = exhibition.exhibitionName
            self.introduceTextView.text = exhibition.information
        }
    }
    
    func configureImagePicker() {
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
    }
}

//MARK: - UIImagePickerControllerDelegate
extension ExhibitionEditController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let changeImage = info[.editedImage] as? UIImage else { return }
        self.changeImage = changeImage
        
        exhibitionImageView.image = changeImage
//        coverImageButton.setImage(changeImage.withRenderingMode(.alwaysOriginal), for: .normal)
        
        dismiss(animated: true, completion: nil)
    }
}
