//
//  Notification.swift
//  ArtScreen_final
//
//  Created by cmStudent on 2020/12/17.
//

import Foundation
struct Notifications: Decodable {
    var notifications : [NotificationDetail]
}

struct NotificationDetail: Decodable {
    var notificationID: String
    var fromUserID: Int
    var state: Int
    var type: Int
    var typeID: String
    var time: String
    var username: String
    var ava: URL
}
