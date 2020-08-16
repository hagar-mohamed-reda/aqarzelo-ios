//
//  UserServices.swift
//  Aqarzelo
//
//  Created by Hossam on 8/15/20.
//  Copyright © 2020 Hossam. All rights reserved.
//


import Alamofire
import UIKit

class UserServices {
    
    static let shared = UserServices()
    
    func getUserData(apiKey:String,completon:  @escaping (BaseUserSecondModel?,Error?)->Void)  {
        //         prepare json data
        let postString = "api_token=\(apiKey)"
        
        //                let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        
        guard let url = URL(string: "http://aqarzelo.com/public/api/user/profile/update".toSecrueHttps())else {return}
        
        RegistrationServices.registerationPostMethodGeneric(postString: postString, url: url, completion: completon)
        
    }
    
    func getUserPosts(apiKeys:String,completon:  @escaping (BaseAqarModel?,Error?)->Void)  {
        let urlString = "http://aqarzelo.com/public/api/user/post/get?api_token=\(apiKeys)".toSecrueHttps()
        RegistrationServices.registerationGetMethodGenerics(urlString: urlString, completion: completon)
        
    }
    
    func getUserInfo(apiKey:String,completion:  @escaping (UserModel?,Error?)->Void)  {
        let postString = "api_token=\(apiKey)"
        
        //                let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        
        guard let url = URL(string: "http://aqarzelo.com/public/api/user/profile/update".toSecrueHttps())else {return}
        
        RegistrationServices.registerationPostMethodGeneric(postString: postString, url: url, completion: completion)
        
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.httpBody = postString.data(using: .utf8)
//
//        URLSession.shared.dataTask(with: request) { (data, response, err) in
//            if let error = err {
//                 completion(nil,error)
//            }
//            guard let data = data else {return}
//            do {
//                let objects = try JSONDecoder().decode(BaseUserSecondModel.self, from: data)
//                // success
//                let user = objects.data
//               completion(user,nil)
//            } catch let error {
//              completion(nil,error)
//            }
//            }.resume()
    }
    
    func updateProfileUser(token:String,coverImage:UIImage? = UIImage(),photoImage:UIImage? = UIImage(),website:String,phone:String,email:String,address:String,facebook:String,completion: @escaping (BaseUserSecondModel?, Error?) -> ())  {
        
//        let parameters:[String:Any] = [
//            "api_token": token,
//            "website":website,
//            "phone":phone,
//            "email":phone,
//            "address":address,
//            "facebook":facebook
//        ]
        let pageURL = "http://aqarzelo.com/public/api/user/profile/update".toSecrueHttps()
        let postString = pageURL+"?api_token=\(token)&email=\(email)&website=\(website)&facebook=\(facebook)&address=\(address)&phone=\(phone)"
        
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
          
                if let data = coverImage?.pngData() {
                    multipartFormData.append(data, withName: "cover", fileName: "asd.jpeg", mimeType: "image/jpeg")
            }
             
                    if let second = photoImage?.pngData() {
                        multipartFormData.append(second, withName: "photo", fileName: "dsa.jpeg", mimeType: "image/jpeg")
                    }
                
                
            
            
        }, to:postString)
        { (result) in
            switch result {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (progress) in
                    //Print progress
                    print(progress)
                })
                
                upload.responseJSON { response in
                    //print response.result
                    print(response.result)
                    guard let data = response.data else {return}
                    
                    do {
                        let objects = try JSONDecoder().decode(BaseUserSecondModel.self, from: data)
                        // success
                        completion(objects,nil)
                    } catch let error {
                        completion(nil,error)
                    }
                    
                }
                
            case .failure( let encodingError):
                completion(nil,encodingError)
                break
                //print encodingError.description
            }
        }
        
        
        
        
    }
    
}
