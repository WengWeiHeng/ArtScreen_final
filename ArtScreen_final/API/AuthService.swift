//
//  AuthService.swift
//  ArtScreen_final
//
//  Created by Heng on 2020/10/22.
//

import Foundation
import UIKit

struct RegistrationCredentials {
    let email: String
    let password: String
    let username: String
    let firstname: String
    let lastname: String
    let profileImage: UIImage
}

struct AuthService {
    static let shared = AuthService()

    func uploadUser(credentials: RegistrationCredentials) {
        let url = URL(string: "http://artscreen.sakura.ne.jp/secure/register.php")!
        var uid: String = ""
        
        //request to this file
        let request = NSMutableURLRequest(url: url)
        
        //method to pass data to this file (e.g. visa POST)
        request.httpMethod = "POST"
        
        //body to be appended to url
        let body = "username=\(credentials.username.lowercased())&password=\(credentials.password)&email=\(credentials.email)&fullname=\(credentials.firstname)%20\(credentials.lastname)"
        request.httpBody = body.data(using: String.Encoding.utf8)
        URLSession.shared.dataTask(with: request as URLRequest) { (data: Data?, response:URLResponse?, error:Error?) in
            if error == nil {
                //get main queue in code process to communicate back to UI
                DispatchQueue.main.async {
                    do {
                        //get json result
                        let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String:Any]
                        //assign json to new var parseJSON in guard/secured way
                        guard let parseJSON = json else {
                            print("Error while parsing")
                            return
                        }
                        //get id from parseJSON dictionary
                        uid = parseJSON["id"] as! String
                        //successfully uploaded
                        if uid != nil {
                            //save user infomation we received from our host
                            UserDefaults.standard.setValue(parseJSON, forKey: "parseJSON")
                            user = UserDefaults.standard.value(forKey: "parseJSON") as? NSDictionary
                        } else {
                            DispatchQueue.main.async {
                                let message = parseJSON["message"]
                                print(message)
                            }
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
        
        uploadAva(profileImage: credentials.profileImage, uid: uid)
    }
    
    func uploadAva(profileImage: UIImage, uid: String) {
        //shorcut id
        let id = uid
        
        //url path to php file
        let url = URL(string: "http://artscreen.sakura.ne.jp/uploadAva.php")!
        //declare request to this file
        let request = NSMutableURLRequest(url: url)
        //declare method of passign inf to this file
        request.httpMethod = "POST"
        //param to be sent in body of request
        let param = ["id" : id]
        //body
        let boundary = "Boundary-\(NSUUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        //compress image and assign to image imageData var
        guard let imageData = profileImage.jpegData(compressionQuality: 0.5) else { return }
        
        //... body
        request.httpBody = createBodyWithPath(parameters: param, filePathKey: "file", imageDataKey: imageData, boundary: boundary)
        //launc session
        URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
                
            //get main queue to communication back to user
            DispatchQueue.main.async {
                if error == nil {

                    do {
                        //json containes $retrunArray from php
                        let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                        //declare new parseJSON to store json
                        guard let parseJSON =  json else {
                            print("Error while parsing")
                            return
                        }
                        //get id from $returnArray["id"] - parseJSON["id"]

                        let id = parseJSON["id"]
                        //successfully uploaded
                        if id != nil {
                            //save user infomation we received from our host
                            UserDefaults.standard.setValue(parseJSON, forKey: "parseJSON")
                            user = UserDefaults.standard.value(forKey: "parseJSON") as? NSDictionary
                            
                        //did not give back "id" value from sever
                        } else {
                            DispatchQueue.main.async {
                                let message = parseJSON["message"] as! String
                                print(message)
                            }
                        }
                    } catch {
                        print("Caught an error:\(error)")
                        DispatchQueue.main.async {
                            let message = error
                            print(message)
                        }
                    }
                //error while jsoning
                } else {
                    DispatchQueue.main.async {
                        print("DEBUG: Error is \(error?.localizedDescription ?? "")")
                    }
                }
            }
        }.resume()
    }
    
    func createBodyWithPath(parameters: [String : String], filePathKey: String?, imageDataKey: Data, boundary: String) -> Data{
        let body = NSMutableData()
        if parameters != nil {
            for (key, value) in parameters {
                body.appendString(string: "--\(boundary)\r\n")
                body.appendString(string: "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.appendString(string: "\(value)\r\n")
            }
        }
        let filename = "ava.jpg"
        let mimetype = "image/jpg"
        body.appendString(string: "--\(boundary)\r\n")
        body.appendString(string: "Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(filename)\"\r\n")
        body.appendString(string: "Content-Type: \(mimetype)\r\n\r\n")
        body.append(imageDataKey)
        body.appendString(string: "\r\n")
        
        body.appendString(string: "--\(boundary)--\r\n")
            
        
        return body as Data
    }
    
}
