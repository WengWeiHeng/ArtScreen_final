//
//  ArtworkService.swift
//  ArtScreen_final
//
//  Created by Heng on 2020/11/19.
//

import Foundation

struct ArtworkService {
    static let shared = ArtworkService()
    
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
