//
//  BaseGetPostModel.swift
//  Aqarzelo
//
//  Created by Hossam on 8/15/20.
//  Copyright © 2020 Hossam. All rights reserved.
//

import Foundation
struct BaseGetPostModel:Codable {
    
    let status: Int
    let messageEn, messageAr: String
    var data: [GetPostModel]?
    
    enum CodingKeys: String, CodingKey {
        case status
        case messageEn = "message_en"
        case messageAr = "message_ar"
        case data
    }
}

struct GetPostModel:Codable {
    var comment: String?
    var rate: Int?
    let createdAt: String
    let user: UserPostSecondModel
    
    enum CodingKeys: String, CodingKey {
        case comment, rate
        case createdAt = "created_at"
        case user
    }
}
struct UserPostSecondModel:Codable {
    var name, photoURL: String?
    
    enum CodingKeys: String, CodingKey {
        case name
        case photoURL = "photo_url"
    }
}
