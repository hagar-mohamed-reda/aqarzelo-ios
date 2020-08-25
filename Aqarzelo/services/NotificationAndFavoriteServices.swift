//
//  NotificationAndFavoriteServices.swift
//  Aqarzelo
//
//  Created by Hossam on 8/15/20.
//  Copyright © 2020 Hossam. All rights reserved.
//


import Foundation

class NotificationAndFavoriteServices {
    static let shared = NotificationAndFavoriteServices()
    
    func getAllNotifications(apiToke:String,completion: @escaping (BaseNotificationModel?, Error?) -> ())  {
        //        var token = "edbf412758676e1efe9ff08b564edcfad4c4f97ddf781284d499e48e6f61f53b"
        
        let urlString = "http://aqarzelo.com/public/api/user/notification/get?api_token=\(apiToke)".toSecrueHttps()
        
        RegistrationServices.registerationGetMethodGenerics(urlString: urlString, completion: completion)
    }
    
    func getAllFavorite(apiToken:String,completion: @escaping (BaseFavoriteModel?, Error?) -> ())   {
        let urlString = "http://aqarzelo.com/public/api/user/favourite/get?api_token=\(apiToken)".toSecrueHttps()
        
        RegistrationServices.registerationGetMethodGenerics(urlString: urlString, completion: completion)
    }
}
