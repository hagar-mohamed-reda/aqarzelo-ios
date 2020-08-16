//
//  BaseNotificationModel.swift
//  Aqarzelo
//
//  Created by Hossam on 8/15/20.
//  Copyright © 2020 Hossam. All rights reserved.
//

import UIKit

struct BaseNotificationModel:Codable {
    let status: Int
    let messageEn, messageAr: String
    let data: [NotificationModel]?
    
    enum CodingKeys: String, CodingKey {
        case status
        case messageEn = "message_en"
        case messageAr = "message_ar"
        case data
    }
}

struct NotificationModel:Codable {
    
    let id: Int
    let title, body: String
    let userID : Int
    var postID :Int?
    
    let seen, titleAr, bodyAr: String
    var createdAt,updatedAt:String?
    
//    let updatedAt: String
    var post: AqarModel?
    
    enum CodingKeys: String, CodingKey {
        case id, title, body
        case postID = "post_id"
        case userID = "user_id"
        case seen
        case titleAr = "title_ar"
        case bodyAr = "body_ar"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case post
    }
}
