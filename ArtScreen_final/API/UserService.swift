//
//  UserService.swift
//  ArtScreen_final
//
//  Created by Heng on 2020/11/18.
//

import Foundation

struct UserService {
    static let shared = UserService()
    
    //MARK: - Fetch User
    func fetchUser(completion: @escaping(User) -> Void) {
        userDefault = UserDefaults.standard.value(forKey: "parseJSON") as? NSDictionary
        if userDefault != nil {
            guard let id = Int(userDefault["id"] as! String) else { return }
            let user = User(id: id, dictionary: userDefault)
            completion(user)
        }
    }
    
    func fetchUser(withUserID userID: Int, completion: @escaping(User) -> Void) {
        let url = URL(string: SELECT_USER_URL)!
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "POST"
        let body = "userID=\(userID)"
        request.httpBody = body.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { (data, _, _) in
            guard let jsonData = data else {
                print("DEBUG: data is nil..")
                return
            }
            
            print("DEBUG: Comment user data: \(String(describing: String(data: data!, encoding: .utf8))) in UserService")

            do {
                let decoder = JSONDecoder()
                let user = try decoder.decode(User.self, from: jsonData)
                completion(user)
            } catch {
                print("DEBUG: \(error.localizedDescription)")
            }
        }
        task.resume()
    }
    
    func fetchUserOfExhibition(withExhibition exhibition: ExhibitionDetail, completion: @escaping(User) -> Void) {
        let url = URL(string: GET_USER_OF_EXHIBITION_URL)!
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "POST"
        let body = "userID=\(exhibition.userID)"
        request.httpBody = body.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { (data, _, _) in
            guard let jsonData = data else {
                print("DEBUG: data is nil..")
                return
            }
//            print("DEBUG: user data: \(String(data: data!, encoding: .utf8))")

            do {
                let decoder = JSONDecoder()
                let user = try decoder.decode(User.self, from: jsonData)
//                let exhibitionDetail = exhibition.exhibitions
                completion(user)
            } catch {
                print("DEBUG: \(error.localizedDescription)")
            }
        }
        task.resume()
    }
    
    func fetchAllUser(completion: @escaping([User]) -> Void) {
        let url = URL(string: SEARCH_USER)!
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "POST"
        let body = "check=1"
        request.httpBody = body.data(using: .utf8)
        readUserData(request: request, completion: completion)
    }
    
    func fetchAccountSearch(keyword: String, completion: @escaping([User]) -> Void) {
        let url = URL(string: SEARCH_USER)!
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "POST"
        let body = "check=2&keyword=\(keyword)"
        request.httpBody = body.data(using: .utf8)
                
        readUserData(request: request, completion: completion)
    }
    
    //MARK: - Follow
    func followingUser(user: User) {
        guard let id = Int(userDefault["id"] as! String) else { return }
        let uuid = NSUUID().uuidString
        let url = URL(string: FOLLOWING_URL)!
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "POST"
        let body = "followingID=\(uuid)&userID=\(id))&followingUserID=\(user.id)"
        request.httpBody = body.data(using: .utf8)
        
        uploadFollowData(request: request)
    }
    
    func unfollowUser(user: User) {
        guard let id = Int(userDefault["id"] as! String) else { return }
        
        let url = URL(string: UNFOLLOW_URL)!
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "POST"
        let body = "userID=\(id))&followingUserID=\(user.id)"
        request.httpBody = body.data(using: .utf8)
        
        uploadFollowData(request: request)
    }
    
    func checkUserIsFollowing(user: User, completion: @escaping(Bool) -> Void) {
        guard let id = Int(userDefault["id"] as! String) else { return }
        let url = URL(string: CHECK_USER_IS_FOLLOWING_URL)!
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "POST"
        let body = "userID=\(id)&checkID=\(user.id)"
        request.httpBody = body.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { (data, _, _) in
            guard let data = data else {
                print("DEBUG: data is nil..")
                return
            }
            
            let checkData = String(data: data, encoding: .utf8)
            let isFollowed = checkData?.toBool()
            
            print("DEBUG: isFollowed \(isFollowed) in user service")
            completion(isFollowed!)
        }
        task.resume()
    }
    
    //MARK: - Helper
    func uploadFollowData(request: NSMutableURLRequest) {
        let task = URLSession.shared.dataTask(with: request as URLRequest) { (data, _, _) in
            guard data != nil else {
                print("DEBUG: data is nil in uploadFollowData..")
                return
            }
        }
        task.resume()
    }
    
    func readUserData(request: NSMutableURLRequest, completion: @escaping([User]) -> Void) {
        let task = URLSession.shared.dataTask(with: request as URLRequest) { (data, _, _) in
            guard let jsonData = data else {
                print("DEBUG: data is nil in readUserData..")
                return
            }
            
            print("DEBUG: user data: \(String(describing: String(data: data!, encoding: .utf8))) in UserService")

            do {
                let decoder = JSONDecoder()
                let users = try decoder.decode(Users.self, from: jsonData)
                let user = users.users
                completion(user)
            } catch {
                print("DEBUG: \(error.localizedDescription)")
            }
        }
        task.resume()
    }
}


