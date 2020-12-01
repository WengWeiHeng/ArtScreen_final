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

struct ArtworkService {
    static let shared = ArtworkService()
    
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
    
    func fetchArtwork(completion: @escaping([Artwork]) -> Void) {
        var artworks = [Artwork]()
        //url to access our php file
        let url = URL(string: "http://artscreen.sakura.ne.jp/getAllArtwork.php")!
        //request url
        let request = NSMutableURLRequest(url: url)

        //launch session
        URLSession.shared.dataTask(with: request as URLRequest) { (data: Data?, response:URLResponse?, error:Error?) in
            if error == nil {
                //get main queue in code process to communicate back to UI
                DispatchQueue.main.async {
                    do {
                        //get json result
                        let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                        //assign json to new var parseJSON in guard/secured way
                        
                        guard let parseJSON = json else {
                            print("Error while parsing")
                            return
                        }
                        print(parseJSON)
                        //get id from parseJSON dictionary
                        let id = parseJSON["id"]
                        //if there is some id value
                        if id != nil {
                            //save user information we received from host
                            UserDefaults.standard.setValue(parseJSON, forKey: "parseJSON")
                            userDefault = UserDefaults.standard.value(forKey: "parseJSON") as? NSDictionary
                            //successfully logged in
                            print("DEBUG - successfully Login")
            
                        } else {
                            print("error")
                        }
                    } catch {
                        print("Caught an error:\(error)")
                    }
                }
                // if unalble to proceed request
            }else {
                print("DEBUG: error is \(String(describing: error?.localizedDescription))")
            }
            //launch prepared session
        }.resume()
    }
    
    func fetchUserArtwork(userID: String, completion: @escaping([Artwork]) -> Void) {
//        var artworks = [Artwork]()
    }
}
