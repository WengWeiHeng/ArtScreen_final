//
//  NotificationService.swift
//  ArtScreen_final
//
//  Created by cmStudent on 2020/12/17.
//

import Foundation
import UIKit
struct NotificationService {
    static let share = NotificationService()

    //MARK: - GET NOTIFICATION
    func getNotification(forUser user: User,completion: @escaping([NotificationDetail]) -> Void){
        let url = URL(string: GET_NOTIFICATION_URL)
        let request = NSMutableURLRequest(url: url!)
        request.httpMethod = "POST"
        let body = "userID=\(user.id)"
        print(user.id)
        request.httpBody = body.data(using: .utf8)
        
        readNotification(request: request, completion: completion)
  
    }
    func readNotification(request: NSMutableURLRequest, completion: @escaping([NotificationDetail]) -> Void ){
        let task = URLSession.shared.dataTask(with: request as URLRequest) { (data, _, _) in
            guard let data = data else {
                print("DEBUG: data is nil..")
                return
            }
            print("DEBUG: user notification data: \(String(data: data, encoding: .utf8))")

            do {
                let decoder = JSONDecoder()
                let notifications = try decoder.decode(Notifications.self, from: data)
                let notificationDetail = notifications.notifications
                completion(notificationDetail)
            } catch {
                print("DEBUG: \(error.localizedDescription)")
            }
        }
        task.resume()
        
    }
    
}
