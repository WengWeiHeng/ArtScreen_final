//
//  CommentService.swift
//  ArtScreen_final
//
//  Created by Heng on 2020/12/16.
//

import Foundation

struct CommentService {
    static let shared = CommentService()
    
    func uploadComment(artwork: ArtworkDetail, user: User, message: String, completion: ((Error?) -> Void)?) {
        let uuid = NSUUID().uuidString
        
        let url = URL(string: "http://artscreen.sakura.ne.jp/comment/postComment.php")!
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "POST"
        let body = "commentID=\(uuid)&artworkID=\(artwork.artworkID)&userID=\(user.id)&message=\(message)"
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
        let url = URL(string: "http://artscreen.sakura.ne.jp/comment/getCommentFromArtworkID.php")!
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
