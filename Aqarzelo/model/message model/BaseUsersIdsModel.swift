//
//  BaseUsersIdsModel.swift
//  Aqarzelo
//
//  Created by Hossam on 8/15/20.
//  Copyright © 2020 Hossam. All rights reserved.
//

import Foundation

struct BaseUsersIdsModel:Codable {
    
    let status: Int
    let messageEn, messageAr: String
    let data: [UserIdsModel]?
    
    enum CodingKeys: String, CodingKey {
        case status
        case messageEn = "message_en"
        case messageAr = "message_ar"
        case data
    }
}

struct UserIdsModel:Codable {
    
    let id: Int
    let name, photo, lastMessage: String
    let photoURL: String
    let coverURL: String
    
    enum CodingKeys: String, CodingKey {
        case id, name, photo
        case lastMessage = "last_message"
        case photoURL = "photo_url"
        case coverURL = "cover_url"
    }
}
