//
//  ChooseLocationPostVC.swift
//  Aqarzelo
//
//  Created by Hossam on 8/9/20.
//  Copyright © 2020 Hossam. All rights reserved.
//

import UIKit

class ChooseLocationPostVC: UIViewController {
    
    lazy var mainImage:UIImageView = {
        let i = UIImageView(image: #imageLiteral(resourceName: "Rectangle 7"))
        i.isUserInteractionEnabled = true
        return i
    }()
    
    lazy var doneButton:UIButton = {
        let b = UIButton(title: "Done".localized, titleColor: .black, font: .systemFont(ofSize: 16), backgroundColor: #colorLiteral(red: 0.1890996099, green: 0.7945721745, blue: 0.6656317115, alpha: 1), target: self, action: #selector(handleDone))
        b.constrainHeight(constant: 50)
        b.layer.cornerRadius = 16
        b.layer.borderWidth = 1
        b.clipsToBounds = true
        return b
    }()
    lazy var customSecondSearchView:CustomSecondSearchView = {
        let v = CustomSecondSearchView()
        v.constrainHeight(constant: 50)
        return v
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        statusBarBackgroundColor()
    }
    
    //MARK:-User methods
    
    fileprivate func setupViews()  {
        view.backgroundColor = .white
        view.addSubViews(views: mainImage)
        
        mainImage.fillSuperview(padding: .init(top: -8, left: -16, bottom:-16, right: -16))
        mainImage.addSubViews(views: doneButton,customSecondSearchView)
        
        doneButton.anchor(top: nil, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor,padding: .init(top: 0, left: 16, bottom: 16, right: 16))
        customSecondSearchView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor,padding: .init(top: 32, left: 16, bottom: 0, right: 16))
    }
    
    //TODO:-Handle methods
    
    @objc fileprivate  func handleDone()  {
        print(655)
    }
}
