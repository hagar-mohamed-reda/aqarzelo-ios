//
//  BaseAdsModel.swift
//  Aqarzelo
//
//  Created by Hossam on 8/15/20.
//  Copyright © 2020 Hossam. All rights reserved.
//

import Foundation

struct BaseAdsModel:Codable {
    let status: Int
    let messageEn, messageAr: String
    let data: [AdsModel]?
    
    enum CodingKeys: String, CodingKey {
        case status
        case messageEn = "message_en"
        case messageAr = "message_ar"
        case data
    }
}

struct AdsModel:Codable {
    
    let id: Int
    let photo, logo: String
    let url: String
    let titleEn, descriptionEn, titleAr, descriptionAr: String
    let expireDate, active, createdAt, updatedAt: String
    let image, logoURL: String
    
    enum CodingKeys: String, CodingKey {
        case id, photo, logo, url
        case titleEn = "title_en"
        case descriptionEn = "description_en"
        case titleAr = "title_ar"
        case descriptionAr = "description_ar"
        case expireDate = "expire_date"
        case active
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case image
        case logoURL = "logo_url"
    }
}
