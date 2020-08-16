//
//  BaseMessageModel.swift
//  Aqarzelo
//
//  Created by Hossam on 8/15/20.
//  Copyright © 2020 Hossam. All rights reserved.
//

import Foundation

struct BaseMessageModel:Codable {
    let status: Int
    let messageEn, messageAr: String
    let data: [MessageModel]?
    
    enum CodingKeys: String, CodingKey {
        case status
        case messageEn = "message_en"
        case messageAr = "message_ar"
        case data
    }
}

struct MessageModel:Codable {
    
    let id: Int
    var seen: String?
    let userFrom,userTo: Int
    let  message, createdAt, updatedAt: String
    let to, from: FromModel
    
    enum CodingKeys: String, CodingKey {
        case id, seen
        case userFrom = "user_from"
        case userTo = "user_to"
        case message
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case to, from
    }
}

struct FromModel:Codable {

     let name: String
     let photo: String
//    let name: Name
//    let photo: Photo
    let photoURL: String
    let coverURL: String
    
    enum CodingKeys: String, CodingKey {
        case name, photo
        case photoURL = "photo_url"
        case coverURL = "cover_url"
    }
}

//enum Name: String, Codable {
//    case ahmedElbanna = "ahmed elbanna"
//    case معتزاشر" =  معتز اشرف"
//}

//enum Photo: String, Codable {
//    case the158065323316842Jpg = "158065323316842.jpg"
//    case the158089391098332JPEG = "158089391098332.jpeg"
//}
