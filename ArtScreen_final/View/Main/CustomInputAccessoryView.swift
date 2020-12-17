//
//  CustomInputAccessoryView.swift
//  ArtScreen_final
//
//  Created by Heng on 2020/11/12.
//

import UIKit

protocol CustomInputAccessoryViewDelegate: class {
    func inputView(_ inputView: CustomInputAccessoryView, eantsToSend message: String)
}

class CustomInputAccessoryView: UIView {
    
    //MARK: - Properties
    weak var delegate: CustomInputAccessoryViewDelegate?
    
    private lazy var messageInputTextView: UITextView = {
        let tv = UITextView()
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.isScrollEnabled = false
        tv.backgroundColor = .none
        tv.textColor = .mainBackground
        
        return tv
    }()
    
    private let sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Send", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setTitleColor(.mainBackground, for: .normal)
        button.addTarget(self, action: #selector(handleSendMessage), for: .touchUpInside)
        
        return button
    }()
    
    private let placeholderLabel: UILabel = {
        let label = UILabel()
        label.text = "Enter Message"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .lightGray
        
        return label
    }()
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        autoresizingMask = .flexibleHeight
        backgroundColor = .mainAlphaGray
        
        layer.shadowOpacity = 0.25
        layer.shadowRadius = 6
        layer.shadowOffset = .init(width: 0, height: -8)
        layer.shadowColor = UIColor.lightGray.cgColor
        
        addSubview(sendButton)
        sendButton.anchor(top: topAnchor, right: rightAnchor, paddingTop: 4, paddingRight: 12)
        sendButton.setDimensions(width: 50, height: 50)
        
        addSubview(messageInputTextView)
        messageInputTextView.anchor(top: topAnchor, left: leftAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, right: sendButton.leftAnchor, paddingTop: 12, paddingLeft: 12, paddingBottom: 8, paddingRight: 8)
        
        addSubview(placeholderLabel)
        placeholderLabel.anchor(left: messageInputTextView.leftAnchor, paddingLeft: 4)
        placeholderLabel.centerY(inView: messageInputTextView)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleTextChange), name: UITextView.textDidChangeNotification, object: nil)
    }
    
    override var intrinsicContentSize: CGSize {
        return .zero
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Selectors
    @objc func handleSendMessage() {
        if self.messageInputTextView.text.isEmpty {
            print("DEBUG: The text is empty..")
        } else {
            guard let message = messageInputTextView.text else { return }
            delegate?.inputView(self, eantsToSend: message)
        }
    }
    
    @objc func handleTextChange() {
        placeholderLabel.isHidden = !self.messageInputTextView.text.isEmpty
    }
    
    //MARK: - Helpers
    func clearMessageText() {
        messageInputTextView.text = nil
        placeholderLabel.isHidden = false
    }
}
