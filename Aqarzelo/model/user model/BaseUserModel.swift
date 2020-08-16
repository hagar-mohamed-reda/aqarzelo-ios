//
//  BaseUserModel.swift
//  Aqarzelo
//
//  Created by Hossam on 8/15/20.
//  Copyright © 2020 Hossam. All rights reserved.
//

import Foundation

struct BaseUserModel:Codable {
    let status: Int
    let messageEn, messageAr: String
    var data: UserModel?
    
    enum CodingKeys: String, CodingKey {
        case status
        case messageEn = "message_en"
        case messageAr = "message_ar"
        case data
    }
    
}

struct UserModel:Codable {
    
    let id: Int
    let email:String
    
    let name: String
    var password:String?
    
    let phone: String?
    var photo,cover:String?

    let apiToken, active, type: String
    let companyID: Int
    
    let firebaseToken: String?

    var attachedFile, about, facebook, youtubeLink: String?
    var youtubeVideo, twitter, whatsapp, linkedin: String?
    var website, websiteAvailableDays, rememberToken: String?
    var templeteID, cityID, areaID: Int?
    var address: String?
    var lng, lat: String?
    
//    let smsCode, postIDTmp: Int
    var smsCode:AnyType?//Int
    var postIDTmp:Int?
    
    var createdAt, updatedAt: String?
    let isExternal: Int
    let photoURL, coverURL: String
    
    
    enum CodingKeys: String, CodingKey {
        case id, name, email, password, lng, lat, phone, photo, cover, address
        case apiToken = "api_token"
        case active, type
        case companyID = "company_id"
        case templeteID = "templete_id"
        case cityID = "city_id"
        case areaID = "area_id"
        case firebaseToken = "firebase_token"
        case attachedFile = "attached_file"
        case about, facebook
        case youtubeLink = "youtube_link"
        case youtubeVideo = "youtube_video"
        case twitter, whatsapp, linkedin, website
        case websiteAvailableDays = "website_available_days"
        case rememberToken = "remember_token"
        case smsCode = "sms_code"
        case postIDTmp = "post_id_tmp"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case isExternal = "is_external"
        case photoURL = "photo_url"
        case coverURL = "cover_url"
    }
}


// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {
    
    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }
    
    public var hashValue: Int {
        return 0
    }
    
    public init() {}
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}
