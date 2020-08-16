//
//  MainEnum.swift
//  Aqarzeoo
//
//  Created by hosam on 2/24/20.
//  Copyright © 2020 hosam. All rights reserved.
//

import UIKit

enum FinishedTypeEnum:String {
    case lux = "lux"
    case super_lux = "super_lux"
    case extra_super_lux = "extra_super_lux"
    
    case semi_finished = "semi_finished"
    case without_finished = "without_finished"
}

enum PaymentTypeEnum:String {
    case cash = "cash"
    case installment = "installment"
}

enum PostStatusEnum:String {
    case accepted = "accepted"
    case pending = "pending"
    case refused = "refused"
    case user_trash = "user_trash"
}

enum PostTypeEnum:String {
    case sale = "sale"
    case rent = "rent"
}

enum OwnerTypeEnum:String {
    case owner = "owner"
    case mediator = "mediator"
    case developer = "developer"
}
