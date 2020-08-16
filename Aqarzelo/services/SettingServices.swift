//
//  SettingServices.swift
//  Aqarzelo
//
//  Created by Hossam on 8/15/20.
//  Copyright © 2020 Hossam. All rights reserved.
//



import Foundation


class SettingServices {
    static let shared = SettingServices()
    
    func getAllSettings(completion: @escaping (BaseSettingModel?, Error?) -> ())  {
        let urlString = "http://aqarzelo.com/public/api/setting/get".toSecrueHttps()
        RegistrationServices.registerationGetMethodGenerics(urlString: urlString, completion: completion)
//        FilterServices.shared.fetchGenericJSONData(urlString: urlString, completion: completion)
    }
}
