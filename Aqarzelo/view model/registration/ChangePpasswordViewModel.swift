//
//  ChangePpasswordViewModel.swift
//  Aqarzelo
//
//  Created by Hossam on 8/15/20.
//  Copyright © 2020 Hossam. All rights reserved.
//

import UIKit

class ChangePpasswordViewModel {
    
    
    var bindableIsLogging = Bindable<Bool>()
    var bindableIsFormValidate = Bindable<Bool>()
    
    //variables
    var oldPass:String? {didSet {checkFormValidity()}}
    var newPassword:String? {didSet {checkFormValidity()}}
    var confirmNewPassword:String? {didSet {checkFormValidity()}}
    var apiToken:String? {didSet {checkFormValidity()}}

    func performLogging(completion:@escaping (BaseUserSecondModel?,Error?)->Void)  {
        guard let old = oldPass,let newPass = newPassword,let apiToken = apiToken
            else { return  }
        bindableIsLogging.value = true
        
        RegistrationServices.shared.changeUserPassword(api_token: apiToken, oldPass: old, newPassword: newPass, completion: completion)
    }
    
    func checkFormValidity() {
        let isFormValid = oldPass?.isEmpty == false && newPassword?.isEmpty == false && confirmNewPassword?.isEmpty == false && confirmNewPassword == newPassword
        
        bindableIsFormValidate.value = isFormValid
        
    }
}
