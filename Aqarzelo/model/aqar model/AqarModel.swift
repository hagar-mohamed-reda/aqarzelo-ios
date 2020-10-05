//
//  AqarModel.swift
//  Aqarzelo
//
//  Created by Hossam on 8/15/20.
//  Copyright © 2020 Hossam. All rights reserved.
//

import UIKit

struct AqarModel:Codable {
    
    let id: Int
    let title,titleAr: String
    var datumDescription: String?
    var address: String?
    let lng, lat, phone, space: String
    let pricePerMeter: String
    var refusedReason,floorNumber: String?
    let bedroomNumber, bathroomNumber:String
    var realEstateNumber: String?
    
    var buildDate: String?
    var active: Active?
    let hasGarden, hasParking: Int
    let type, paymentMethod, ownerType: String
    var status :String?
    
    let finishingType: String
    let categoryID, userID, cityID, areaID: Int
    var createdAt, updatedAt: String?
    let price, furnished: Int
    var distance: Double?
    var category: Area?
    let images: [ImageModel]
    var city: Area?
    var area:Area?
    
    let rate, views, rates: Int
    let chartData: ChartData
    let contactPhone: String
    let userReview: [UserReview]
    let favourite: String
    var user: CompanyClass?
    
    enum CodingKeys: String, CodingKey {
        case id, title
        case titleAr="title_ar"
        case datumDescription = "description"
        case address, lng, lat, phone, space
        case pricePerMeter = "price_per_meter"
        case refusedReason = "refused_reason"
        case bedroomNumber = "bedroom_number"
        case bathroomNumber = "bathroom_number"
        case floorNumber = "floor_number"
        case realEstateNumber = "real_estate_number"
        case buildDate = "build_date"
        case active
        case hasGarden = "has_garden"
        case hasParking = "has_parking"
        case type
        case paymentMethod = "payment_method"
        case status
        case ownerType = "owner_type"
        case finishingType = "finishing_type"
        case categoryID = "category_id"
        case userID = "user_id"
        case cityID = "city_id"
        case areaID = "area_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case price, furnished, distance, category, images, city, area, rate, views, rates
        case chartData = "chart_data"
        case contactPhone = "contact_phone"
        case userReview = "user_review"
        case favourite, user
    }
}

// MARK: - Area
struct Area: Codable {
    let id: Int
    let nameAr, nameEn: String
    var cityID: Int?
    var createdAt, updatedAt: String?
    var icon: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case nameAr = "name_ar"
        case nameEn = "name_en"
        case cityID = "city_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case icon
    }
}

enum Active: String, Codable {
    case active = "active"
    case notActive = "not_active"
}




// MARK: - ChartData
struct ChartData: Codable {
    let x: [String]
    let y: [Double]
}

enum ContactPhone: String, Codable {
    case the0115Xxxxxxx = "0115xxxxxxx"
}


// MARK: - Image
struct ImageModel: Codable {
    var id: Int?
    let photo: String
    var postID: Int?
    var createdAt, updatedAt: String?
    var is360: Int?
    let image, src: String
    
    enum CodingKeys: String, CodingKey {
        case id, photo
        case postID = "post_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case is360 = "is_360"
        case image, src
    }
}



enum OwnerType: String, Codable {
    case owner = "owner"
}

enum PaymentMethod: String, Codable {
    case cash = "cash"
    case installment = "installment"
}

enum Status: String, Codable {
    case accepted = "accepted"
}

enum DatumType: String, Codable {
    case rent = "rent"
    case sale = "sale"
}

// MARK: - CompanyClass
class CompanyClass: Codable {
    var id: Int?
    let name, email, password: String
    var lng, lat,photo,cover: String?
    let phone: String
    var address: String?
    let apiToken: String?
    let active: Active
    let type: String?
    let companyID: Int?
    let templeteID, cityID, areaID: Int?
    let firebaseToken: String?
    var attachedFile: String?
    let about: String?
    let facebook: String?
    let youtubeLink: String?
    let youtubeVideo, twitter: String?
    let whatsapp: String?
    let linkedin: String?
    let website: String?
    let websiteAvailableDays: String?
    var rememberToken, smsCode: String?
    let postIDTmp: Int?
    var createdAt: String?
    var updatedAt: String?
    let isExternal: Int?
    let photoURL: String
    let coverURL: String
    var company: CompanyClass?
    let serviceID: Int?
    var commercialNo: String?
    
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
        case company
        case serviceID = "service_id"
        case commercialNo = "commercial_no"
    }
    
    init(id: Int, name: String, email: String, password: String, lng: String?, lat: String?, phone: String, photo: String, cover: String, address: String?, apiToken: String?, active: Active, type: String?, companyID: Int?, templeteID: Int?, cityID: Int?, areaID: Int?, firebaseToken: String?, attachedFile: String?, about: String?, facebook: String?, youtubeLink: String?, youtubeVideo: String?, twitter: String?, whatsapp: String?, linkedin: String?, website: String?, websiteAvailableDays: String?, rememberToken: String?, smsCode: String?, postIDTmp: Int?, createdAt: String?, updatedAt: String, isExternal: Int?, photoURL: String, coverURL: String, company: CompanyClass?, serviceID: Int?, commercialNo: String?) {
        
        self.id = id
        self.name = name
        self.email = email
        self.password = password
        self.lng = lng
        self.lat = lat
        self.phone = phone
        self.photo = photo
        self.cover = cover
        self.address = address
        self.apiToken = apiToken
        self.active = active
        self.type = type
        self.companyID = companyID
        self.templeteID = templeteID
        self.cityID = cityID
        self.areaID = areaID
        self.firebaseToken = firebaseToken
        self.attachedFile = attachedFile
        self.about = about
        self.facebook = facebook
        self.youtubeLink = youtubeLink
        self.youtubeVideo = youtubeVideo
        self.twitter = twitter
        self.whatsapp = whatsapp
        self.linkedin = linkedin
        self.website = website
        self.websiteAvailableDays = websiteAvailableDays
        self.rememberToken = rememberToken
        self.smsCode = smsCode
        self.postIDTmp = postIDTmp
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.isExternal = isExternal
        self.photoURL = photoURL
        self.coverURL = coverURL
        self.company = company
        self.serviceID = serviceID
        self.commercialNo = commercialNo
    }
}


// MARK: - UserReview
struct UserReview: Codable {
    let id, userID: Int
    var postID:Int?
    
    let rate: Rate
    let comment: String?
    var createdAt, updatedAt: String?
    let user: UserReviewUser
    
    enum CodingKeys: String, CodingKey {
        case id
        case postID = "post_id"
        case userID = "user_id"
        case rate, comment
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case user
    }
}
enum Rate: Codable {
    case integer(Int)
    case string(String)
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode(Int.self) {
            self = .integer(x)
            return
        }
        if let x = try? container.decode(String.self) {
            self = .string(x)
            return
        }
        throw DecodingError.typeMismatch(Rate.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for Rate"))
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .integer(let x):
            try container.encode(x)
        case .string(let x):
            try container.encode(x)
        }
    }
}


enum Address: String, Codable {
    case cairo = "cairo"
    case slahaSaleam = "slaha saleam"
    case بنىسويفشارعاحمدعرابي = "بنى سويف شارع احمد عرابي"
}

enum UserType: String, Codable {
    case userCompany = "user_company"
}



//enum Rate: Codable {
//    case integer(Int)
//    case string(String)
//
//    init(from decoder: Decoder) throws {
//        let container = try decoder.singleValueContainer()
//        if let x = try? container.decode(Int.self) {
//            self = .integer(x)
//            return
//        }
//        if let x = try? container.decode(String.self) {
//            self = .string(x)
//            return
//        }
//        throw DecodingError.typeMismatch(Rate.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for Rate"))
//    }
//
//    func encode(to encoder: Encoder) throws {
//        var container = encoder.singleValueContainer()
//        switch self {
//        case .integer(let x):
//            try container.encode(x)
//        case .string(let x):
//            try container.encode(x)
//        }
//    }
//}



// MARK: - UserReviewUser
struct UserReviewUser: Codable {
    let name: String
    let photoURL: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case photoURL = "photo_url"
    }
}

struct BaseAqarModel: Codable {
    
    let status: Int
    let messageEn, messageAr: String
    var data: [AqarModel]?
    
    enum CodingKeys: String, CodingKey {
        case status
        case messageEn = "message_en"
        case messageAr = "message_ar"
        case data
    }
}
