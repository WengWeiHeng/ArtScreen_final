//
//  NotificationCell.swift
//  ArtScreen_final
//
//  Created by Heng on 2020/11/13.
//

import UIKit

class NotificationCell: UITableViewCell {
    
    //MARK: - Properties
    var notification: NotificationDetail? {
        didSet {
            configureData()
        }
    }
    
    var notificationType: Int?
    
    let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .mainPurple
        iv.setDimensions(width: 32, height: 32)
        iv.layer.cornerRadius = 32 / 2
        
        return iv
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 14)
        label.textColor = .mainPurple
        label.text = "@Weng_Heng0301 is following"
        
        return label
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .mainAlphaGray
//        label.text = "3s"
        
        return label
    }()
    
    //MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        backgroundColor = .mainBackground
        
        addSubview(profileImageView)
        profileImageView.anchor(left: leftAnchor, paddingLeft: 16)
        profileImageView.centerY(inView: self)
        
        addSubview(timeLabel)
        timeLabel.anchor(right: rightAnchor, paddingRight: 16)
        timeLabel.centerY(inView: profileImageView)
        
        addSubview(descriptionLabel)
        descriptionLabel.anchor(left: profileImageView.rightAnchor, paddingLeft: 8)
        descriptionLabel.centerY(inView: profileImageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helper
    func configureData() {
        guard let notification = notification else { return }
        
        UserService.shared.fetchUser(withUserID: notification.fromUserID) { (user) in
            let viewModel = NotificationViewModel(user: user, notification: notification)
            
            DispatchQueue.main.async {
                self.profileImageView.sd_setImage(with: viewModel.fromUserImage)
                self.descriptionLabel.text = viewModel.message
                self.timeLabel.text = viewModel.time
            }
        }
    }
}
