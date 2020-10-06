//
//  CityModel.swift
//  Aqarzelo
//
//  Created by Hossam on 8/15/20.
//  Copyright © 2020 Hossam. All rights reserved.
//

import Foundation

struct CityModel:Codable {
    
    let id: Int
    let nameAr, nameEn: String
    var createdAt, updatedAt:String?
    var countryId: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case nameAr = "name_ar"
        case nameEn = "name_en"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case countryId = "country_id"
    }
}


struct BaseAqarCityModel: Codable {
    
    let status: Int
    let messageEn, messageAr: String
    let data: [CityModel]
    
    enum CodingKeys: String, CodingKey {
        case status
        case messageEn = "message_en"
        case messageAr = "message_ar"
        case data
    }
}
