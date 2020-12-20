//
//  NotificationViewModel.swift
//  ArtScreen_final
//
//  Created by Heng on 2020/12/20.
//

import UIKit

struct NotificationViewModel {
    private let fromUser: User
    private let notification: NotificationDetail
    
    var fromUserImage: URL {
        return fromUser.ava!
    }
    
    var message: String {
        switch notification.type {
        case 0:
            return fromUser.username + " was Followed you"
        case 1:
            return fromUser.username + " was commeitted in your artwork"
        case 2:
            return fromUser.username + " was uploaded new artwork"
        case 3:
            return fromUser.username + " was uploaded new exhibition"
        default:
            return "DEBUG: Notification is nil"
        }
    }
    
    
    var followMessage: String {
        return fromUser.username + "was Followed you"
    }
    
    var commentMessage: String {
        return fromUser.username + "was commeitted in your artwork"
    }
    
    init(user: User, notification: NotificationDetail) {
        self.fromUser = user
        self.notification = notification
    }
}
