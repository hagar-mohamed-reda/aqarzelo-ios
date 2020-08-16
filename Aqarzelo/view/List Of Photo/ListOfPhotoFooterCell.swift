//
//  ListOfPhotoFooterCell.swift
//  Aqarzelo
//
//  Created by Hossam on 8/8/20.
//  Copyright © 2020 Hossam. All rights reserved.
//


import UIKit

class ListOfPhotoFooterCell: UICollectionReusableView {
    
    lazy var mainImageView:UIImageView = {
        let i = UIImageView(image: #imageLiteral(resourceName: "Path 4546"))
        i.isUserInteractionEnabled = true
        return i
    }()
    lazy var secondMainImageView:UIImageView = {
        let i = UIImageView(image: #imageLiteral(resourceName: "Path 4546"))
        i.isUserInteractionEnabled = true
        i.clipsToBounds = true
        return i
    }()
    
    lazy var logoImageView:UIImageView = {
        let i = UIImageView(image: #imageLiteral(resourceName: "upload-cloud"))
        i.clipsToBounds = true
        
        return i
    }()
    lazy var secondLogoImageView:UIImageView = {
        let i = UIImageView(image: #imageLiteral(resourceName: "upload-cloud"))
        i.clipsToBounds = true
        
        return i
    }()
    lazy var uploadPhotoLabel = UILabel(text: "Upload Normal photo", font: .systemFont(ofSize: 16), textColor: .black)
    lazy var upload360PhotoLabel = UILabel(text: "Upload 360 photo", font: .systemFont(ofSize: 16), textColor: .black)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
   
    
    func setupViews()  {
        backgroundColor = .white
        let contents = getStack(views: logoImageView,uploadPhotoLabel, spacing: 0, distribution: .fill, axis: .vertical)
        let secondContents = getStack(views: secondLogoImageView,upload360PhotoLabel, spacing: 0, distribution: .fill, axis: .vertical)
        
        addSubViews(views: mainImageView,secondMainImageView)
        mainImageView.addSubViews(views: contents)
        secondMainImageView.addSubViews(views: secondContents)
        
        contents.centerInSuperview()
        secondContents.centerInSuperview()
        hstack(mainImageView,secondMainImageView,spacing:16,distribution: .fillEqually)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
