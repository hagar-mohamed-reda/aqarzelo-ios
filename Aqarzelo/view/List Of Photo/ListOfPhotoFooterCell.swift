//
//  ListOfPhotoFooterCell.swift
//  Aqarzelo
//
//  Created by Hossam on 8/8/20.
//  Copyright © 2020 Hossam. All rights reserved.
//


import UIKit
import SwiftUI

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
    lazy var uploadPhotoLabel = UILabel(text: "Upload normal photo".localized, font: .systemFont(ofSize: 16), textColor: .black)
    lazy var upload360PhotoLabel = UILabel(text: "Upload 360 photo".localized, font: .systemFont(ofSize: 16), textColor: .black)
    
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
        hstack(secondMainImageView,mainImageView,spacing:16,distribution: .fillEqually)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


struct SSS:UIViewRepresentable {
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
    
    
    func makeUIView(context: Context) -> some UIView {
        return ListOfPhotoFooterCell()
    }
}

struct ContentViewS : View {
    
    var body: some View {
        SSS()
    }
}

struct SwiftUIView_PreviewsS: PreviewProvider {
    static var previews: some View {
        ContentViewS()
            .previewLayout(.fixed(width: 400, height: 100))
    }
}
