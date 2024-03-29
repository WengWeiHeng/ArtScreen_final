//
//  ArtworkItemService.swift
//  ArtScreen_final
//
//  Created by Heng on 2020/12/3.
//

import Foundation
import UIKit

struct ArtworkItemCredentials {
    let artworkItemImage: UIImage?
    let width: Float
    let height: Float
    let x: Float
    let y: Float
    let scaleTo: Float
    let scaleFrom: Float
    let scaleSpeed: Float
    let rotateTo: Float
    let rotateFrom: Float
    let rotateSpeed: Float
    let opacityTo: Float
    let opacityFrom: Float
    let opacitySpeed: Float
    let emitterBlue: Float
    let emitterRed: Float
    let emitterGreen: Float
    let emitterSize: Float
    let emitterSpeed: Float
}

struct ArtworkItemService {
    static let shared = ArtworkItemService()
    
    func uploadArtworkItem(artworkID: String, user: User, artworkItem : ArtworkItemCredentials) {
        let url = URL(string: POST_ITEM_ARTWORK_URL)!
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "POST"

        let param = [
            "artworkID": artworkID,
            "userID": user.id,
            "width": artworkItem.width,
            "height": artworkItem.height,
            "x": artworkItem.x,
            "y": artworkItem.y,
            "scaleTo": artworkItem.scaleTo,
            "scaleFrom": artworkItem.scaleFrom,
            "scaleSpeed": artworkItem.scaleSpeed,
            "rotateTo": artworkItem.rotateTo,
            "rotateFrom": artworkItem.rotateFrom,
            "rotateSpeed": artworkItem.rotateSpeed,
            "opacityTo": artworkItem.opacityTo,
            "opacityFrom": artworkItem.opacityFrom,
            "opacitySpeed": artworkItem.opacitySpeed,
            "emitterBlue": artworkItem.emitterBlue,
            "emitterRed": artworkItem.emitterRed,
            "emitterGreen": artworkItem.emitterGreen,
            "emitterSize": artworkItem.emitterSize,
            "emitterSpeed": artworkItem.emitterSpeed
        ] as [String : Any]

        //body
        let boundary = "Boundary-\(NSUUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        //if picture is selected, compress it by half
        var imageData = Data()
        
        imageData = artworkItem.artworkItemImage!.pngData()!
        //... body
        print(param)

        request.httpBody = AuthService.shared.createBodyWithPath(parameters: param, filePathKey: "file", imageDataKey: imageData, boundary: boundary, filename: "artworkItem-\(artworkID).png", mimetype: "image/png")
        print("DEBUG: Update ArtworkItem")
        //launch session
        URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
            DispatchQueue.main.async {
                if error == nil {
                    do {
                        //json containers $returnArray from php
                        let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary

                        //declare new var to store json inf
                        guard json != nil else {
                            print("Error while parsing")
                            return
                        }
                    } catch {
                        print("DEBUG: Error:\(error) in catch")
                    }
                } else {
                    print("Error:\(error?.localizedDescription ?? "") in error else")
                }
            }
        }.resume()
    }
    
    func fetchArtworkItem(artwork: ArtworkDetail, completion: @escaping(ArtworkItem) -> Void) {
        let url = URL(string: GET_ARTWORKITEM_URL)!
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "POST"
        let body = "artworkID=\(artwork.artworkID)"
        request.httpBody = body.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { (data, _, _) in
            guard let jsonData = data else {
                print("DEBUG: data is nil..")
                return
            }
//            print("DEBUG: user artwork data: \(String(data: data!, encoding: .utf8))")

            do {
                let decoder = JSONDecoder()
                let artworkItem = try decoder.decode(ArtworkItem.self, from: jsonData)
//                let artworkItemDetail = artworkItem.artworkItemDetail
                completion(artworkItem)
            } catch {
                print("DEBUG: \(error.localizedDescription) in fetchArtwork Item")
            }
        }
        task.resume()
    }
}

