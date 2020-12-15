//
//  UserService.swift
//  ArtScreen_final
//
//  Created by Heng on 2020/11/18.
//

import Foundation

struct UserService {
    static let shared = UserService()
    
    func fetchUser(completion: @escaping(User) -> Void) {
        userDefault = UserDefaults.standard.value(forKey: "parseJSON") as? NSDictionary
        if userDefault != nil {
            guard let id = Int(userDefault["id"] as! String) else { return }
            let user = User(id: id, dictionary: userDefault)
            completion(user)
        }
        
        
    }
    
    func fetchUserOfExhibition(withExhibition exhibition: ExhibitionDetail, completion: @escaping(User) -> Void) {
        let url = URL(string: "http://artscreen.sakura.ne.jp/getUserOfExhibition.php")!
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
    
    //MARK: - Fetch User
    func fetchAllUser(completion: @escaping([User]) -> Void) {
        let url = URL(string: "http://artscreen.sakura.ne.jp/SearchUser.php")!
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "POST"
        let body = "check=1"
        request.httpBody = body.data(using: .utf8)
        readUser(request: request, completion: completion)
    }
    
    func fetchSearch(keyword: String, completion: @escaping([User]) -> Void) {
        let url = URL(string: "http://artscreen.sakura.ne.jp/SearchUser.php")!
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "POST"
        let body = "check=2&keyword=\(keyword)"
        request.httpBody = body.data(using: .utf8)
                
        readUser(request: request, completion: completion)
    }
    
    func readUser(request: NSMutableURLRequest, completion: @escaping([User]) -> Void) {
        let task = URLSession.shared.dataTask(with: request as URLRequest) { (data, _, _) in
            guard let jsonData = data else {
                print("DEBUG: data is nil..")
                return
            }
            
            print("DEBUG: user artwork data: \(String(describing: String(data: data!, encoding: .utf8)))")

            do {
                let decoder = JSONDecoder()
                let users = try decoder.decode(Users.self, from: jsonData)
                let user = users.users
                print("DEBUG: - users = \(users)")
                completion(user)
            } catch {
                print("DEBUG: \(error.localizedDescription)")
            }
        }
        task.resume()
    }
}


