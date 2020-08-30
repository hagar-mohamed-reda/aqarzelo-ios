//
//  PostServices.swift
//  Aqarzelo
//
//  Created by Hossam on 8/15/20.
//  Copyright © 2020 Hossam. All rights reserved.
//


import Alamofire


class PostServices{
    static let shared = PostServices()
    
    
    
    
    func getFilteredSearchPost(price1:Int,price2:Int,bedroom_number:Int,bathroom_number:Int,type:String,city_id:Int,area_id:Int,space1:Int,space2:Int,completion: @escaping (BaseAqarModel?, Error?) -> ())  {
        let urlString = "http://aqarzelo.com/public/api/post/search?price1=\(price1)&price2=\(price2)&bedroom_number=\(bedroom_number)&bathroom_number=\(bathroom_number)&type=\(type)&city_id=\(city_id)&area_id=\(area_id)&space1=\(space1)&space2=\(space2)".toSecrueHttps()
        
        RegistrationServices.registerationGetMethodGenerics(urlString: urlString, completion: completion)
        //        PostServices.fetchGenericJSONData(urlString: urlString, completion: completion)
    }
    
    func getPostsUsingLocation(lat:Double,longi:Double,completion: @escaping (BaseAqarModel?, Error?) -> ())  {
        //        let lats = "30.048193" //default values
        //        let long = "31.244216" //default values
        
        let urlString = "http://aqarzelo.com/public/api/post/search?lat=\(lat)&lng=\(longi)".toSecrueHttps()
        RegistrationServices.registerationGetMethodGenerics(urlString: urlString, completion: completion)
        //        PostServices.fetchGenericJSONData(urlString: urlString, completion: completion)
    }
    
    func getPostsRecommended(completion: @escaping (BaseAqarModel?, Error?) -> ())  {
        //        let lats = "30.048193" //default values
        //        let long = "31.244216" //default values
        
        let urlString = "http://aqarzelo.com/public/api/post/recommended?finishing_type=lux&city_id=1&price=1000000".toSecrueHttps()
        RegistrationServices.registerationGetMethodGenerics(urlString: urlString, completion: completion)
        //        PostServices.fetchGenericJSONData(urlString: urlString, completion: completion)
    }
    
    func getPostsUsingSearchData(category_id:Int,price2:Int,price1:Int,bedNumber:Int,bathNumber:Int,type:String,city_id:Int,area_id:Int,completion: @escaping (BaseAqarModel?, Error?) -> ()) {
        
        let urlString = "http://aqarzelo.com/public/api/post/search?price1=\(price1)&price2=\(price2)&bedroom_number=\(bedNumber)&bathroom_number=\(bathNumber)&type=\(type)&city_id=\(city_id)&area_id=\(area_id)&category_id=\(category_id)".toSecrueHttps()
        RegistrationServices.registerationGetMethodGenerics(urlString: urlString, completion: completion)
        //        PostServices.fetchGenericJSONData(urlString: urlString, completion: completion)
    }
    
    func deletePost(api_token:String,post_id:Int,completion:  @escaping (MainWithoutBaseModel?, Error?) -> ())  {
        
        let urlString = "http://aqarzelo.com/public/api/user/post/remove".toSecrueHttps()
        guard  let url = URL(string: urlString) else { return  }
        let postString = "api_token=\(api_token)&post_id=\(post_id)"
        
        RegistrationServices.registerationPostMethodGeneric(postString: postString, url: url, completion: completion)
        
    }
    
    //MARK: -add post or comment in aqar
    
    func addPost(api_token:String,post_id:Int,comment:String? = nil,rate:Int? = nil,completion:  @escaping (BaseAddPostModel?, Error?) -> Void)  {
        var postString:String!
        
        let urlString = "http://aqarzelo.com/public/api/user/review/add".toSecrueHttps()
        guard  let url = URL(string: urlString) else { return  }
        postString = (rate != nil) ? "api_token=\(api_token)&post_id=\(post_id)&rate=\(rate!)" : "api_token=\(api_token)&post_id=\(post_id)&comment=\(comment!)"
        
        RegistrationServices.registerationPostMethodGeneric(postString: postString, url: url, completion: completion)
        
        //        createGeneralSecondMethod(postString: postString, url: url, completion:completion)
    }
    
    func getPostReviewsUsingMacAddress(postId:Int,mac_address:String,completion:  @escaping (BaseAddPostModel?, Error?) -> Void)  {
        let urlString = "http://aqarzelo.com/public/api/post/add-view?mac_address=\(mac_address)&post_id=\(postId)".toSecrueHttps()
        
        RegistrationServices.registerationGetMethodGenerics(urlString: urlString, completion: completion)
        //    fetchGenericJSONData(urlString: urlString, completion: completion)
    }
    
    func getPostReviews(post_id:Int,completion:  @escaping (BaseGetPostModel?, Error?) -> ())  {
        let urlString = "http://aqarzelo.com/public/api/user/review/get?post_id=\(post_id)".toSecrueHttps()
        RegistrationServices.registerationGetMethodGenerics(urlString: urlString, completion: completion)
        //        fetchGenericJSONData(urlString: urlString, completion: completion)
    }
    
    func getPostAds(completion:  @escaping (BaseAdsModel?, Error?) -> ())  {
        let urlString = "http://aqarzelo.com/public/api/ads/get".toSecrueHttps()
        RegistrationServices.registerationGetMethodGenerics(urlString: urlString, completion: completion)
        //        fetchGenericJSONData(urlString: urlString, completion: completion)
    }
    
    func getPostUsingId(post_id:Int,completion:  @escaping (BaseFavoriteModel?, Error?) -> ())  {
        let urlString = "http://aqarzelo.com/public/api/post/get?post_id=\(post_id)".toSecrueHttps()
        RegistrationServices.registerationGetMethodGenerics(urlString: urlString, completion: completion)
        //        fetchGenericJSONData(urlString: urlString, completion: completion)
    }
    
    func uploadImagessss(photoModel:SecondPhotoModel,token:String,completion:  @escaping (BaseUploadImageModel?, Error?) -> ())  {
           typealias imageUploadCompleteTuple = (title:String,filUrl:String)
           //        let pageURL = "http://aqarzelo.com/public/api/post/add-image".toSecrueHttps()
           let pageURL = "http://aqarzelo.com/public/api/post/add-image?api_token=\(token)".toSecrueHttps()
           
           let parameters = [
               "api_token": token
           ]
           //        let pageURL = "http://aqarzelo.com/public/api/post/add-image".toSecrueHttps()
           Alamofire.upload(multipartFormData: { multipartFormData in
               
               if let photo =    photoModel.image?.pngData() {
                   multipartFormData.append(photo, withName: "photo", fileName: "swift_file.png", mimeType: "image/png")
               }
               
           }, to: pageURL, method: .post, headers: nil,
              encodingCompletion: { encodingResult in
               switch encodingResult {
               case .success(let upload, _, _):
                   
                   upload.uploadProgress(closure: { (progress) in
                       //Print progress
                       NotificationCenter.default.post(name: .uoloadProgress, object: nil, userInfo: ["image":photoModel.image,"name":photoModel.name,"size":photoModel.size,"progress":progress.fractionCompleted])
                   })
                   
                   upload.responseJSON { response in
                       NotificationCenter.default.post(name: .uploadComplete, object: imageUploadCompleteTuple.self, userInfo: nil)
                       //print response.result
                       print(response.result)
                       guard let data = response.data else {return}
                       //
                       do {
                           let objects = try JSONDecoder().decode(BaseUploadImageModel.self, from: data)
                           // success
                           completion(objects,nil)
                       } catch let error {
                           completion(nil,error)
                       }
                       
                   }
               case .failure(let encodingError):
                   completion(nil,encodingError)
               }
           })
       }
    
    func uploadImagess(photoModel:PhotoModel,token:String,completion:  @escaping (BaseUploadImageModel?, Error?) -> ())  {
        typealias imageUploadCompleteTuple = (title:String,filUrl:String)
        //        let pageURL = "http://aqarzelo.com/public/api/post/add-image".toSecrueHttps()
        let pageURL = "http://aqarzelo.com/public/api/post/add-image?api_token=\(token)".toSecrueHttps()
        
        let parameters = [
            "api_token": token
        ]
        //        let pageURL = "http://aqarzelo.com/public/api/post/add-image".toSecrueHttps()
        Alamofire.upload(multipartFormData: { multipartFormData in
            
            if let photo =    photoModel.image?.pngData() {
                multipartFormData.append(photo, withName: "photo", fileName: "swift_file.png", mimeType: "image/png")
            }
            
        }, to: pageURL, method: .post, headers: nil,
           encodingCompletion: { encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (progress) in
                    //Print progress
                    NotificationCenter.default.post(name: .uoloadProgress, object: nil, userInfo: ["image":photoModel.image,"name":photoModel.name,"size":photoModel.size,"progress":progress.fractionCompleted])
                })
                
                upload.responseJSON { response in
                    NotificationCenter.default.post(name: .uploadComplete, object: imageUploadCompleteTuple.self, userInfo: nil)
                    //print response.result
                    print(response.result)
                    guard let data = response.data else {return}
                    //
                    do {
                        let objects = try JSONDecoder().decode(BaseUploadImageModel.self, from: data)
                        // success
                        completion(objects,nil)
                    } catch let error {
                        completion(nil,error)
                    }
                    
                }
            case .failure(let encodingError):
                completion(nil,encodingError)
            }
        })
    }
    
    func uploadOtherImagesss(index:Int,photoModel:SecondPhotoModel,token:String,completion:  @escaping (BaseUploadImageModel?, Error?) -> ())  {
        typealias imageUploadCompleteTuple = (title:String,filUrl:String)
        
        let pageURL = "http://aqarzelo.com/public/api/post/add-image?api_token=\(token)".toSecrueHttps()
        Alamofire.upload(multipartFormData: { multipartFormData in
            if let imageData = photoModel.image?.pngData() {
                let name = UUID().uuidString
                multipartFormData.append(imageData, withName: "photo", fileName: "\(name).png", mimeType: "image/png")
            }
            
        }, to: pageURL, method: .post, headers: nil,
           encodingCompletion: { encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (progress) in
                    //Print progress
                    NotificationCenter.default.post(name: .uoloadNextProgress, object: nil, userInfo: ["image":photoModel.image,"name":photoModel.name,"size":photoModel.size,"progress":progress.fractionCompleted,"index":index])
                })
                
                upload.responseJSON { response in
                    NotificationCenter.default.post(name: .uploadNextComplete, object: imageUploadCompleteTuple.self, userInfo:[ "index":index])
                    //print response.result
                    print(response.result)
                    guard let data = response.data else {return}
                    //
                    do {
                        let objects = try JSONDecoder().decode(BaseUploadImageModel.self, from: data)
                        // success
                        completion(objects,nil)
                    } catch let error {
                        completion(nil,error)
                    }
                    
                }
            case .failure(let encodingError):
                print("error:\(encodingError)")
            }
        })
    }
    
    func uploadOtherImagess(index:Int,photoModel:PhotoModel,token:String,completion:  @escaping (BaseUploadImageModel?, Error?) -> ())  {
        typealias imageUploadCompleteTuple = (title:String,filUrl:String)
        
        let pageURL = "http://aqarzelo.com/public/api/post/add-image?api_token=\(token)".toSecrueHttps()
        Alamofire.upload(multipartFormData: { multipartFormData in
            if let imageData = photoModel.image?.pngData() {
                let name = UUID().uuidString
                multipartFormData.append(imageData, withName: "photo", fileName: "\(name).png", mimeType: "image/png")
            }
            
        }, to: pageURL, method: .post, headers: nil,
           encodingCompletion: { encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (progress) in
                    //Print progress
                    NotificationCenter.default.post(name: .uoloadNextProgress, object: nil, userInfo: ["image":photoModel.image,"name":photoModel.name,"size":photoModel.size,"progress":progress.fractionCompleted,"index":index])
                })
                
                upload.responseJSON { response in
                    NotificationCenter.default.post(name: .uploadNextComplete, object: imageUploadCompleteTuple.self, userInfo: nil)
                    //print response.result
                    print(response.result)
                    guard let data = response.data else {return}
                    //
                    do {
                        let objects = try JSONDecoder().decode(BaseUploadImageModel.self, from: data)
                        // success
                        completion(objects,nil)
                    } catch let error {
                        completion(nil,error)
                    }
                    
                }
            case .failure(let encodingError):
                print("error:\(encodingError)")
            }
        })
    }
    
    
    func getUserPosts(token:String,completion: @escaping (BasePostModel?, Error?) -> ())  {
        //        let tokens = "1c757f9c545396dfb8918f2da9b4b6348c4ec12650a4a209f6456e43b40f2566"
        
        let urlString = "http://aqarzelo.com/public/api/user/post/get?api_token=\(token)".toSecrueHttps()
        
        RegistrationServices.registerationGetMethodGenerics(urlString: urlString, completion: completion)
        //        PostServices.fetchGenericJSONData(urlString: urlString, completion: completion)
    }
    
    func updatePost(api_token:String,title:String,description:String,category_id:Int,city_id:Int,area_id:Int,type:String,lat:Double,lng:Double,owner_type:String,space:Double,price_per_meter:Double,payment_method:String,finishing_type:String,bedroom_number:Int,bathroom_number:Int,floor_number:Int,has_garden:Int,has_parking:Int,has_furnished:Int,build_date:String,totalPrice:Double,postId:Int,completion: @escaping (BaseUpdateAqarModel?, Error?) -> ())  {
        
        //real_estate_number  == build number
        
        let urlString = "http://aqarzelo.com/public/api/post/update".toSecrueHttps()
        guard  let url = URL(string: urlString) else { return  }
        let postString = "api_token=\(api_token)&title=\(title)&description=\(description)&category_id=\(category_id)&city_id=\(city_id)&area_id=\(area_id)&type=\(type)&lat=\(lat)&lng=\(lng)&owner_type=\(owner_type)&space=\(space)&price_per_meter=\(price_per_meter)&payment_method=\(payment_method)&bedroom_number=\(bedroom_number)&bathroom_number=\(bathroom_number)&floor_number=\(floor_number)&finishing_type=\(finishing_type)&has_garden=\(has_garden)&has_parking=\(has_parking)&furnished=\(has_furnished)&build_date=\(build_date)&price=\(totalPrice)&post_id=\(postId)"
        
        
        RegistrationServices.registerationPostMethodGeneric(postString: postString, url: url, completion: completion)
        
        //        createGeneralSecondMethod(postString: postString, url: url, completion:completion)
        
    }
    
    func addTotalPost(api_token:String,title:String,description:String,category_id:Int,city_id:Int,area_id:Int,type:String,lat:Double,lng:Double,owner_type:String,space:Double,price_per_meter:Int,payment_method:String,finishing_type:String,bedroom_number:Int,bathroom_number:Int,floor_number:Int,has_garden:Int,has_parking:Int,has_furnished:Int,build_date:String,totalPrice:Int,completion: @escaping (BaseAddAqarModel?, Error?) -> ())  {
        
        //real_estate_number  == build number
        
        let urlString = "http://aqarzelo.com/public/api/post/add".toSecrueHttps()
        guard  let url = URL(string: urlString) else { return  }
        let postString = "api_token=\(api_token)&title=\(title)&description=\(description)&category_id=\(category_id)&city_id=\(city_id)&area_id=\(area_id)&type=\(type)&lat=\(lat)&lng=\(lng)&owner_type=\(owner_type)&space=\(space)&price_per_meter=\(price_per_meter)&payment_method=\(payment_method)&bedroom_number=\(bedroom_number)&bathroom_number=\(bathroom_number)&floor_number=\(floor_number)&finishing_type=\(finishing_type)&has_garden=\(has_garden)&has_parking=\(has_parking)&has_furnished=\(has_furnished)&build_date=\(build_date)"
        
        RegistrationServices.registerationPostMethodGeneric(postString: postString, url: url, completion: completion)
        
        //        createGeneralSecondMethod(postString: postString, url: url, completion:completion)
        
    }
    
    
    func getPostUsingPOstIDs(id:Int, completion: @escaping (BaseFavoriteModel?, Error?) -> ()) {
        let urlString = "http://aqarzelo.com/public/api/post/get?post_id=1580642000".toSecrueHttps()
        RegistrationServices.registerationGetMethodGenerics(urlString: urlString, completion: completion)
        //        fetchGenericJSONData(urlString: urlString, completion: completion)
    }
}




extension Notification.Name {
    static let uoloadProgress = Notification.Name("uoloadProgress")
    static let uploadComplete = Notification.Name("uploadComplete")
    
    static let uoloadNextProgress = Notification.Name("uoloadNextProgress")
    static let uploadNextComplete = Notification.Name("uploadNextComplete")
}
