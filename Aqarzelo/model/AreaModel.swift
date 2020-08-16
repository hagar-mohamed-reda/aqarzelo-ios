//
//  AreaModel.swift
//  Aqarzelo
//
//  Created by Hossam on 8/15/20.
//  Copyright © 2020 Hossam. All rights reserved.
//

import Foundation

struct AreaModel :Codable {
    let id: Int
    let nameAr, nameEn: String
    var cityID: Int?
    var createdAt, updatedAt: String?//CreatedAt
//    let updatedAt: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case nameAr = "name_ar"
        case nameEn = "name_en"
        case cityID = "city_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

//enum CreatedAt: String, Codable {
//    case the20190414040825 = "2019-04-14 04:08:25"
//    case the20190502232518 = "2019-05-02 23:25:18"
//}



struct BaseAqarAreaModel: Codable {
    
    
    let status: Int
    let messageEn, messageAr: String
    var data: [AreaModel]?
    
    enum CodingKeys: String, CodingKey {
        case status
        case messageEn = "message_en"
        case messageAr = "message_ar"
        case data
    }
}
