//
//  ImagesServices.swift
//  Aqarzelo
//
//  Created by Hossam on 8/15/20.
//  Copyright © 2020 Hossam. All rights reserved.
//


import Foundation

class ImagesServices {
    static let shared = ImagesServices()
    
    func deleteImage(id:Int,token:String,completion:  @escaping (MainWithoutBaseModel?, Error?) -> ())  {
        let urlString = "http://aqarzelo.com/public/api/post/remove-image".toSecrueHttps()
        guard  let url = URL(string: urlString) else { return  }
        let postString = "api_token=\(token)&image_id=\(id)"
        
        RegistrationServices.registerationPostMethodGeneric(postString: postString, url: url, completion: completion)
        //        createGeneralSecondMethod(postString: postString, url: url, completion:completion)
    }
}
