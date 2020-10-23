//
//  ExhibitionSendView.swift
//  ArtScreen_final
//
//  Created by Heng on 2020/10/23.
//

import UIKit

private let reuseIdentidier = "ExhibitionSendViewCell"

protocol ExhibitionSendViewDelegate: class {
    func didTappedExhibiSetting_Send_cancel()
}

class ExhibitionSendView: UIView {
    
    //MARK: - Properties
    weak var delegate: ExhibitionSendViewDelegate?
    
    private let tableView = UITableView()
    private let searchController = UISearchController(searchResultsController: nil)
    private var inSearchMode: Bool {
        return searchController.isActive && !searchController.searchBar.text!.isEmpty
    }
    
    private let titleBarView: UIView = {
        let view = UIView()
        
        let closeButton = UIButton(type: .system)
        closeButton.setImage(#imageLiteral(resourceName: "close").withRenderingMode(.alwaysTemplate), for: .normal)
        closeButton.tintColor = .mainPurple
        closeButton.setDimensions(width: 24, height: 24)
        closeButton.addTarget(self, action: #selector(tapBtnCancel), for: .touchUpInside)
        
        let titleLabel = UILabel()
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        titleLabel.textColor = .mainPurple
        titleLabel.text = "Send Exhibition"
        
        view.addSubview(closeButton)
        closeButton.anchor(left: view.leftAnchor, paddingLeft: 16)
        closeButton.centerY(inView: view)
        
        view.addSubview(titleLabel)
        titleLabel.centerY(inView: view)
        titleLabel.centerX(inView: view)
        
        return view
    }()
    
    private lazy var searchBarTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Search"
        tf.backgroundColor = .white
        tf.returnKeyType = .search
        tf.font = UIFont.systemFont(ofSize: 14)
        
        let leftView = UIView()
        leftView.setDimensions(width: 56, height: tf.frame.height)
        let iconView = UIImageView()
        iconView.image = #imageLiteral(resourceName: "search")
        iconView.setDimensions(width: 24, height: 24)
        
        leftView.addSubview(iconView)
        iconView.centerY(inView: leftView)
        iconView.centerX(inView: leftView)
        
        tf.leftView = leftView
        tf.leftViewMode = .always
        
        return tf
    }()
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
//        addStackView_V()
        backgroundColor = .mainBackground
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Selectors
    @objc func tapBtnCancel() {
        print("btnCancel be tapped")
        self.delegate?.didTappedExhibiSetting_Send_cancel()
    }
    
    //MARK: - Helpers
    func configureUI() {
        addSubview(titleBarView)
        titleBarView.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, height: 70)
        
        addSubview(searchBarTextField)
        searchBarTextField.anchor(top: titleBarView.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingLeft: 16, paddingRight: 16, height: 50)
        searchBarTextField.layer.cornerRadius = 50 / 2
        
        addSubview(tableView)
        tableView.backgroundColor = .mainBackground
        tableView.anchor(top: searchBarTextField.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 20)
        tableView.register(ExhibitionSendViewCell.self, forCellReuseIdentifier: reuseIdentidier)
        tableView.rowHeight = 70
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
    }
}

//MARK: - TableView DataSource
extension ExhibitionSendView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentidier, for: indexPath) as! ExhibitionSendViewCell
        
        return cell
    }
}

//MARK: - TableView Delegate
extension ExhibitionSendView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("DEBUG: Cell did selected..")
    }
}

