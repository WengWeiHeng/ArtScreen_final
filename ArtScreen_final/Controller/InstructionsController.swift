//
//  Instructions.swift
//  ArtScreen_final
//
//  Created by Heng on 2021/2/28.
//

import UIKit
import WebKit

class InstructionsController: UIViewController {
    
    //MARK: - Properties
    private let privacyWebView = WKWebView()
    
    //MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .mainBackground
        navigationBarRightItem(selector: #selector(handleDismissal), buttonColor: .mainPurple)
        
        let urlString = "http://artscreen.sakura.ne.jp/web/privacy.html"
        let encodedUrlString = urlString.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
        let url = NSURL(string: encodedUrlString!)
        let request = NSURLRequest(url: url! as URL)
 
        privacyWebView.load(request as URLRequest)
        
        view.addSubview(privacyWebView)
        privacyWebView.addConstraintsToFillView(view)
    }
    
    //MARK: - Selectors
    @objc func handleDismissal() {
        dismiss(animated: true, completion: nil)
    }
}
