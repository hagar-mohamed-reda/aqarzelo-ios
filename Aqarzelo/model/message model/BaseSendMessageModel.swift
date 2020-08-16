//
//  BaseSendMessageModel.swift
//  Aqarzelo
//
//  Created by Hossam on 8/15/20.
//  Copyright © 2020 Hossam. All rights reserved.
//

import Foundation

struct BaseSendMessageModel:Codable {
    
    let status: Int
    let messageEn, messageAr: String
    let data: MessageModel?
    
    enum CodingKeys: String, CodingKey {
        case status
        case messageEn = "message_en"
        case messageAr = "message_ar"
        case data
    }
}

//struct SendMessageModel:Codable {
//    let userFrom, userTo: Int
//    let message, updatedAt, createdAt: String
//    let id: Int
//    let to, from: FromModel
//
//    enum CodingKeys: String, CodingKey {
//        case userFrom = "user_from"
//        case userTo = "user_to"
//        case message
//        case updatedAt = "updated_at"
//        case createdAt = "created_at"
//        case id, to, from
//    }
//}
