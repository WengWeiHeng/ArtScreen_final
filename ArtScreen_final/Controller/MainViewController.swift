//
//  MainViewController.swift
//  ArtScreen_final
//
//  Created by Heng on 2020/10/21.
//

import UIKit

class MainViewController: UIViewController {
    
    //MARK: - Properties
    
    
    //MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    //MARK: - Helper
    func configureUI() {
        view.backgroundColor = .mainBackground
        navigationController?.navigationBar.isHidden = true
    }
    
}
