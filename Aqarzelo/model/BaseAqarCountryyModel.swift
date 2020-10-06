//
//  BaseAqarCountryyModel.swift
//  Aqarzelo
//
//  Created by Hossam on 10/6/20.
//  Copyright © 2020 Hossam. All rights reserved.
//

import UIKit

struct BaseAqarCountryyModel :Codable {
    
    let status: Int
    let messageEn, messageAr: String
    let data: [CountryModel]
    
    enum CodingKeys: String, CodingKey {
        case status
        case messageEn = "message_en"
        case messageAr = "message_ar"
        case data
    }
}

struct CountryModel:Codable {
    
    let id: Int
    let nameAr, nameEn: String
    var createdAt, updatedAt,icon:String?
    
    enum CodingKeys: String, CodingKey {
        case id,icon
        case nameAr = "name_ar"
        case nameEn = "name_en"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
