//
//  CategoryModel.swift
//  Aqarzelo
//
//  Created by Hossam on 8/15/20.
//  Copyright © 2020 Hossam. All rights reserved.
//

import Foundation

struct CategoryModel : Codable {
    var id : Int?
    let name_ar : String?
    let name_en : String?
    let icon : String?
    let created_at : String?
    let updated_at : String?
    
    enum CodingKeys: String, CodingKey {
        
        case id = "id"
        case name_ar = "name_ar"
        case name_en = "name_en"
        case icon = "icon"
        case created_at = "created_at"
        case updated_at = "updated_at"
    }
    
    
}


struct BaseAqarCategoryModel:Codable {
    
    let status: Int
    let messageEn, messageAr: String
    let data: [CategoryModel]
    
    enum CodingKeys: String, CodingKey {
        case status
        case messageEn = "message_en"
        case messageAr = "message_ar"
        case data
    }
}
