//
//  AqarDetailInfoView.swift
//  Aqarzelo
//
//  Created by Hossam on 8/9/20.
//  Copyright © 2020 Hossam. All rights reserved.
//


import UIKit
import MOLH

class AqarDetailInfoView:UIView {
    
    var aqar:AqarModel? {
        didSet{
            guard let aqar = aqar else { return  }

            if MOLHLanguage.isRTLLanguage() {
                if let bb = userDefaults.value(forKey: UserDefaultsConstants.cityNameArray) as? [String]  {
                    LabelsView[8].text = bb[aqar.cityID]
                }
            }else {
                if let bb = userDefaults.value(forKey: UserDefaultsConstants.cityNameArabicArray) as? [String]  {
                    LabelsView[8].text = bb[aqar.cityID]
                }
            }
            
            
            LabelsView[0].text = "\(String(describing: aqar.bedroomNumber)) "+"Rooms".localized
            LabelsView[1].text = "\(String(describing: aqar.bathroomNumber )) "+"Baths".localized
            
            LabelsView[2].text = "\(aqar.finishingType)".localized
            LabelsView[3].text = "\(aqar.furnished)".localized
            LabelsView[4].text = "\(aqar.ownerType)".localized
            LabelsView[5].text = "\(aqar.hasParking) "+"parking".localized
            LabelsView[6].text = "\(aqar.type) ".localized
            LabelsView[7].text = "\(aqar.paymentMethod)".localized
            //            LabelsView[8].text = "\(aqar.cityID) Giza"
            LabelsView[9].text = "\(aqar.hasParking) ".localized
            LabelsView[10].text = "\(aqar.type)".localized
            LabelsView[11].text = "\(aqar.paymentMethod)".localized
            LabelsView[12].text = "\(aqar.hasGarden) ".localized
        }
    }
    
    let imagesIcons:[UIImage] = [#imageLiteral(resourceName: "bed"),#imageLiteral(resourceName: "bathtub"),#imageLiteral(resourceName: "paint-roller"),#imageLiteral(resourceName: "carpet"),#imageLiteral(resourceName: "standing-up-man-"),#imageLiteral(resourceName: "parked-car"),#imageLiteral(resourceName: "shopping-cart (1)"),#imageLiteral(resourceName: "credit-cards-payment"),#imageLiteral(resourceName: "bed"),#imageLiteral(resourceName: "bathtub"),#imageLiteral(resourceName: "paint-roller"),#imageLiteral(resourceName: "carpet"),#imageLiteral(resourceName: "Group 3951").withRenderingMode(.alwaysTemplate)] //#imageLiteral(resourceName: "Group 3951")
    
    
    lazy var logosImagesView:[UIImageView] = {
        var arrangedViews = [UIImageView ]()
        (0...imagesIcons.count-1).forEach({ (i) in
            let im = UIImageView(image: imagesIcons[i])
            im.constrainWidth(constant: 20)
            //            im.constrainHeight(constant: 20)
            arrangedViews.append(im)
        })
        return arrangedViews
    }()
    
    lazy var LabelsView:[UILabel] = {
        var arrangedViews = [UILabel ]()
        (0...12).forEach({ (i) in
            let im = UILabel(text: "labelsNames[i]", font: .systemFont(ofSize: 16), textColor: .black)
            //            im.constrainHeight(constant: 20)
            arrangedViews.append(im)
        })
        return arrangedViews
    }()
    lazy var seperatorView:UIView = {
        let v = UIView(backgroundColor: #colorLiteral(red: 0.9489304423, green: 0.9490666986, blue: 0.94890064, alpha: 1))
        v.constrainHeight(constant: 1)
        return v
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews()  {
        backgroundColor = .white
        addSubview(seperatorView)
        LabelsView.forEach({$0.textAlignment = MOLHLanguage.isRTLLanguage() ? .right : .left})
        if MOLHLanguage.isRTLLanguage() {
            let firstStack = hstack(hstack(logosImagesView[0],LabelsView[0],spacing:8),hstack(logosImagesView[1],LabelsView[1],spacing:8),hstack(logosImagesView[2],LabelsView[2],spacing:8),spacing:0,distribution:.fillEqually)
            
            let secondStack = hstack(hstack(logosImagesView[3],LabelsView[3],spacing:8),hstack(logosImagesView[4],LabelsView[4],spacing:8),hstack(logosImagesView[5],LabelsView[5],spacing:8),spacing:0,distribution:.fillEqually)
            
            let thirdStack = hstack(hstack(logosImagesView[6],LabelsView[6],spacing:8),hstack(logosImagesView[7],LabelsView[7],spacing:8),hstack(logosImagesView[8],LabelsView[8],spacing:8),spacing:0,distribution:.fillEqually)
            
            let forthStack = hstack(hstack(logosImagesView[9],LabelsView[9],spacing:8),hstack(logosImagesView[10],LabelsView[10],spacing:8),hstack(logosImagesView[11],LabelsView[11],spacing:8),spacing: 0, distribution: .fillEqually)
            let fifthStack = hstack(hstack(logosImagesView[12],LabelsView[12],spacing:8),UIView(),spacing:0,distribution:.fillEqually)
            let ss =   stack(firstStack,secondStack,thirdStack,forthStack,fifthStack,spacing: 8 ,distribution:.fillEqually )
             stack(ss,UIView()).withMargins(.init(top: 0, left: 0, bottom: 8, right: 0))
        }else {
            
            let firstStack = hstack(hstack(logosImagesView[0],LabelsView[0],spacing:8),hstack(logosImagesView[1],LabelsView[1],spacing:8),hstack(logosImagesView[2],LabelsView[2],spacing:8),spacing:0,distribution:.fillEqually)
            
            let secondStack = hstack(hstack(logosImagesView[3],LabelsView[3],spacing:8),hstack(logosImagesView[4],LabelsView[4],spacing:8),hstack(logosImagesView[5],LabelsView[5],spacing:8),spacing:0,distribution:.fillEqually)
            
            let thirdStack = hstack(hstack(logosImagesView[6],LabelsView[6],spacing:8),hstack(logosImagesView[7],LabelsView[7],spacing:8),hstack(logosImagesView[8],LabelsView[8],spacing:8),spacing:0,distribution:.fillEqually)
            
            let forthStack = hstack(hstack(logosImagesView[9],LabelsView[9],spacing:8),hstack(logosImagesView[10],LabelsView[10],spacing:8),hstack(logosImagesView[11],LabelsView[11],spacing:8),spacing: 0, distribution: .fillEqually)
            let fifthStack = hstack(hstack(logosImagesView[12],LabelsView[12],spacing:8),UIView(),spacing:0,distribution:.fillEqually)
            
        
            let ss =   stack(firstStack,secondStack,thirdStack,forthStack,fifthStack,spacing: 8 ,distribution:.fillEqually )
         stack(ss,UIView()).withMargins(.init(top: 0, left: 0, bottom: 8, right: 0))
        }
       
        seperatorView.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor)
    }
}

//
