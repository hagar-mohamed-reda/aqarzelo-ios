//
//  BaseRegisterModel.swift
//  Aqarzelo
//
//  Created by Hossam on 8/15/20.
//  Copyright © 2020 Hossam. All rights reserved.
//

import Foundation

struct BaseRegisterModel: Codable {
    
    let status: Int
    let messageEn, messageAr: String
    var data: UserRegisterDone?
    
    enum CodingKeys: String, CodingKey {
        case status
        case messageEn = "message_en"
        case messageAr = "message_ar"
        case data
    }
}

struct UserRegisterDone: Codable {
    
    let name, email, phone, password: String
    var createdAt, updatedAt: String?
//    let updatedAt, createdAt: String
    let id, companyID: Int
    let apiToken: String
    let photoURL, coverURL: String
    
    enum CodingKeys: String, CodingKey {
        case name, email, phone, password
        case updatedAt = "updated_at"
        case createdAt = "created_at"
        case id
        case companyID = "company_id"
        case apiToken = "api_token"
        case photoURL = "photo_url"
        case coverURL = "cover_url"
    }
    
}
