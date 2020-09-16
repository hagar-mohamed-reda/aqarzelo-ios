//
//  MainCreatePostViewModel.swift
//  Aqarzelo
//
//  Created by Hossam on 8/15/20.
//  Copyright © 2020 Hossam. All rights reserved.
//
import UIKit

class MainCreatePostViewModel {
    
    var bindableIsMain = Bindable<Bool>()
    var bindableIsFormValidate = Bindable<Bool>()
    
    //variables
    var describe:String? {didSet {checkFormValidity()}}
    var ownerType:String? {didSet {checkFormValidity()}}
    var payment:String? {didSet {checkFormValidity()}}
    var finshed:String? {didSet {checkFormValidity()}}
    var more:String? {didSet {checkFormValidity()}}
    
    //variables
    var lat:String? {didSet {checkFormValidity()}}
    var lng:String? {didSet {checkFormValidity()}}
    var city:String? {didSet {checkFormValidity()}}
    var area:String? {didSet {checkFormValidity()}}
    var buildDate:String? {didSet {checkFormValidity()}}
    var fllorNum:String? {didSet {checkFormValidity()}}
    
    //variables
    var title:String? {didSet {checkFormValidity()}}
    var titleAr:String? {didSet {checkFormValidity()}}
    var category:String? {didSet {checkFormValidity()}}
    var sell:String? {didSet {checkFormValidity()}}
    var space:String? {didSet {checkFormValidity()}}
    var roomNum:String? {didSet {checkFormValidity()}}
    var bathsNum:String? {didSet {checkFormValidity()}}
    var pricePer:String? {didSet {checkFormValidity()}}
    var totalPrice:String? {didSet {checkFormValidity()}}
    
    
    func checkFormValidity() {
        
        let isFormValid = describe?.isEmpty == false && ownerType?.isEmpty == false && payment?.isEmpty == false && finshed?.isEmpty == false &&  more?.isEmpty == false
        &&  lat?.isEmpty == false && lng?.isEmpty == false && city?.isEmpty == false && area?.isEmpty == false && buildDate?.isEmpty == false && fllorNum?.isEmpty == false
        &&  title?.isEmpty == false && titleAr?.isEmpty == false  && sell?.isEmpty == false && category?.isEmpty == false && space?.isEmpty == false && roomNum?.isEmpty == false && bathsNum?.isEmpty == false && pricePer?.isEmpty == false && totalPrice?.isEmpty == false
        
        bindableIsFormValidate.value = isFormValid
    }
    
}
