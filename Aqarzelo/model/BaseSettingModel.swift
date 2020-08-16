//
//  BaseSettingModel.swift
//  Aqarzelo
//
//  Created by Hossam on 8/15/20.
//  Copyright © 2020 Hossam. All rights reserved.
//

import Foundation

struct BaseSettingModel:Codable {
    let status: Int
    let messageEn, messageAr: String
    let data: [SettingModel]
    
    enum CodingKeys: String, CodingKey {
        case status
        case messageEn = "message_en"
        case messageAr = "message_ar"
        case data
    }
}

struct SettingModel:Codable {
    let id: Int
    let value, name: String
    var createdAt, updatedAt: String?
//    var createdAt: String?
//    var updatedAt: String?
    
    enum CodingKeys: String, CodingKey {
        case id, value, name
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
