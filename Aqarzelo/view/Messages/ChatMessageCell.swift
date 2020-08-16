//
//  ChatMessageCell.swift
//  Alamofire
//
//  Created by Hossam on 8/8/20.
//


import UIKit
import SDWebImage

class ChatMessageCell: BaseCollectionCell {
    
    
    
    //    var message:MessageModel? {
    //        didSet{
    //
    //            guard let message = message else { return  }
    ////            let isCurrentUser = <#value#>
    //
    //            if message.userTo == "\(self.toId)"{
    //
    //                constainedDateAnchor.leading?.isActive = true
    //                constainedDateAnchor.trailing?.isActive = false
    //
    //                userImageView.isHide(true)
    //                constainedAnchor.leading?.isActive = true
    //                constainedAnchor.trailing?.isActive = false
    //                bubleView.backgroundColor = #colorLiteral(red: 0.9176470588, green: 0.9137254902, blue: 0.9333333333, alpha: 1)
    //                bubleView.layer.borderColor = UIColor.clear.cgColor
    //
    ////                textView.textColor = .black
    //            }else {
    //                constainedDateAnchor.leading?.isActive = false
    //                constainedDateAnchor.trailing?.isActive = true
    //
    //
    //
    //
    //                constainedAnchor.leading?.isActive = false
    //                constainedAnchor.trailing?.isActive = true
    //
    //                bubleView.backgroundColor = .white
    //                bubleView.layer.borderColor = UIColor.lightGray.cgColor
    //
    //                userImageView.isHide(false)
    //                guard let url = URL(string: message.to.photoURL ) else {return}
    //                self.userImageView.sd_setImage(with: url)
    ////                textView.textColor = .black
    //            }
    //
    //            let width = message.message.getFrameForText(text: message.message ).width + 40
    //
    //            if width < 90 {
    //                bubleViewWidthConstraint.constant = 90
    //            }else {
    //                bubleViewWidthConstraint.constant = width
    //            }
    //
    //            messageLabel.text = message.message
    //
    //            dateLabel.textColor = .black
    //
    //
    //
    ////            let date = Date(timeIntervalSince1970: message.timestamp)
    ////            let dateString = message.text.timeAgoSinceDate(date, currentDate: Date(), numericDates: true)
    ////            dateLabel.text = dateString
    //            self.dateLabel.text = message.createdAt//date.formatHeaderTimeLabel(time: date)
    //
    //
    //        }
    //    }
    //    let bubbleContainer:UIView = {
    //        let vi = UIView(backgroundColor: .gray)
    //        vi.layer.cornerRadius = 12
    //        vi.translatesAutoresizingMaskIntoConstraints = false
    //        return vi
    //    }()
    var constainedAnchor:AnchoredConstraints!
    var constainedDateAnchor:AnchoredConstraints!
    
    //    var bubleViewleadingAnchor:NSLayoutConstraint!
    //    var bubleViewtrailingAnchor:NSLayoutConstraint!
    var bubleViewWidthConstraint:NSLayoutConstraint!
    
    var dateLabelLeadingConstraint:NSLayoutConstraint!
    var dateLabelTrailingAnchor:NSLayoutConstraint!
    //
    lazy var userImageView:UIImageView = {
        let im = UIImageView()
        im.backgroundColor = .blue
        im.constrainWidth(constant: 28)
        im.constrainHeight(constant: 28)
        im.layer.cornerRadius = 8
        im.contentMode = .scaleAspectFill
        im.clipsToBounds = true
        im.isHidden = true
        return im
    }()
    //
    lazy var bubleView:UIView = {
        let vi = UIView(backgroundColor: .gray)
        vi.layer.cornerRadius = 16
        vi.translatesAutoresizingMaskIntoConstraints = false
        vi.layer.borderWidth = 0.4
        return vi
    }()
    
    
    lazy var dateLabel:UILabel = {
        let l = UILabel(text: "4 hours ago", font: .systemFont(ofSize: 10), textColor: #colorLiteral(red: 0.7921568627, green: 0.7921568627, blue: 0.7921568627, alpha: 1))
        l.constrainHeight(constant: 20)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    lazy var messageLabel = UILabel(text: "this is text \n fdgdf ", font: .systemFont(ofSize: 16), textColor: .black, textAlignment: .left, numberOfLines: 0)
    
    
    override func setupViews() {
        backgroundColor = .white
        addSubViews(views: bubleView,userImageView,dateLabel)
        
        userImageView.anchor(top: bubleView.topAnchor, leading: bubleView.leadingAnchor, bottom: nil, trailing: nil,padding: .init(top: -12, left: -16, bottom: 8, right: 0))
        
        
        constainedAnchor = bubleView.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor,padding: .init(top: 8, left: 0, bottom: 20, right: 0))
        constainedAnchor.leading?.constant = 20
        constainedAnchor.trailing?.constant = -20
        bubleViewWidthConstraint =  bubleView.widthAnchor.constraint(lessThanOrEqualToConstant: 250)
        
        constainedAnchor.leading?.isActive = false
        constainedAnchor.trailing?.isActive = true
        bubleViewWidthConstraint.isActive = true
        
        
        bubleView.addSubViews(views: messageLabel)
        messageLabel.fillSuperview(padding: .init(top: 8, left: 12, bottom: 8, right: 12))
        constainedDateAnchor =  dateLabel.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor)
        constainedDateAnchor.trailing?.constant = -20
        constainedDateAnchor.leading?.constant = 20
        
        constainedDateAnchor.leading?.isActive = false
        constainedDateAnchor.trailing?.isActive = true
        
    }
    
    func configureData(index:Int,message:MessageModel)  {
        if message.userFrom == index {
            
            constainedDateAnchor.leading?.isActive = true
            constainedDateAnchor.trailing?.isActive = false
            
            userImageView.isHide(false)
            guard let url = URL(string: message.from.photoURL ) else {return}
            self.userImageView.sd_setImage(with: url)
            constainedAnchor.leading?.isActive = true
            constainedAnchor.trailing?.isActive = false
            bubleView.backgroundColor = #colorLiteral(red: 0.9176470588, green: 0.9137254902, blue: 0.9333333333, alpha: 1)
            bubleView.layer.borderColor = UIColor.clear.cgColor
            messageLabel.textColor = .black
            
        }else {
            constainedDateAnchor.leading?.isActive = false
            constainedDateAnchor.trailing?.isActive = true
            
            
            
            
            constainedAnchor.leading?.isActive = false
            constainedAnchor.trailing?.isActive = true
            
            bubleView.backgroundColor = #colorLiteral(red: 0.4343734086, green: 0.8606870174, blue: 0.7011793256, alpha: 1)
            bubleView.layer.borderColor = UIColor.lightGray.cgColor
            messageLabel.textColor = .white
            
            userImageView.isHide(true)
            
        }
        
        let width = message.message.getFrameForText(text: message.message ).width + 40
        
        if width < 90 {
            bubleViewWidthConstraint.constant = 90
        }else {
            bubleViewWidthConstraint.constant = width
        }
        
        messageLabel.text = message.message
        
        dateLabel.textColor = .black
        
        guard let dd = message.createdAt.toDates() else {return}// replace Date String
       
        let dateString = message.createdAt.timeAgoSinceDate( dd, currentDate: Date(), numericDates: true)
        dateLabel.text = dateString
        
    }
    
    
}

