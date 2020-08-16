//
//  NotificationCollectionCell.swift
//  Aqarzelo
//
//  Created by Hossam on 8/8/20.
//  Copyright © 2020 Hossam. All rights reserved.
//


import UIKit
import SDWebImage
import MOLH

class NotificationCollectionCell: BaseCollectionCell {
    
    var notify:NotificationModel! {
        didSet{
            guard let notify=notify else{return}

            notificationDateLabel.text = notify.createdAt
            notificationTitleLabel.text = MOLHLanguage.isRTLLanguage() ? notify.titleAr :  notify.title
            notificationDiscriptioneLabel.text = notify.post?.userReview.first?.comment ?? ""
            
            guard let dd = notify.createdAt?.toDates() else {return}// replace Date String
            let date =  dd
            let dateString = notify.createdAt?.timeAgoSinceDate(date, currentDate: Date(), numericDates: true)
            notificationDateLabel.text = dateString
            guard let urlString = notify.post?.images.first?.image,let url = URL(string: urlString) else { return  }
            
            notificationImageView.sd_setImage(with: url)
            
        }
    }
    
    
    lazy var notificationImageView:UIImageView = {
        let i = UIImageView(backgroundColor: .gray)
        i.constrainWidth(constant: 122)
        i.clipsToBounds = true
        return i
    }()
    
    lazy var notificationDateLabel = UILabel(text: "", font: .systemFont(ofSize: 16), textColor: .lightGray)
    lazy var notificationTitleLabel = UILabel(text: "new message from Hosam", font: .systemFont(ofSize: 16), textColor: .black)
    lazy var notificationDiscriptioneLabel = UILabel(text: "", font: .systemFont(ofSize: 16), textColor: .gray,textAlignment: .left,numberOfLines: 3)
    
    override init(frame: CGRect) {
           super.init(frame: frame)
           
           layer.cornerRadius = 16
           layer.borderWidth = 1
           layer.borderColor = UIColor.gray.cgColor
           clipsToBounds = true
           setupShadow(opacity: 0.2, radius: 10, offset: .init(width: 0, height: 10), color: .gray)
       }
       
       required init?(coder aDecoder: NSCoder) {
           fatalError("init(coder:) has not been implemented")
       }
    
    override func setupViews() {
        let subLabels = stack(notificationDateLabel,notificationTitleLabel,notificationDiscriptioneLabel)
        [notificationDateLabel,notificationTitleLabel,notificationDiscriptioneLabel].forEach({$0.textAlignment = MOLHLanguage.isRTLLanguage() ? .right : .left})
        if MOLHLanguage.isRTLLanguage() {
            hstack(subLabels,notificationImageView,spacing: 8).withMargins(.init(top: 8, left: 8, bottom: 8, right: 8))
        }else {
            hstack(notificationImageView,subLabels,spacing: 8).withMargins(.init(top: 8, left: 8, bottom: 8, right: 8))
        }
        
    }
}
