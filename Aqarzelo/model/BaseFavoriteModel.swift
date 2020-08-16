//
//  BaseFavoriteModel.swift
//  Aqarzelo
//
//  Created by Hossam on 8/15/20.
//  Copyright © 2020 Hossam. All rights reserved.
//

import Foundation

struct BaseFavoriteModel:Codable {
    let status: Int
    let messageEn, messageAr: String
    let data: AqarModel?
    
    enum CodingKeys: String, CodingKey {
        case status
        case messageEn = "message_en"
        case messageAr = "message_ar"
        case data
    }
}
