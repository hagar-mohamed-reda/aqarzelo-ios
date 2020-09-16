//
//  RegisterViewModel.swift
//  Aqarzelo
//
//  Created by Hossam on 8/15/20.
//  Copyright © 2020 Hossam. All rights reserved.
//

import UIKit

class RegisterViewModel {
    
    
    var bindableIsResgiter = Bindable<Bool>()
    var bindableIsFormValidate = Bindable<Bool>()
    
    //variables
    var email:String? {didSet {checkFormValidity()}}
    var password:String? {didSet {checkFormValidity()}}
    var confirmPassword:String? {didSet {checkFormValidity()}}
    var phone:String? {didSet {checkFormValidity()}}
    var usernasme:String? {didSet {checkFormValidity()}}

    func performRegister(completion:@escaping (BaseRegisterModel?,Error?)->Void)  {
        guard let email = email,let password = password,let username = usernasme,let phone = phone
            else { return  }
        bindableIsResgiter.value = true
        RegistrationServices.shared.registerUser(name: username, email: email, phone: phone, password: password, completion: completion)
        
    }
    
    func checkFormValidity() {
        let isFormValid = email?.isEmpty == false && password?.isEmpty == false && confirmPassword?.isEmpty == false && confirmPassword == password &&  phone?.isEmpty == false && usernasme?.isEmpty == false 
        
        bindableIsFormValidate.value = isFormValid
        
    }
}
