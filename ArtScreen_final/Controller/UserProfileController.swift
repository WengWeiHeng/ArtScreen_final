//
//  UserProfileController.swift
//  ArtScreen_final
//
//  Created by Heng on 2020/10/22.
//

import UIKit

class UserProfileController: UIViewController {
    
    //MARK: - Properties
    
    //MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    //MARK: - Helpers
    func configureUI() {
        view.backgroundColor = .mainPurple
        navigationController?.navigationBar.isHidden = true
    }
}
