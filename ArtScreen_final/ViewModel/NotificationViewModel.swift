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
        case 4:
            return fromUser.username + " like your Artwork"
        case 5:
            return fromUser.username + " like your Exhibition"
        default:
            return "DEBUG: Notification is nil"
        }
    }
    
    var time: String {
        let startDate = notification.time
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let formatedStartDate = dateFormatter.date(from: startDate)
        let currentDate = Date()

        let elapsedSecond = Calendar.current.dateComponents([.second], from: currentDate, to: formatedStartDate!).second!
        let elapsedMinute = Calendar.current.dateComponents([.minute], from: currentDate, to: formatedStartDate!).minute!
        let elapsedHour = Calendar.current.dateComponents([.hour], from: currentDate, to: formatedStartDate!).hour!
        let elapsedDays = Calendar.current.dateComponents([.day], from: currentDate, to: formatedStartDate!).day!
        let elapsedMonth = Calendar.current.dateComponents([.month], from: currentDate, to: formatedStartDate!).month!
        let elapsedYear = Calendar.current.dateComponents([.year], from: currentDate, to: formatedStartDate!).year!
        
        if -elapsedSecond < 60 {
            return String(-elapsedSecond) + "秒前"
        }

        if -elapsedMinute < 60 {
            return String(-elapsedMinute) + "分前"
        }
        
        if -elapsedHour < 24 {
            return String(-elapsedHour) + "時間前"
        }
        
        if -elapsedDays < 31 {
            return String(-elapsedDays) + "日前"
        }
        
        if -elapsedMonth < 12 {
            return String(-elapsedMonth) + "月前"
        }

        if -elapsedMonth > 12 {
            return String(-elapsedYear) + "年前"
        }
        
        return "DEBUG: Notification is nil"
    }
    
    init(user: User, notification: NotificationDetail) {
        self.fromUser = user
        self.notification = notification
    }
}
