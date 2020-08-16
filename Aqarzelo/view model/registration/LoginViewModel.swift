//
//  LoginViewModel.swift
//  Aqarzelo
//
//  Created by Hossam on 8/15/20.
//  Copyright © 2020 Hossam. All rights reserved.
//

import UIKit

class LoginViewModel {
    
    var bindableIsLogging = Bindable<Bool>()
    var bindableIsFormValidate = Bindable<Bool>()
    
    //variables
    var email:String? {didSet {checkFormValidity()}}
    var password:String? {didSet {checkFormValidity()}}
    
    func performLogging(completion:@escaping (BaseUserSecondModel?,Error?)->Void)  {
        guard let email = email,let password = password
           else { return  }
        bindableIsLogging.value = true
        
        RegistrationServices.shared.loginUser(phone: email, password: password, completion: completion)
    }
    
    func checkFormValidity() {
        let isFormValid = email?.isEmpty == false && password?.isEmpty == false
        
        bindableIsFormValidate.value = isFormValid
        
    }
}
