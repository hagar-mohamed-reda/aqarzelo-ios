//
//  NotificationSettingCell.swift
//  Aqarzelo
//
//  Created by Hossam on 8/8/20.
//  Copyright © 2020 Hossam. All rights reserved.
//


import UIKit
import MOLH

class NotificationSettingCell: BaseTableViewCell {

    lazy var logoImageView:UIImageView = {
        let i = UIImageView(image: #imageLiteral(resourceName: "Group 3926-1"))
        i.constrainWidth(constant: 42)
        i.constrainHeight(constant: 42)
//        i.layer.cornerRadius = 10
        i.clipsToBounds = true
        return i
    }()
    
    lazy var stateNotificationSwitcher:UISwitch = {
       let s = UISwitch()
        s.isOn = true
        s.addTarget(self, action: #selector(handleOnOff), for: .valueChanged)
        return s
    }()
    
    
    lazy var notificationLabel = UILabel(text: "Notifications".localized, font: .systemFont(ofSize: 16), textColor: .black)
    
    var handleMuteNotification:((Bool)->Void)?
    
    
    override func setupViews() {
        accessoryType = .none
        notificationLabel.textAlignment = MOLHLanguage.isRTLLanguage() ?  .right : .left
        
         hstack(logoImageView,notificationLabel,stateNotificationSwitcher,spacing: 16,alignment:.center).withMargins(.init(top: 8, left: 32, bottom: 8, right: 8))
        
    }
    
    @objc func handleOnOff(sender:UISwitch)  {
        handleMuteNotification?(sender.isOn)
    }
    
  
}
