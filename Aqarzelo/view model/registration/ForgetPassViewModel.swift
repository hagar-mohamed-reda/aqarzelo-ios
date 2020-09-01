//
//  ForgetPassViewModel.swift
//  Aqarzelo
//
//  Created by Hossam on 8/15/20.
//  Copyright © 2020 Hossam. All rights reserved.
//

import UIKit

class ForgetPassViewModel {
    
    var bindableIsLogging = Bindable<Bool>()
    var bindableIsFormValidate = Bindable<Bool>()
    
    //variables
    var email:String? {didSet {checkFormValidity()}}
    var isUser = false {didSet {checkFormValidity()}}

    func performForget(completion:@escaping (BaseUserSecondModel?,Error?)->Void)  {
        guard let email = email
            else { return  }
        bindableIsLogging.value = true
        
        RegistrationServices.shared.forgetPassword(phone: email, completion: completion)    }
    
    func checkFormValidity() {
        let isFormValid = email?.isEmpty == false
        
        bindableIsFormValidate.value = isFormValid
        
    }
}
