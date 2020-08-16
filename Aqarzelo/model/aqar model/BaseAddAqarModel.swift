//
//  BaseAddAqarModel.swift
//  Aqarzelo
//
//  Created by Hossam on 8/15/20.
//  Copyright © 2020 Hossam. All rights reserved.
//

import Foundation

struct BaseAddAqarModel:Codable {
    
    let status: Int
    let messageEn, messageAr: String
    let data: AddAqarModel
    
    enum CodingKeys: String, CodingKey {
        case status
        case messageEn = "message_en"
        case messageAr = "message_ar"
        case data
    }
}

struct AddAqarModel:Codable {

   
    let id: Int
    let title, dataDescription: String
    var address: String?
    let lng, lat, phone, space: String
    let pricePerMeter: String
    var refusedReason: String?
    let bedroomNumber, bathroomNumber, floorNumber: String
    var realEstateNumber: String?
    let buildDate, active: String
    let hasGarden, hasParking: Int
    let type, paymentMethod, status, ownerType: String
    let finishingType: String
    let categoryID, userID, cityID, areaID: Int
    let createdAt, updatedAt: String
    let price, furnished: Int
    var category: AreaModel?
    let images: [ImageAddModel]
    let city: CityModel
    var area: AreaModel?
    let rate, views, rates: Int
    let chartData: ChartData
    let contactPhone: String
    var userReview: [UserReview]?
    let favourite: String
    let user: UserAddModel
    
    enum CodingKeys: String, CodingKey {
        case id, title
        case dataDescription = "description"
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
        case price, furnished, category, images, city, area, rate, views, rates
        case chartData = "chart_data"
        case contactPhone = "contact_phone"
        case userReview = "user_review"
        case favourite, user
    }
}

class UserAddModel:Codable {
   
    let id: Int
    let name, email, password: String
    let lng, lat: String?
    let phone, photo, cover, address: String
    let apiToken: String?
    let active: String
    let type: String?
    let companyID: Int?
    let templeteID, cityID, areaID: Int?
    let firebaseToken: String?
    var attachedFile: String?
    let about: String?
    let facebook: String
    var youtubeLink, youtubeVideo, twitter, whatsapp: String?
    var linkedin, website: String?
    let websiteAvailableDays: String?
    var rememberToken: String?
    let smsCode: String?
    var postIDTmp: String?
    let createdAt: String?
    let updatedAt: String
    let isExternal: Int?
    let photoURL: String
    let coverURL: String
    let company: UserAddModel?
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
    
    init(id: Int, name: String, email: String, password: String, lng: String?, lat: String?, phone: String, photo: String, cover: String, address: String, apiToken: String?, active: String, type: String?, companyID: Int?, templeteID: Int?, cityID: Int?, areaID: Int?, firebaseToken: String?, attachedFile: String?, about: String?, facebook: String, youtubeLink: String?, youtubeVideo: String?, twitter: String?, whatsapp: String?, linkedin: String?, website: String?, websiteAvailableDays: String?, rememberToken: String?, smsCode: String?, postIDTmp: String?, createdAt: String?, updatedAt: String, isExternal: Int?, photoURL: String, coverURL: String, company: UserAddModel?, serviceID: Int?, commercialNo: String?) {
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

// MARK: - Image
struct ImageAddModel: Codable {
    let photo: String
    let image, src: String
}


