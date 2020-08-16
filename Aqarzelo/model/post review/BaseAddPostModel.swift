//
//  BaseAddPostModel.swift
//  Aqarzelo
//
//  Created by Hossam on 8/15/20.
//  Copyright © 2020 Hossam. All rights reserved.
//

import Foundation

struct BaseAddPostModel:Codable {
    
    let status: Int
    let messageEn, messageAr: String
    let data: AddPostModel?
    
    enum CodingKeys: String, CodingKey {
        case status
        case messageEn = "message_en"
        case messageAr = "message_ar"
        case data
    }
}

struct AddPostModel:Codable {
    
    let id: Int
    let postID: String
    let userID: Int
    var rate:Int?//String?
    
    var comment:String?
    let createdAt:String
    var   updatedAt: String?
    let user: UserPostSecondModel
    
    enum CodingKeys: String, CodingKey {
        case id
        case postID = "post_id"
        case userID = "user_id"
        case rate, comment
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case user
    }
}
