//
//  CommentService.swift
//  ArtScreen_final
//
//  Created by Heng on 2020/12/16.
//

import Foundation

struct CommentService {
    static let shared = CommentService()
    
    func uploadComment(artwork: ArtworkDetail, message: String, completion: ((Error?) -> Void)?) {
        let uuid = NSUUID().uuidString
        guard let id = Int(userDefault["id"] as! String) else { return }
        let url = URL(string: POST_COMMENT_URL)!
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "POST"
        let body = "commentID=\(uuid)&artworkID=\(artwork.artworkID)&userID=\(id)&message=\(message)"
        request.httpBody = body.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { (data, _, error) in
            guard data != nil else {
                print("DEBUG: data is nil..")
                return
            }
            completion!(error)
        }
        task.resume()
    }
    
    func fetchComment(artwork: ArtworkDetail, completion: @escaping([CommentDetail]) -> Void) {
        let url = URL(string: GET_COMMENT_FROM_ARTWORKID_URL)!
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "POST"
        let body = "artworkID=\(artwork.artworkID)"
        request.httpBody = body.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { (data, _, _) in
            guard let data = data else {
                print("DEBUG: Comment data is nil..")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let comments = try decoder.decode(Comments.self, from: data)
                let commentDetail = comments.comments
                completion(commentDetail)
            } catch {
                print("DEBUG: \(error.localizedDescription)")
            }
        }
        task.resume()
    }
}
