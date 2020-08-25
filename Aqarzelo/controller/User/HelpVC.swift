//
//  HelpVC.swift
//  Aqarzelo
//
//  Created by Hossam on 8/9/20.
//  Copyright © 2020 Hossam. All rights reserved.
//

import UIKit
import SVProgressHUD
import MOLH

class HelpVC: UIViewController {
    
    lazy var mainView:UIView = {
        let v = UIView(backgroundColor: .white)
        v.layer.cornerRadius = 16
        v.clipsToBounds = true
        return v
    }()
    
    
    lazy var logoImage:UIImageView = {
        let i = UIImageView(image:UIImage(named: "2663530-1"))
        //        i.constrainHeight(constant: 800)
        i.translatesAutoresizingMaskIntoConstraints = false
        return i
    }()
    lazy var discriptionLabel = UILabel(text: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged.".localized, font: .systemFont(ofSize: 16), textColor: .black,textAlignment: .center, numberOfLines: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupNavigation()
        statusBarBackgroundColor()
        //        fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHide(true)
    }
    
    //MARK:-User methods
    
    fileprivate  func setupViews()  {
        discriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        discriptionLabel.constrainHeight(constant: 200)
        view.backgroundColor = #colorLiteral(red: 0.3416801989, green: 0.7294322848, blue: 0.6897809505, alpha: 1) //ColorConstant.mainBackgroundColor
        view.addSubViews(views: mainView,logoImage,discriptionLabel)
        
        mainView.fillSuperview(padding: .init(top: 16, left: 0, bottom: -16, right: 0))
        //
        logoImage.anchor(top: nil, leading: nil, bottom: nil, trailing: nil,padding: .init(top: 0, left: 32, bottom: 0, right: 32))
        NSLayoutConstraint.activate([
            logoImage.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -120),
            logoImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
        discriptionLabel.anchor(top: logoImage.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor,padding: .init(top: 32, left: 32, bottom: 0, right: 32))
    }
    
    fileprivate  func setupNavigation()  {
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        
        navigationItem.title = "Help".localized
        let img:UIImage = (MOLHLanguage.isRTLLanguage() ?  UIImage(named:"back button-2") : #imageLiteral(resourceName: "back button-2")) ?? #imageLiteral(resourceName: "back button-2")
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: img.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleBack))
        //        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "back button-2").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleBack))
    }
    
    //TODO:-Handle methods
    
    @objc fileprivate  func handleBack()  {
        navigationController?.popViewController(animated: true)
    }
}
