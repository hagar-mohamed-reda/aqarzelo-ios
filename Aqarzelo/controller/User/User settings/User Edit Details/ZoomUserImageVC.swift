//
//  ZoomUserImageVC.swift
//  Aqarzelo
//
//  Created by Hossam on 8/9/20.
//  Copyright © 2020 Hossam. All rights reserved.
//

import UIKit
import SDWebImage
import WebKit
//import CTPanoramaView

class ZoomUserImageVC: UIViewController {
    
    lazy var mainWebView:WKWebView = {
        let v = WKWebView()
        v.uiDelegate = self
        v.isHide(true)
        return v
    }()
    lazy var mainImageView:UIImageView = {
        let i = UIImageView(image: img)
        i.contentMode = .scaleAspectFill
        i.enableZoom()
        return i
    }()
    
    var imageName:String?
    var photos:PhotoModel?{
        didSet {
            guard let photos=photos else {return}
            photos.is360 == 1 ? load360Image() : loadNormalPhoto()
            
            
        }
    }
    fileprivate let img:UIImage!
//    let panaromaView = CTPanoramaView()

    init(img:UIImage) {
        self.img = img
        super.init(nibName: nil, bundle: nil)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupNavigation()
        statusBarBackgroundColor()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHide(true)
        if let p  = imageName  {
            let urlString = p
            guard let url = URL(string: urlString)else {return}
            mainImageView.sd_setImage(with: url)
        }else {
            mainImageView.image = img
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHide(true)
    }
    
    func setupNavigation()  {
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")

        let label = UILabel(text: "Preview".localized, font: .systemFont(ofSize: 20), textColor: .white)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: label)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "×-1").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleClose))
    }
    
    func setupViews()  {
        view.backgroundColor = .lightGray
        
        view.addSubViews(views: mainImageView)
        
        mainImageView.centerInSuperview(size: .init(width: view.frame.width, height: 250))
    }
    
    func load360Image()  {
//        guard let photos=photos, let url = URL(string: photos.image) else {return}
////        let ss = photos.imageUrl?.toSecrueHttps()
////               guard let myURL = URL(string:"https://aqarzelo.com/public/panorama?image=\(ss)".toSecrueHttps()) else {return}
////        guard let img = img ,let url = URL(string: img.image) else { return  }
//              mainImageView.sd_setImage(with: url,placeholderImage: #imageLiteral(resourceName: "58889593bc2fc2ef3a1860c1"))
              
//              mainImageView.isHide(false)
//
//              panaromaView.image=img//mainImageView.image ?? #imageLiteral(resourceName: "58889593bc2fc2ef3a1860c1")
        
        guard let photos=photos else {return}
        mainWebView.isHide(false)
        mainImageView.isHide(true)

        let ss = photos.imageUrl?.toSecrueHttps()
        guard let myURL = URL(string:"https://aqarzelo.com/public/panorama?image=\(ss)".toSecrueHttps()) else {return}
        let myRequest = URLRequest(url: myURL)
        mainWebView.load(myRequest)
    }
    
    func loadNormalPhoto()  {
        if  let pp = photos?.imageUrl  {
            if pp != "" {
                guard let url = URL(string: pp) else { return  }
                mainImageView.sd_setImage(with: url)
                mainWebView.isHide(true)
                mainImageView.isHide(false)
            }else {
                  guard let photos = photos else { return  }
                mainImageView.image = photos.image ?? UIImage()
                mainWebView.isHide(true)
                mainImageView.isHide(false)
            }
            
        }
        
    }
    
    //
    @objc  func handleClose()  {
        navigationController?.popViewController(animated: true)
        print(365)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ZoomUserImageVC: WKUIDelegate{
    
}
