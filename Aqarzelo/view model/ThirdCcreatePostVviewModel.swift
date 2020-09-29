//
//  ThirdCcreatePostVviewModel.swift
//  Aqarzelo
//
//  Created by Hossam on 8/15/20.
//  Copyright © 2020 Hossam. All rights reserved.
//

import UIKit

class ThirdCcreatePostVviewModel {
    
    var bindableIsThird = Bindable<Bool>()
    var bindableIsFormValidate = Bindable<Bool>()
    
    //variables
    var describe:String? {didSet {checkFormValidity()}}
    var ownerType:String? {didSet {checkFormValidity()}}
    var payment:String? {didSet {checkFormValidity()}}
    var finshed:String? {didSet {checkFormValidity()}}
     var more:String? {didSet {checkFormValidity()}}
//    var moreGarden:String? {didSet {checkFormValidity()}}
//    var moreParking:String? {didSet {checkFormValidity()}}
//    var moreFurnish:String? {didSet {checkFormValidity()}}
//
    
    
    func checkFormValidity() {
//        let isFormValid = describe?.isEmpty == false && ownerType?.isEmpty == false && payment?.isEmpty == false && finshed?.isEmpty == false &&  more?.isEmpty == false
        let isFormValid = describe?.isEmpty == false && ownerType?.isEmpty == false && payment?.isEmpty == false  &&  more?.isEmpty == false
        bindableIsFormValidate.value = isFormValid
        
    }
}
