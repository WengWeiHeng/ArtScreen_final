//
//  LikeService.swift
//  ArtScreen_final
//
//  Created by Heng on 2021/2/12.
//

import Foundation

enum LikeState: Int, CaseIterable {
    case artwork
    case exhibition
    
    var description : String {
        switch self {
        case .artwork: return "artwork"
        case .exhibition: return "exhibition"
        
        }
    }
}

struct LikeService {
    static let shared = LikeService()
    
    func fetchLikeArtwork(withArtwork artwork: ArtworkDetail) {
        guard let id = Int(userDefault["id"] as! String) else { return }
        let url = URL(string: LIKE_ARTWORK_URL)!
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "POST"
        let body = "artworkID=\(artwork.artworkID)&userID=\(id))"
        request.httpBody = body.data(using: .utf8)
        
        likeRequest(request: request)
    }
    
    func fetchLikeExhibition(withExhibition exhibition: ExhibitionDetail) {
        guard let id = Int(userDefault["id"] as! String) else { return }
        let url = URL(string: LIKE_EXHIBITION_URL)!
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "POST"
        let body = "exhibitionID=\(exhibition.exhibitionID)&userID=\(id)"
        request.httpBody = body.data(using: .utf8)
        
        likeRequest(request: request)
    }
    
    func unlike(withState state: LikeState, artwork: ArtworkDetail? = nil, exhibition: ExhibitionDetail? = nil) {
        guard let id = Int(userDefault["id"] as! String) else { return }
        let url = URL(string: UNLIKE_URL)!
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "POST"
        
        switch state {
        case .artwork:
            guard let artwork = artwork else { return }
            let body = "model=\(state)&artworkID=\(artwork.artworkID)&userID=\(id)"
            request.httpBody = body.data(using: .utf8)
            likeRequest(request: request)
        case .exhibition:
            guard let exhibition = exhibition else { return }
            let body = "model=\(state)&exhibitionID=\(exhibition.exhibitionID)&userID=\(id)"
            request.httpBody = body.data(using: .utf8)
            likeRequest(request: request)
        }
    }
    
    func checkUserIsLike(withState state: LikeState, artwork: ArtworkDetail? = nil, exhibition: ExhibitionDetail? = nil, completion: @escaping(Bool) -> Void) {
        guard let id = Int(userDefault["id"] as! String) else { return }
        let url = URL(string: CHECK_IS_USER_LIKE)!
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "POST"
        
        if state == .artwork {
            guard let artwork = artwork else { return }
            let body = "model=\(state)&userID=\(id)&artworkID=\(artwork.artworkID)"
            request.httpBody = body.data(using: .utf8)
        }
        
        if state == .exhibition {
            guard let exhibition = exhibition else { return }
            let body = "model=\(state)&userID=\(id)&exhibitionID=\(exhibition.exhibitionID)"
            request.httpBody = body.data(using: .utf8)
        }
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { (data, _, _) in
            guard let jsonData = data else {
                print("DEBUG: data is nil..")
                return
            }
            
            let checkData = String(data: jsonData, encoding: .utf8)
            let trimData = checkData?.trimmingCharacters(in: CharacterSet.whitespaces)
            let isLike = trimData?.toBool()

            completion(isLike!)
        }
        task.resume()
    }
    
    func likeRequest(request: NSMutableURLRequest) {
        let task = URLSession.shared.dataTask(with: request as URLRequest) { (data, _, _) in
            guard data != nil else {
                print("DEBUG: data is nil in uploadFollowData..")
                return
            }
        }
        task.resume()
    }
}
