//
//  RegistrationServices.swift
//  Aqarzelo
//
//  Created by Hossam on 8/15/20.
//  Copyright © 2020 Hossam. All rights reserved.
//


import Alamofire
import GoogleSignIn
import FBSDKLoginKit

class RegistrationServices {
    
    static let shared = RegistrationServices()
    
    
    func registerUser(name:String,email:String,phone:String,password:String,completion:@escaping (BaseRegisterModel?,Error?)->Void)  {
        let urlString = "http://aqarzelo.com/public/api/user/register".toSecrueHttps()
        guard  let url = URL(string: urlString) else { return  }
        
        let postString = "name=\(name)&email=\(email)&phone=\(phone)&password=\(password)"
        
        RegistrationServices.registerationPostMethodGeneric(postString: postString, url: url, completion: completion)
        
    }
    
    func loginUser(phone:String,password:String,completion:@escaping (BaseUserSecondModel?,Error?)->Void)  {
        let urlString = "http://aqarzelo.com/public/api/user/login".toSecrueHttps()
        guard  let url = URL(string: urlString) else { return  }
        let postString = "phone=\(phone)&password=\(password)"
        RegistrationServices.registerationPostMethodGeneric(postString: postString, url: url, completion: completion)
    }
    
    func forgetPassword(phone:String,completion:@escaping (BaseUserSecondModel?,Error?)->Void)  { ////baseusermodel
        let urlString = "http://aqarzelo.com/public/api/user/forget-password".toSecrueHttps()
        guard  let url = URL(string: urlString) else { return  }
        let postString = "phone=\(phone)"
        RegistrationServices.registerationPostMethodGeneric(postString: postString, url: url, completion: completion)
    }
    
    func receiveSmsCode(phone:String,code:String,api_Token:String,password:String,completion:@escaping (BaseUserSecondModel?,Error?)->Void)  {
        let urlString = "http://aqarzelo.com/public/api/user/reset-password".toSecrueHttps()
        guard  let url = URL(string: urlString) else { return  }
        
        let postString = "phone=\(phone)&password=\(password)&api_token=\(api_Token)&sms_code=\(code)"
        RegistrationServices.registerationPostMethodGeneric(postString: postString, url: url, completion: completion)
    }
    
    
    func loginUsingFacebook(vc:UIViewController,completion:@escaping (BaseUserSecondModel?,Error?)->Void )  { //baseusermodel
        
        let fbLoginManager = LoginManager()
        
        fbLoginManager.logIn(permissions: ["email","public_profile"], from: vc) { (res, err) in
            if let err = err {
                completion(nil,err);return
            }
            
            
            GraphRequest(graphPath: "/me", parameters: ["fields": " name, email , picture "]).start { (connection, result, err) in
                if err != nil {
                    
                    completion(nil,err);return
                    
                }
                print(result ?? "")
                let data = result as? [String : Any]
                let email = data?["email"] as? String ?? ""
                let username = data?["name"] as? String ?? ""
                
                let photo = data?["picture"] as? [String:Any] ?? [:]
                let photoData = photo["data"] as?  [String:Any] ?? [:]
                let photoUrl = photoData["url"] as? String ?? ""
                
                self.loginWithExternal(name: username, photo: photoUrl, email: email,completion: completion)
            }
        }
    }
    
    
    func loginWithExternal(name:String,photo:String,email:String,completion:@escaping (BaseUserSecondModel?,Error?)->Void ) { //baseusermodel
        let urlString = "http://aqarzelo.com/public/api/user/external/login".toSecrueHttps()
        guard  let url = URL(string: urlString) else { return  }
        //        let parameters: [String: Any] = [
        //            "email" : email,
        //            "name" : name,
        //            "is_external" : true,
        //            "photo":photo
        //        ]
        
        let postString = "is_external=true&email=\(email)&name=\(name)"
        RegistrationServices.registerationPostMethodGeneric(postString: postString, url: url, completion: completion)
    }
    
    func changeUserPassword(api_token:String,oldPass:String,newPassword:String,completion:@escaping (BaseUserSecondModel?,Error?)->Void)  {
        let urlString = "http://aqarzelo.com/public/api/user/change-password".toSecrueHttps()
        guard  let url = URL(string: urlString) else { return  }
        let postString = "api_token=\(api_token)&password=\(newPassword)&old_password=\(oldPass)"
        
        RegistrationServices.registerationPostMethodGeneric(postString: postString, url: url, completion: completion)
    }
    
    static func registerationPostMethodGeneric<T:Codable>(postString:String,url:URL,completion:@escaping (T?,Error?)->Void)  {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        
        request.httpBody = postString.data(using: .utf8)
        
        URLSession.shared.dataTask(with: request) { (data, response, err) in
            if let error = err {
                completion(nil,error)
            }
            guard let data = data else {return}
            do {
                let objects = try JSONDecoder().decode(T.self, from: data)
                // success
                completion(objects,nil)
            } catch let error {
                completion(nil,error)
            }
        }.resume()
    }
    
    static func registerationGetMethodGenerics<T:Codable>(urlString:String,completion:@escaping (T?,Error?)->Void)  {
        
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { (data, resp, err) in
            if let err = err {
                completion(nil, err)
                return
            }
            do {
                let objects = try JSONDecoder().decode(T.self, from: data!)
                // success
                completion(objects, err)
            } catch let error {
                completion(nil, error)
            }
        }.resume()
    }
    
}
