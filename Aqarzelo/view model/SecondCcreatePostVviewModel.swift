//
//  SecondCcreatePostVviewModel.swift
//  Aqarzelo
//
//  Created by Hossam on 8/15/20.
//  Copyright © 2020 Hossam. All rights reserved.
//

import UIKit

class SecondCcreatePostVviewModel {
    
    var bindableIsSecond = Bindable<Bool>()
    var bindableIsFormValidate = Bindable<Bool>()
    
    //variables
    var lat:String? {didSet {checkFormValidity()}}
    var lng:String? {didSet {checkFormValidity()}}
    var city:String? {didSet {checkFormValidity()}}
    var area:String? {didSet {checkFormValidity()}}
    var address:String? {didSet {checkFormValidity()}}
    var buildDate:String? {didSet {checkFormValidity()}}
    var fllorNum:String? {didSet {checkFormValidity()}}
    
    
    
    func checkFormValidity() {
        let isFormValid = lat?.isEmpty == false && lng?.isEmpty == false && city?.isEmpty == false && area?.isEmpty == false  && buildDate?.isEmpty == false && fllorNum?.isEmpty == false
        
        bindableIsFormValidate.value = isFormValid
        
    }
}
