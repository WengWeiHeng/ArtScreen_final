//
//  ExhibitionService.swift
//  ArtScreen_final
//
//  Created by Heng on 2020/12/3.
//

import Foundation
import UIKit

struct ExhibitionCredentials {
    let exhibitionName: String
    let information: String
    let exhibitionImage: UIImage
    let privacy: Int
}

struct UpdateArtworkID_Exhibiton {
    let exhibitionID: String
    let artworkID: String
    let userID: Int
}

struct UpdateExhibitionCredentials {
    let exhibitionID: String
    let exhibitionName: String
    let exhibitionImage: UIImage
    let information: String
    let privacy: Int
}

class ExhibitionService {
    static let shared = ExhibitionService()
    
    func uploadExhibiton(exhibitionCredentials: ExhibitionCredentials, user: User) -> String {
        let uuid = NSUUID().uuidString
        //url path to php file
        let url = URL(string: POST_EXHIBITION_URL)!
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "POST"

        let param = [
            "exhibitionID" : uuid,
            "userID" : user.id,
            "exhibitionName" : exhibitionCredentials.exhibitionName,
            "information" : exhibitionCredentials.information,
            "privacy" : exhibitionCredentials.privacy
        ] as [String : Any]
        print("DEBUG: Postartwork uuid = \(uuid)")
        //body
        let boundary = "Boundary-\(NSUUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        //if picture is selected, compress it by half
        var imageData = Data()
        
        imageData = exhibitionCredentials.exhibitionImage.jpegData(compressionQuality: 0.5)!
        //... body
        print("DEBUG: upload data contain is \(param)")
        print(exhibitionCredentials.exhibitionImage.size)
        let createBody = AuthService.shared.createBodyWithPath(parameters: param, filePathKey: "file", imageDataKey: imageData, boundary: boundary, filename: "exhibition-\(uuid).jpg", mimetype: "image/jpg")
        request.httpBody = createBody
        
        //launch session
        URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
            DispatchQueue.main.async {
                if error == nil {
                    do {
                        print("DEBUG: - echo \(String(data: data!, encoding: .utf8) ?? "")")
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
        return uuid
    }
    
    func updateExhibition(credentials: UpdateExhibitionCredentials) {
        guard let id = Int(userDefault["id"] as! String) else { return }
        let url = URL(string: UPDATE_EXHIBITION_URL)!
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "POST"
        
        let param = [
            "userID": id,
            "exhibitionID": credentials.exhibitionID,
            "exhibitionName": credentials.exhibitionName,
            "information": credentials.information,
            "privacy": credentials.privacy
        ] as [String : Any]

        let boundary = "Boundary-\(NSUUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var imageData = Data()
        
        imageData = credentials.exhibitionImage.jpegData(compressionQuality: 0.5)!
        print("DEBUG: upload data contain is \(param)")
        print("DEBUG: \(credentials.exhibitionImage)")
        
        let createBody = AuthService.shared.createBodyWithPath(parameters: param, filePathKey: "file", imageDataKey: imageData, boundary: boundary, filename: "exhibition-\(credentials.exhibitionID).jpg", mimetype: "image/jpg")
        request.httpBody = createBody
        
        //launch session
        URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
            DispatchQueue.main.async {
                if error == nil {
                    do {
                        print("DEBUG: - echo \(String(describing: String(data: data!, encoding: .utf8)))")
                        //json containers $returnArray from php
                        let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary

                        //declare new var to store json inf
                        guard json != nil else {
                            print("Error while parsing")
                            return
                        }
                    } catch {
                        print("Error:\(error)")
                    }
                } else {
                    print("Error:\(error?.localizedDescription ?? "")")
                }
            }
        }.resume()
    }
    
    func updateArtworkID(updateArtworkID: UpdateArtworkID_Exhibiton) {
        let url = URL(string: POST_EXHIBITION_UPDATE_ARTWORK_URL)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let body = "exhibitionID=\(updateArtworkID.exhibitionID)&userID=\(updateArtworkID.userID)&artworkID=\(updateArtworkID.artworkID)"
        request.httpBody = body.data(using: String.Encoding.utf8)

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
    
    func deleteExhibition(withExhibition exhibition: ExhibitionDetail) {
        guard let id = Int(userDefault["id"] as! String) else { return }
        let url = URL(string: DELETE_EXHIBITION_URL)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let body = "exhibitionID=\(exhibition.exhibitionID)&userID=\(id)"
        request.httpBody = body.data(using: .utf8)
        
        URLSession.shared.dataTask(with: request) { (data, request, error) in
            DispatchQueue.main.async {
                if error == nil {
                    do {
                        print("DEBUG: updateArtworkID_Exhibition \(String(describing: String(data: data!, encoding: .utf8)))")
                        //json containers $returnArray from php
                        let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary

                        //declare new var to store json inf
                        guard json != nil else {
                            print("DEBUG: Error while parsing")
                            return
                        }
                    }catch {
                        print("DEBUG: error:\(error)")
                    }
                } else {
                    print("Error:\(error?.localizedDescription ?? "")")
                }
            }
        }.resume()
    }
    
    //MARK: - Fetch Exhibition    
    func fetchExhibitions(completion: @escaping([ExhibitionDetail]) -> Void) {
        let url = URL(string: GET_ALL_EXHIBITION_URL)!
        let request = NSMutableURLRequest(url: url)
        
        readExhibitionData(request: request, completion: completion)
    }
    
    func fetchExhibition(withExhibitionID exhibitionID: String, completion: @escaping(ExhibitionDetail) -> Void) {
        let url = URL(string: GET_EXHIBITION_WITHID_URL)!
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "POST"
        let body = "exhibitionID=\(exhibitionID)"
        request.httpBody = body.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { (data, _, _) in
            guard let jsonData = data else {
                print("DEBUG: data is nil..")
                return
            }
//            print("DEBUG: user exhibition data: \(String(data: data!, encoding: .utf8))")

            do {
                let decoder = JSONDecoder()
                let exhibitionDetail = try decoder.decode(ExhibitionDetail.self, from: jsonData)
                completion(exhibitionDetail)
            } catch {
                print("DEBUG: \(error.localizedDescription)")
            }
        }
        task.resume()
    }
    
    func fetchUserExhibition(forUser user: User, completion: @escaping([ExhibitionDetail]) -> Void) {
        let url = URL(string: GET_USER_EXHIBITION_URL)!
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "POST"
        let body = "userID=\(user.id)"
        request.httpBody = body.data(using: .utf8)
        
        readExhibitionData(request: request, completion: completion)
    }
    
    func fetchSearchExhibition(forKeywords keywords : String,completion: @escaping([ExhibitionDetail]) -> Void) {
        let url = URL(string: SEARCH_EXHIBITION_URL)
        let request = NSMutableURLRequest(url: url!)
        request.httpMethod = "POST"
        let body = "keywords=\(keywords)"
        request.httpBody = body.data(using: .utf8)
        
        readExhibitionData(request: request, completion: completion)
    }
    
    func fetchExhibitionCallBack(exhibition: ExhibitionDetail, completion: @escaping(ExhibitionDetail) -> Void) {
        ExhibitionService.shared.fetchExhibition(withExhibitionID: exhibition.exhibitionID) { (exhibition) in
            completion(exhibition)
        }
    }
    
    func readExhibitionData(request: NSMutableURLRequest, completion: @escaping([ExhibitionDetail]) -> Void) {
        let task = URLSession.shared.dataTask(with: request as URLRequest) { (data, _, _) in
            guard let jsonData = data else {
                print("DEBUG: data is nil..")
                return
            }
//            print("DEBUG: user exhibition data: \(String(data: data!, encoding: .utf8))")

            do {
                let decoder = JSONDecoder()
                let exhibition = try decoder.decode(Exhibitions.self, from: jsonData)
                let exhibitionDetail = exhibition.exhibitions
                completion(exhibitionDetail)
            } catch {
                print("DEBUG: \(error.localizedDescription)")
            }
        }
        task.resume()
    }
    
}

