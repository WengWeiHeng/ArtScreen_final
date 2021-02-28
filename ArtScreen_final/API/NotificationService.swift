//
//  NotificationService.swift
//  ArtScreen_final
//
//  Created by Heng on 2020/12/20.
//

import Foundation
import UIKit

struct NotificationService {
    static let share = NotificationService()

    //MARK: - GET NOTIFICATION
    func getNotification(completion: @escaping([NotificationDetail]) -> Void){
        guard let currentUid = Int(userDefault["id"] as! String) else { return }
        let url = URL(string: GET_NOTIFICATION_URL)
        let request = NSMutableURLRequest(url: url!)
        request.httpMethod = "POST"
        let body = "userID=\(currentUid)"        
        request.httpBody = body.data(using: .utf8)
        
        readNotification(request: request, completion: completion)
    }
    
    func readNotification(request: NSMutableURLRequest, completion: @escaping([NotificationDetail]) -> Void ){
        let task = URLSession.shared.dataTask(with: request as URLRequest) { (data, _, _) in
            guard let data = data else {
                print("DEBUG: data is nil..")
                return
            }
            print("DEBUG: user notification data: \(String(data: data, encoding: .utf8) ?? "")")

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
