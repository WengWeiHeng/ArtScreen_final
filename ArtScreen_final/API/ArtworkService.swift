//
//  ArtworkService.swift
//  ArtScreen_final
//
//  Created by Heng on 2020/11/19.
//

import Foundation
import UIKit
import CoreLocation

struct ArtworkCredentials {
    let artworkName: String
    let information: String
    let artworkImage: UIImage
    let width: Float
    let height: Float
    let lat: Double
    let lng: Double
    let locationName: String
}

struct UpdateArtworkCredentials {
    let artworkName: String
    let information: String
    let locationName: String
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
    func uploadArtwork(artworkCredentials : ArtworkCredentials, user: User, artworkItemCredentials: ArtworkItemCredentials? = nil) {
        //short to data to be passed to php file
        let uuid = NSUUID().uuidString
        //url path to php file
        let url = URL(string: POST_ARTWORK_URL)!
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "POST"

        let param = [
            "artworkID": uuid,
            "userID": user.id,
            "artworkName": artworkCredentials.artworkName,
            "information": artworkCredentials.information,
            "width": artworkCredentials.width,
            "height": artworkCredentials.height,
            "locationLat": artworkCredentials.lat,
            "locationLng": artworkCredentials.lng,
            "locationName": artworkCredentials.locationName
        ] as [String: Any]
        
        //body
        let boundary = "Boundary-\(NSUUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        //if picture is selected, compress it by half
        var imageData = Data()
        
        imageData = artworkCredentials.artworkImage.jpegData(compressionQuality: 0.5)!
        
        let createBody = AuthService.shared.createBodyWithPath(parameters: param, filePathKey: "file", imageDataKey: imageData, boundary: boundary, filename: "artwork-\(uuid).jpg", mimetype: "image/jpg")
        request.httpBody = createBody
        
        //launch session
        URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
            
//            print("DEBUG: data is \(String(data: data!, encoding: .utf8))")
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
        
        guard let artworkItem = artworkItemCredentials else { return }
        ArtworkItemService.shared.uploadArtworkItem(artworkID: uuid, user: user, artworkItem: artworkItem)
    }

    //MARK: - Fetch Artwork
    func fetchArtwork(completion: @escaping([ArtworkDetail]) -> Void) {
        let url = URL(string: GET_ALL_ARTWORK_URL)!
        let request = NSMutableURLRequest(url: url)
        
        readArtworkData(request: request, completion: completion)
    }
    
    func fetchUserArtwork(forUser user: User, completion: @escaping([ArtworkDetail]) -> Void) {
        let url = URL(string: GET_USER_ARTWORK_URL)!
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "POST"
        let body = "userID=\(user.id)"
        request.httpBody = body.data(using: .utf8)
        
        readArtworkData(request: request, completion: completion)
    }
    
    func fetchNoExhibitionArtwork(forUser user: User, completion: @escaping([ArtworkDetail]) -> Void) {
        let url = URL(string: GET_NOEXHIBITION_ARTWORK_URL)!
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "POST"
        let body = "userID=\(user.id)"
        request.httpBody = body.data(using: .utf8)
        
        readArtworkData(request: request, completion: completion)
    }
    
    func fetchExhibitionArtwork(forExhibitionID exhibitionID: String, completion: @escaping([ArtworkDetail]) -> Void) {
        let url = URL(string: GET_EXHIBITION_ARTWORK_URL)!
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "POST"
        let body = "exhibitionID=\(exhibitionID)"
        request.httpBody = body.data(using: .utf8)
        
        readArtworkData(request: request, completion: completion)
    }
    
    func fetchArtworkWithPosition(withPosition position: CLLocationCoordinate2D, completion: @escaping(ArtworkDetail) -> Void) {
        let url = URL(string: GET_ARTWORK_WITH_POSITION_URL)!
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "POST"
        let body = "lat=\(position.latitude)&lng=\(position.longitude)"
        request.httpBody = body.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { (data, _, _) in
            guard let jsonData = data else {
                print("DEBUG: data is nil..")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let artwork = try decoder.decode(ArtworkDetail.self, from: jsonData)
                completion(artwork)
            } catch {
                print("DEBUG: \(error.localizedDescription) when read artwork Data with position")
            }
        }
        task.resume()
    }
    
    func fetchSearchArtwork(forKeywords keywords : String, completion: @escaping([ArtworkDetail]) -> Void) {
        let url = URL(string: SEARCH_ARTWORK_URL)
        let request = NSMutableURLRequest(url: url!)
        request.httpMethod = "POST"
        let body = "keywords=\(keywords)"
        request.httpBody = body.data(using: .utf8)
        
        readArtworkData(request: request, completion: completion)
    }
    
    func updateArtwork(credential: UpdateArtworkCredentials, artwork: ArtworkDetail) {
        let url = URL(string: UPDATE_ARTWORK_URL)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let body = "artworkID=\(artwork.artworkID)&artworkName=\(credential.artworkName)&information=\(credential.information)&locationLat=\(credential.lat)&locationLng=\(credential.lng)&locationName=\(credential.locationName)"
        request.httpBody = body.data(using: String.Encoding.utf8)
        
        print("DEBUG: credential: \(credential)")

        URLSession.shared.dataTask(with: request) { (data, request, error) in
            DispatchQueue.main.async {
                if error == nil {
                    do {
                        print("DEBUG: updateArtworkID_Exhibition \(String(describing: String(data: data!, encoding: .utf8)))")
                        //json containers $returnArray from php
                        let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary

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
    
    func readArtworkData(request: NSMutableURLRequest, completion: @escaping([ArtworkDetail]) -> Void) {
        let task = URLSession.shared.dataTask(with: request as URLRequest) { (data, _, _) in
            guard let jsonData = data else {
                print("DEBUG: data is nil..")
                return
            }

            do {
                let decoder = JSONDecoder()
                let artworks = try decoder.decode(Artworks.self, from: jsonData)
                let artworkDetail = artworks.artworks
                completion(artworkDetail)
            } catch {
                print("DEBUG: \(error.localizedDescription) in Artwork Service")
            }
        }
        task.resume()
    }
}
