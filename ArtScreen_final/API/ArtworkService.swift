//
//  ArtworkService.swift
//  ArtScreen_final
//
//  Created by Heng on 2020/11/19.
//

import Foundation
import UIKit

struct ArtworkCredentials {
    let artworkName: String
    let information: String
    let artworkImage: UIImage
    let lat: Double
    let lng: Double
}

enum ArtworkError: Error {
    case noDataAvailable
    case canNotProcessData
}

struct ArtworkService {
    static let shared = ArtworkService()
    
    //MARK: - Upload Artwork
    func uploadArtwork(artworkCredentials : ArtworkCredentials, user: User) {
        //short to data to be passed to php file
        let uuid = NSUUID().uuidString
        //url path to php file
        let url = URL(string: "http://artscreen.sakura.ne.jp/postArtwork.php")!
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "POST"

        let param = [
            "artworkID" : uuid,
            "userID" : user.id,
            "artworkName" : artworkCredentials.artworkName,
            "information" : artworkCredentials.information,
            "locationLat" : artworkCredentials.lat,
            "locationLng" : artworkCredentials.lng
        ] as [String: Any]
        print("DEBUG: Postartwork uuid = \(uuid)")
        //body
        let boundary = "Boundary-\(NSUUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        //if picture is selected, compress it by half
        var imageData = Data()
        
        imageData = artworkCredentials.artworkImage.jpegData(compressionQuality: 0.5)!
        //... body
        print("DEBUG: upload data contain is \(param)")
        print(artworkCredentials.artworkImage.size)
        let createBody = AuthService.shared.createBodyWithPath(parameters: param, filePathKey: "file", imageDataKey: imageData, boundary: boundary, filename: "artwork-\(uuid).jpg")
        request.httpBody = createBody
        
        //launch session
        URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
            DispatchQueue.main.async {
                if error == nil {
                    do {
                        //json containers $returnArray from php
                        let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
//                        print("DEBUG: Post artWork \(json?.description)")
                        //declare new var to store json inf
                        guard json != nil else {
                            print("Error while parsing")
                            return
                        }
                    }catch {
                        print("Error:\(error)")
                    
                    }
                } else {
                    print("Error:\(error?.localizedDescription ?? "")")
                    
                }
            }
        }.resume()
    }

    //MARK: - Fetch Artwork
    func fetchArtwork(completion: @escaping([ArtworkDetail]) -> Void) {
        let url = URL(string: "http://artscreen.sakura.ne.jp/getAllArtwork.php")!
        let request = NSMutableURLRequest(url: url)
        
        readArtworkData(request: request, completion: completion)
    }
    
    func fetchUserArtwork(forUser user: User, completion: @escaping([ArtworkDetail]) -> Void) {
        let url = URL(string: "http://artscreen.sakura.ne.jp/getUserArtwork.php")!
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "POST"
        let body = "userID=\(user.id)"
        request.httpBody = body.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { (data, _, _) in
            guard let jsonData = data else {
                print("DEBUG: data is nil..")
                return
            }
            
            print("DEBUG: user artwork data: \(String(data: data!, encoding: .utf8))")

            do {
                let decoder = JSONDecoder()
                let artworks = try decoder.decode(Artworks.self, from: jsonData)
                let artworkDetail = artworks.artworks
                completion(artworkDetail)
            } catch {
                print("DEBUG: \(error.localizedDescription)")
            }
        }
        task.resume()
        
        print("DEBUG: user is \(user.fullname), id: \(user.id)")
    }
    
    func readArtworkData(request: NSMutableURLRequest, completion: @escaping([ArtworkDetail]) -> Void) {
        let task = URLSession.shared.dataTask(with: request as URLRequest) { (data, _, _) in
            guard let jsonData = data else {
                print("DEBUG: data is nil..")
                return
            }
            
            print("DEBUG: user artwork data: \(String(data: data!, encoding: .utf8))")

            do {
                let decoder = JSONDecoder()
                let artworks = try decoder.decode(Artworks.self, from: jsonData)
                let artworkDetail = artworks.artworks
                completion(artworkDetail)
            } catch {
                print("DEBUG: \(error.localizedDescription)")
            }
        }
        task.resume()
    }
}