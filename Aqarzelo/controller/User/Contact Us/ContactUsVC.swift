//
//  ContactUsVC.swift
//  Aqarzelo
//
//  Created by Hossam on 8/9/20.
//  Copyright © 2020 Hossam. All rights reserved.
//

import UIKit
import SafariServices
import MOLH

class ContactUsVC: UIViewController {
    
    
    var links = [String]()
    
    lazy var horizentalCollectionContactUsVC:HorizentalCollectionContactUsVC = {
        let v = HorizentalCollectionContactUsVC()
        
        return v
    }()
    
    lazy var mainView:UIView = {
        let i = UIView(backgroundColor: .white)
        i.layer.cornerRadius = 24
        i.clipsToBounds = true
        return i
    }()
    
    lazy var logoImage:UIImageView = {
        let i = UIImageView(image: #imageLiteral(resourceName: "2427280"))
        i.translatesAutoresizingMaskIntoConstraints = false
        //        i.constrainHeight(constant: 800)
        i.constrainHeight(constant: 250)
        
        i.clipsToBounds = true
        return i
    }()
    var images = [#imageLiteral(resourceName: "twitter (3)"),#imageLiteral(resourceName: "google-plus"),#imageLiteral(resourceName: "facebook (6)"),#imageLiteral(resourceName: "snapchat (1)")]
    
    var tages = [0,1,2,3]
    
    lazy var youtubImage = createImagesButton(image: #imageLiteral(resourceName: "google-plus"), tag: 0)
    lazy var facebookImage = createImagesButton(image: #imageLiteral(resourceName: "facebook (6)"), tag: 1)
    lazy var twitterImage = createImagesButton(image: #imageLiteral(resourceName: "twitter (3)"), tag: 2)
    
    lazy var followLabel = UILabel(text: "Follow us".localized, font: .systemFont(ofSize: 16), textColor: .black,textAlignment: .center)
    
    lazy var contactLabel = UILabel(text: "Contact us".localized, font: .systemFont(ofSize: 16), textColor: .black,textAlignment: .center)
    lazy var emailLabel = UILabel(text: "admin@aqarzelo.com" , font: .systemFont(ofSize: 16), textColor: .black)
    lazy var emailImageView: UIImageView = {
        let i = UIImageView(image: #imageLiteral(resourceName: "Group 392s"))
        i.translatesAutoresizingMaskIntoConstraints = false
        i.constrainHeight(constant: 40)
        i.constrainWidth(constant: 40)
        i.clipsToBounds = true
        return i
    }()
    lazy var telephoneImageView: UIImageView = {
        let i = UIImageView(image: #imageLiteral(resourceName: "whatsapp (2)"))
        i.translatesAutoresizingMaskIntoConstraints = false
        i.constrainHeight(constant: 40)
        i.constrainWidth(constant: 40)
        i.clipsToBounds = true
        return i
    }()
    lazy var telphoneLabel = UILabel(text: "01123904214" , font: .systemFont(ofSize: 16), textColor: .black)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupNavigation()
        loadLinks()
        statusBarBackgroundColor()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHide(true)
    }
    
    //MARK:-User methods
    
    fileprivate func loadLinks()  {
        links = [
            "https://www.youtube.com/",
            "https://www.facebook.com/",
            "https://twitter.com/"
        ]
        
    }
    
    
    fileprivate func createImagesButton(image:UIImage,tag:Int) -> UIImageView  {
        let i = UIImageView(image: image)
        i.tag = tag
        i.isUserInteractionEnabled = true
        return i
    }
    
    fileprivate func setupViews()  {
        view.backgroundColor = #colorLiteral(red: 0.3416801989, green: 0.7294322848, blue: 0.6897809505, alpha: 1)//ColorConstant.mainBackgroundColor
        let imageStack = getStack(views: UIView(),twitterImage,facebookImage,youtubImage,UIView(), spacing: 8, distribution: .fillEqually, axis: .horizontal)
        
        let group = MOLHLanguage.isRTLLanguage() ?  getStack(views: emailImageView,emailLabel,UIView(), spacing: 8, distribution: .fill, axis: .horizontal) : getStack(views: UIView(),emailLabel,emailImageView, spacing: 8, distribution: .fill, axis: .horizontal)
        
        let group2 = MOLHLanguage.isRTLLanguage() ?  getStack(views: telephoneImageView,telphoneLabel,UIView(), spacing: 8, distribution: .fill, axis: .horizontal) : getStack(views: UIView(),telphoneLabel,telephoneImageView, spacing: 8, distribution: .fill, axis: .horizontal)
        
        let mainGroup = getStack(views: group,group2, spacing: 8, distribution: .fillEqually, axis: .vertical)
        
        view.addSubViews(views: mainView,logoImage,followLabel,imageStack,contactLabel,mainGroup)
        
        
        mainView.fillSuperview(padding: .init(top: 16, left: 0, bottom: -16, right: 0))
        
        
        logoImage.anchor(top: nil, leading: view.leadingAnchor, bottom: followLabel.topAnchor, trailing: view.trailingAnchor,padding: .init(top: 0, left: 32, bottom: 0, right: 32))
        followLabel.anchor(top: nil, leading: view.leadingAnchor, bottom: imageStack.topAnchor, trailing: view.trailingAnchor,padding: .init(top: 0, left: 0, bottom: 16, right: 0))
        imageStack.centerInSuperview(size: .init(width: view.frame.width - 64, height: 40))
        contactLabel.anchor(top: imageStack.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor,padding: .init(top: 32, left: 0, bottom: 0, right: 0))
        mainGroup.anchor(top: contactLabel.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor,padding: .init(top: 32, left: 64, bottom: 0, right: 64))
    }
    
    fileprivate func setupNavigation()  {
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        
        navigationItem.title = "Contact Us".localized
        let img:UIImage = (MOLHLanguage.isRTLLanguage() ?  UIImage(named:"back button-2") : #imageLiteral(resourceName: "back button-2")) ?? #imageLiteral(resourceName: "back button-2")
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: img.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleBack))
        //        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "back button-2").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleBack))
    }
    
    //TODO:-Handle methods
    
    @objc fileprivate  func handleBack()  {
        navigationController?.popViewController(animated: true)
    }
    
    @objc fileprivate func handleChoosedImage(sender:UIButton)  {
        guard let url = URL(string: links[sender.tag]) else { return  }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
}
