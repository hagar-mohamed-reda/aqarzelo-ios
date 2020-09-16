//
//  FirstCcreatePostVviewModel.swift
//  Aqarzelo
//
//  Created by Hossam on 8/15/20.
//  Copyright © 2020 Hossam. All rights reserved.
//


import UIKit

class FirstCcreatePostVviewModel {
    
     var bindableIsFirst = Bindable<Bool>()
     var bindableIsFormValidate = Bindable<Bool>()
    
    //variables
    var title:String? {didSet {checkFormValidity()}}
    var titleAR:String? {didSet {checkFormValidity()}}
    var category:String? {didSet {checkFormValidity()}}
    var sell:String? {didSet {checkFormValidity()}}
    var space:String? {didSet {checkFormValidity()}}
    var roomNum:String? {didSet {checkFormValidity()}}
    var bathsNum:String? {didSet {checkFormValidity()}}
    var pricePer:String? {didSet {checkFormValidity()}}
    var totalPrice:String? {didSet {checkFormValidity()}}
    
    
    
    func checkFormValidity() {
        let isFormValid = title?.isEmpty == false && titleAR?.isEmpty == false && sell?.isEmpty == false && category?.isEmpty == false && space?.isEmpty == false && roomNum?.isEmpty == false && bathsNum?.isEmpty == false && pricePer?.isEmpty == false && totalPrice?.isEmpty == false
        
        bindableIsFormValidate.value = isFormValid
        
    }
}
