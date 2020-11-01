//
//  ExhibitionEditController.swift
//  ArtScreen_final
//
//  Created by Heng on 2020/10/28.
//

import UIKit

class ExhibitionEditController: UIViewController {
    
    //MARK: - Properties
    private let basicLabel: UILabel = {
        let label = AddExhibitionUtilities().customTitleLebael(titleText: "Basic", textColor: .mainPurple)
        
        return label
    }()
    
    private let privacyLabel: UILabel = {
        let label = AddExhibitionUtilities().customTitleLebael(titleText: "Privacy", textColor: .mainPurple)
        
        return label
    }()
    
    private let coverInageView: UIImageView = {
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
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    //MARK: - Selectors
    @objc func handleDismissal() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleSave() {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Helpers
    func configureUI() {
        view.backgroundColor = .mainBackground
        configureNavigationBar()
        
        let titleStack = UIStackView(arrangedSubviews: [exhibitionTitleLabel, exhibitionTitleTextView])
        titleStack.axis = .vertical
        titleStack.spacing = 4
        
        let imageStack = UIStackView(arrangedSubviews: [coverInageView, titleStack])
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
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "close").withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(handleDismissal))
        navigationItem.leftBarButtonItem?.tintColor = .mainPurple
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "Send").withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(handleSave))
        navigationItem.rightBarButtonItem?.tintColor = .mainPurple
    }
}
