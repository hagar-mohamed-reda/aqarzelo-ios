//
//  FilterServices.swift
//  Aqarzelo
//
//  Created by Hossam on 8/15/20.
//  Copyright © 2020 Hossam. All rights reserved.
//


import Foundation


class FilterServices {
    static let shared = FilterServices()
    
    func getCities(completion: @escaping (BaseAqarCityModel?, Error?) -> ())  {
        let urlString = "http://aqarzelo.com/public/api/city/get".toSecrueHttps()
        //        fetchGenericJSONData(urlString: urlString,completion: completion)
        RegistrationServices.registerationGetMethodGenerics(urlString: urlString, completion: completion)
    }
    
    func getCountries(completion: @escaping (BaseAqarCategoryModel?, Error?) -> ())  {
        let urlString = "http://aqarzelo.com/public/api/country/get".toSecrueHttps()
        //        fetchGenericJSONData(urlString: urlString,completion: completion)
        RegistrationServices.registerationGetMethodGenerics(urlString: urlString, completion: completion)
    }
    
    func getCategoriess(completion: @escaping (BaseAqarCategoryModel?, Error?) -> ())  {
        let urlString = "http://aqarzelo.com/public/api/category/get".toSecrueHttps()
        //        fetchGenericJSONData(urlString: urlString,completion: completion)
        RegistrationServices.registerationGetMethodGenerics(urlString: urlString, completion: completion)
    }
    
    func getAreaAccordingToCity(id:Int,completion: @escaping (BaseAqarAreaModel?, Error?) -> ())  {
        let urlString = "http://aqarzelo.com/public/api/area/get?city_id=\(id)".toSecrueHttps()
        //        fetchGenericJSONData(urlString: urlString,completion: completion)
        RegistrationServices.registerationGetMethodGenerics(urlString: urlString, completion: completion)
    }
    
    func getAllAreas(completion: @escaping (BaseAqarAreaModel?, Error?) -> ())  {
        let urlString = "http://aqarzelo.com/public/api/area/get".toSecrueHttps()
        //        fetchGenericJSONData(urlString: urlString,completion: completion)
        RegistrationServices.registerationGetMethodGenerics(urlString: urlString, completion: completion)
    }
    
    
    
    //    func fetchGenericJSONData<T: Codable>(urlString:String, completion: @escaping (T?, Error?) -> ())  {
    //
    //        guard let url = URL(string: urlString) else { return }
    //        URLSession.shared.dataTask(with: url) { (data, resp, err) in
    //            if let err = err {
    //              completion(nil, err)
    //                return
    //            }
    //            do {
    //                let objects = try JSONDecoder().decode(T.self, from: data!)
    //                // success
    //               completion(objects, err)
    //            } catch let error {
    //                 completion(nil, error)
    //            }
    //            }.resume()
    //    }
}
