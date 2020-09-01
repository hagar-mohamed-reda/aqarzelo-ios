
//
//  File.swift
//  Aqarzelo
//
//  Created by Hossam on 8/15/20.
//  Copyright © 2020 Hossam. All rights reserved.
//

import UIKit

class ForgetPassConfirmViewModel {
    
    var bindableIsConfirm = Bindable<Bool>()
    var bindableIsFormValidate = Bindable<Bool>()
    
    //variables
    var smsCode:String? {didSet {checkFormValidity()}}
    var password:String? {didSet {checkFormValidity()}}
    var confirmPassword:String? {didSet {checkFormValidity()}}
    var phone:String? {didSet {checkFormValidity()}}
    var apiToken:String? {didSet {checkFormValidity()}}
    var isUser = false {didSet {checkFormValidity()}}

    func performConfirmation(completion:@escaping (BaseUserSecondModel?,Error?)->Void)  {
        guard let smsCode = smsCode,let password = password,let phone = phone,let apiToken = apiToken else {return}
        bindableIsConfirm.value = true
        
        RegistrationServices.shared.receiveSmsCode(phone: phone, code: smsCode, api_Token: apiToken, password: password, completion: completion)
    }
    
    func checkFormValidity() {
        let isFormValid = smsCode?.isEmpty == false && password?.isEmpty == false && confirmPassword?.isEmpty == false && confirmPassword == password &&  apiToken?.isEmpty == false && phone?.isEmpty == false
        
        bindableIsFormValidate.value = isFormValid
        
    }
    
}
