//
//  BaseUploadImageModel.swift
//  Aqarzelo
//
//  Created by Hossam on 8/15/20.
//  Copyright © 2020 Hossam. All rights reserved.
//

import Foundation

struct BaseUploadImageModel:Codable {
    let status: Int
    let messageEn, messageAr: String
    let data: UploadImageModel?
    
    enum CodingKeys: String, CodingKey {
        case status
        case messageEn = "message_en"
        case messageAr = "message_ar"
        case data
    }
}

struct UploadImageModel:Codable {
    var id: Int?
    var photo: String?
    let postID: Int
    var createdAt, updatedAt: String?
    var is360: Int?
    let image, src: String
    
    enum CodingKeys: String, CodingKey {
        case id, photo
        case postID = "post_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case is360 = "is_360"
        case image, src
    }
}
