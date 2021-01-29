//
//  ExhibitionEditController.swift
//  ArtScreen_final
//
//  Created by Heng on 2020/10/28.
//

import UIKit

class ExhibitionEditController: UIViewController {
    
    var exhibitionID: String?
    var exhibition: ExhibitionDetail?
    
    //MARK: - Properties
    private let basicLabel: UILabel = {
        let label = AddExhibitionUtilities().customTitleLebael(titleText: "Basic", textColor: .mainPurple)
        
        return label
    }()
    
    private let privacyLabel: UILabel = {
        let label = AddExhibitionUtilities().customTitleLebael(titleText: "Privacy", textColor: .mainPurple)
        
        return label
    }()
    
    private let coverImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .mainPurple
        iv.setDimensions(width: 100, height: 100)
        
        return iv
    }()
    
    private let exhibitionTitleLabel: UILabel = {
        let label = AddExhibitionUtilities().customLabel(title: "Exhibition Name", color: .mainPurple)
        
        return label
    }()
    
    private let exhibitionTitleTextView: UITextView = {
        let tv = AddExhibitionUtilities().customTestView(fontSize: 16, textColor: .mainPurple)
        tv.setHeight(height: 100)
        tv.text = "Lorem ipsum dolor sit amet,consectetur adipiscing elit.Mauris fermentum nulla sit ametiaculis. "
        
        return tv
    }()
    
    private let introduceLabel: UILabel = {
        let label = AddExhibitionUtilities().customLabel(title: "Introduce", color: .mainPurple)
        
        return label
    }()
    
    private let introduceTextView: UITextView = {
        let tv = AddExhibitionUtilities().customTestView(fontSize: 16, textColor: .mainPurple)
        tv.setDimensions(width: screenWidth, height: 210)
        tv.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Mauris fermentum nulla sit amet elementum iaculis. Donec ac nisi dictum, hendrerit quam ut, consequat neque. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Donec hendrerit facilisis tortor nec pretium. Mauris eu fringilla orci. Cras in enim lorem. Sed nec libero rhoncus, lacinia erat nec, ultricies risus. Mauris a faucibus neque. Suspendisse urna purus, maximus sit amet urna ac, laoreet varius orci. Vestibulum ornare ex ut enim gravida, ut finibus odio lobortis. Nulla sagittis ac leo ut feugiat. In eu magna mi. Duis ultrices pulvinar sodales. Donec imperdiet fermentum tortor quis ornare. Donec vel libero in odio sollicitudin pretium."
        
        return tv
    }()
    
    //MARK: - Init
    init(exhibitionID: String) {
        self.exhibitionID = exhibitionID
        super.init(nibName: nil, bundle: nil)
        fetchExhibition()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    //MARK: - API
    func fetchExhibition() {
        guard let exhibitionID = exhibitionID else { return }
        ExhibitionService.shared.fetchExhibition(withExhibitionID: exhibitionID) { (exhibition) in
            self.exhibition = exhibition
            DispatchQueue.main.async {
                self.coverImageView.sd_setImage(with: exhibition.path)
                self.exhibitionTitleTextView.text = exhibition.exhibitionName
                self.introduceTextView.text = exhibition.information
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
            self.dismiss(animated: true, completion: nil)
        }))

        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Helpers
    func configureUI() {
        view.backgroundColor = .mainBackground
        configureNavigationBar()
        
        let titleStack = UIStackView(arrangedSubviews: [exhibitionTitleLabel, exhibitionTitleTextView])
        titleStack.axis = .vertical
        titleStack.spacing = 4
        
        let imageStack = UIStackView(arrangedSubviews: [coverImageView, titleStack])
        imageStack.axis = .horizontal
        imageStack.spacing = 12
        imageStack.alignment = .top
        
        let introduceStack = UIStackView(arrangedSubviews: [introduceLabel, introduceTextView])
        introduceStack.axis = .vertical
        introduceStack.spacing = 4
        
        let allStack = UIStackView(arrangedSubviews: [imageStack, introduceStack])
        allStack.axis = .vertical
        
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
}
