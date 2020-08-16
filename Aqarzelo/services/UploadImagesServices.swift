//
//  UploadImagesServices.swift
//  Aqarzelo
//
//  Created by Hossam on 8/15/20.
//  Copyright © 2020 Hossam. All rights reserved.
//


import Foundation
import Alamofire

class UploadImagesServices {
    static let shared = UploadImagesServices()
    
    func getAllUserImages(api_token:String,completion:@escaping (BaseImageModel?, Error?) -> Void)  {
        
        let urlString = "http://aqarzelo.com/public/api/post/image/get?api_token=\(api_token)".toSecrueHttps()
        //        fetchGenericJSONData(urlString: urlString,completion: completion)
        RegistrationServices.registerationGetMethodGenerics(urlString: urlString, completion: completion)
    }
    
    func getAllUserImagesWithPostId(postId:Int,api_token:String,completion:@escaping (BaseImageModel?, Error?) -> Void)  {
        
        let urlString = "http://aqarzelo.com/public/api/post/image/get?api_token=\(api_token)&post_id=\(postId)".toSecrueHttps()
        //        fetchGenericJSONData(urlString: urlString,completion: completion)
        RegistrationServices.registerationGetMethodGenerics(urlString: urlString, completion: completion)
    }
    
    func removeImageUsingImageId(api_token:String,id:Int,completion:@escaping (BaseImageModel?, Error?) -> Void)  {
        let urlString = "http://aqarzelo.com/public/api/post/remove-image".toSecrueHttps()
        guard  let url = URL(string: urlString) else { return  }
        let postUrl = "api_token=\(api_token)&id=\(id)"
        //        removeGeneralMethod(postString: postUrl, url: url, completion: completion)
        RegistrationServices.registerationPostMethodGeneric(postString: postUrl, url: url, completion: completion)
    }
}

