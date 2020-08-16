//
//  MessagesServices.swift
//  Aqarzelo
//
//  Created by Hossam on 8/15/20.
//  Copyright © 2020 Hossam. All rights reserved.
//


import Foundation

class MessagesServices {
    static let shared = MessagesServices()
    
    func getMessages(api_token:String,user_to:Int,completion:@escaping (BaseMessageModel?, Error?) -> Void)  {
        //         let apiToke = "ad4b2b9db4feaab6852977113468945cd7b787e0cb59cd122225c40dc566b112"
        let urlString = "http://aqarzelo.com/public/api/chat/get?api_token=\(api_token)&user_to=\(user_to)".toSecrueHttps()
        
        
        RegistrationServices.registerationGetMethodGenerics(urlString: urlString, completion: completion)
    }
    
    func getUsersIds(api_token:String,completion:@escaping ([UserIdsModel]?,[Int]?, Error?) -> Void)  {
        //        let apiToke = "ad4b2b9db4feaab6852977113468945cd7b787e0cb59cd122225c40dc566b112"
        
        let urlString = "http://aqarzelo.com/public/api/chat/user/get?api_token=\(api_token)".toSecrueHttps()
        
        fetchGenericJSONData(urlString: urlString, completion: completion)
        //        fetchGenericJSONData(urlString: urlString, completion: completion)
    }
    
    func sendMessage(message:String,token:String,toUser:String,completion: @escaping (BaseSendMessageModel?, Error?)-> Void)  {
        //     let apiToke = "ad4b2b9db4feaab6852977113468945cd7b787e0cb59cd122225c40dc566b112"
        let urlString = "http://aqarzelo.com/public/api/chat/send".toSecrueHttps()
        guard  let url = URL(string: urlString) else { return  }
        let postString = "api_token=\(token)&user_to=\(toUser)&message=\(message)"
        
        RegistrationServices.registerationPostMethodGeneric(postString: postString, url: url, completion: completion)
        
        //            var request = URLRequest(url: url)
        //            request.httpMethod = "POST"
        //
        //
        //            request.httpBody = postString.data(using: .utf8)
        //
        //            URLSession.shared.dataTask(with: request) { (data, response, err) in
        //                if let error = err {
        //                    completion(nil,error)
        //                }
        //                guard let data = data else {return}
        //                do {
        //                    let objects = try JSONDecoder().decode(BaseSendMessageModel.self, from: data)
        //                    // success
        //                    completion(objects,nil)
        //                } catch let error {
        //                    completion(nil,error)
        //                }
        //                }.resume()
        
    }
    
    
    func fetchGenericJSONData(urlString:String, completion: @escaping ([UserIdsModel]?,[Int]?, Error?) -> ())  {
        var userId = [Int]()
        
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { (data, resp, err) in
            if let err = err {
                completion(nil,nil, err)
                return
            }
            do {
                let objects = try JSONDecoder().decode(BaseUsersIdsModel.self, from: data!)
                // success
                print(objects)
                let data = objects.data
                
                data?.forEach({ (user) in
                    userId.append(user.id)
                    
                })
                completion(data,userId, err)
                
            } catch let error {
                completion(nil,nil, error)
            }
            }.resume()
    }
}
