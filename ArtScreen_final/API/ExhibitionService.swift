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

class ExhibitonService {
    static let shared = ExhibitonService()
    
    func uploadExhibiton(exhibitionCredentials : ExhibitionCredentials, user : User) {
        let uuid = NSUUID().uuidString
        //url path to php file
        let url = URL(string: "http://artscreen.sakura.ne.jp/postExhibition.php")!
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "POST"

        let param = [
            "exhibitionID" : uuid,
            "userID" : user.id,
            "exhibitionName" : exhibitionCredentials.exhibitionName,
            "information" : exhibitionCredentials.information,
            "privacy" : exhibitionCredentials.privacy,
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
        let createBody = AuthService.shared.createBodyWithPath(parameters: param, filePathKey: "file", imageDataKey: imageData, boundary: boundary, filename: "exhibition-\(uuid).jpg")
        request.httpBody = createBody
        
        //launch session
        URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
            DispatchQueue.main.async {
                if error == nil {
                    do {
                        print("DEBUG: -echo \(String(data: data!, encoding: .utf8))")
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
        }.resume()    }
}

