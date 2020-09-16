//
//  UserProfileVC.swift
//  Aqarzelo
//
//  Created by Hossam on 8/9/20.
//  Copyright © 2020 Hossam. All rights reserved.
//

import UIKit
import SVProgressHUD
import MOLH

class UserProfileVC: UIViewController {
    
    
    
    lazy var fixedGeight = (view.frame.height - 128 ) / 2
    lazy var userBackgroundImageView: UIImageView = {
        let i = UIImageView(image: #imageLiteral(resourceName: "joshua-rawson-harris-LX0pplSjE2g-unsplash"))
        i.constrainHeight(constant: fixedGeight)
        i.isUserInteractionEnabled = true
        i.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleBackPreviewImage)))
        return i
    }()
    
    lazy var backImageView:UIImageView = {
        let i =  UIImageView(image:  MOLHLanguage.isRTLLanguage() ?  #imageLiteral(resourceName: "left-arrow") : #imageLiteral(resourceName: "back button-2"))
        return i
    }()
    lazy var bView:UIView = {
        let v = UIView(backgroundColor: .gray) //lightGray
        v.constrainWidth(constant: 30)
        v.constrainHeight(constant: 30)
        v.layer.cornerRadius = 15
        v.layer.borderWidth = 3
        v.layer.borderColor = UIColor.gray.cgColor
        v.clipsToBounds = true
        v.addSubview(backImageView)
        backImageView.fillSuperview()
        v.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleBack)))
        return v
    }()
    
    lazy var  subViewUserImage:UIView = {
        let subView = UIView(backgroundColor: .clear)
        subView.addSubViews(views: userEditProfileImageView)
        subView.hstack(userProfileImageView)
        subView.constrainWidth(constant: 120)
        subView.constrainHeight(constant: 120)
        subView.layer.borderWidth = 6
        subView.layer.borderColor = UIColor.white.cgColor
        subView.layer.cornerRadius = 60
        subView.clipsToBounds=true
        
        return subView
    }()
    
    
    lazy var userProfileImageView: UIImageView = {
        let i = UIImageView(backgroundColor: .gray)
        i.translatesAutoresizingMaskIntoConstraints = false
        //        i.constrainHeight(constant: 800)
        i.constrainHeight(constant: 100)
        i.constrainWidth(constant: 100)
        i.layer.cornerRadius = 50
        i.clipsToBounds = true
        i.isUserInteractionEnabled = true
        i.tag = 2
        i.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handlePreviewImage)))
        return i
    }()
    
    lazy var userNameLabel = UILabel(text: "", font: .systemFont(ofSize: 16), textColor: .black,textAlignment: .center)
    lazy var postsDetailsView:PostsDetailsView = {
        let v = PostsDetailsView()
        v.constrainWidth(constant: view.frame.width-128)
        v.constrainHeight(constant: 50)
        v.translatesAutoresizingMaskIntoConstraints = false
        //        v.isUserInteractionEnabled = true
        v.postsButton.addTarget(self, action: #selector(handleShowPosts), for: .touchUpInside)
        v.detailsButton.addTarget(self, action: #selector(handleShowDetails), for: .touchUpInside)
        return v
    }()
    
    lazy var userEditProfileImageView: UIImageView = {
        let i = UIImageView(image: #imageLiteral(resourceName: "Group 3923-6"))
        i.isUserInteractionEnabled = true
        i.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleEditProfile)))
        //        i.constrainHeight(constant: 800)
        i.constrainHeight(constant: 60)
        i.constrainWidth(constant: 60)
        //        i.layer.cornerRadius = 30
        i.clipsToBounds = true
        return i
    }()
    lazy var userPostsCollectionView:UserPostsCollectionVC = {
        let v = UserPostsCollectionVC()
        v.view.isHide(false)
        v.handleRefreshCollection = {[unowned self] in
            self.fetchUserData()
        }
        //        v.postsArray = userPosts
        //        v.collectionView.reloadData()
        v.delgate = self
        return v
    }()
    lazy var userDetailsCollectionView:UserPostsDetailsCollectionVC = {
        let v = UserPostsDetailsCollectionVC()
        v.currentUser = user
        v.handleRefreshCollection = {[unowned self] in
            self.fetchUserData()
        }
        //        v.collectionView.reloadData()
        v.view.isHide(true)
        return v
    }()
    
    @objc func didPullToRefresh()  {
        self.fetchUserData()
    }
    
    lazy var mainView:UIView = {
        let v = UIView(backgroundColor: .white)
        v.layer.cornerRadius = 16
        v.clipsToBounds = true
        return v
    }()
    var userPosts = [AqarModel]()
    //    var handleRefreshDetailsCollection:(()->Void)?
    //    var handleRefreshPostCollection:(()->Void)?
    
    var user:UserModel?  {
        didSet{
            guard let user=user else{return}
            self.putUserData(users:user)
        }
    }
    //    init(user:UserModel) {
    //        self.user = user
    //        self.reloadData = true
    //
    //        super.init(nibName: nil, bundle: nil)
    //        self.makeAnimation()
    //    }
    var reloadData = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        statusBarBackgroundColor()
    }
    
    
    //MARK: - override methods
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
        navigationController?.isNavigationBarHidden = true
        self.makeAnimation()
        if userDefaults.bool(forKey: UserDefaultsConstants.isUserLogined) {
            user=cacheCurrentUserCodabe.storedValue
        }
        if         !userDefaults.bool( forKey:UserDefaultsConstants.isAllUserPostsDetailsFetched){
            fetchUserData()
        }
        
        
        
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = true
        navigationController?.isNavigationBarHidden = false
    }
    
    //MARK:-User methods
    
    fileprivate func makeUserProfleAnimation(x:CGFloat,y:CGFloat) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            
            self.userProfileImageView.transform = CGAffineTransform(translationX: x, y: y)
        }) { (_) in
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
                self.userProfileImageView.transform = .identity
            })
        }
    }
    
    fileprivate  func makeAnimation()  {
        
        
        makeUserProfleAnimation(x: -1000, y: -1000)
    }
    
    func fetchUserData()  {
        guard let user = user else { return  }
        self.userPosts.removeAll()
        var group3: [AqarModel]?
        
        //        UIApplication.shared.beginIgnoringInteractionEvents() // disbale all events in the screen
        //        guard let api_Key = user.apiToken
        SVProgressHUD.setForegroundColor(UIColor.green)
        SVProgressHUD.show(withStatus: "Looding...".localized)
        let semaphore = DispatchSemaphore(value: 0)
        
        let dispatchQueue = DispatchQueue.global(qos: .background)
        
        
        dispatchQueue.async {
            //            UserServices.shared.getUserData(apiKey: self.user.apiToken) {[unowned self] (base, err) in
            //                if let error = err {
            //                    SVProgressHUD.showError(withStatus: error.localizedDescription)
            //                    self.activeViewsIfNoData();return
            //                }
            //                guard let users = base?.data else{SVProgressHUD.showError(withStatus: MOLHLanguage.isRTLLanguage() ?  base?.messageAr : base?.messageEn ); return}
            //
            //                self.putUserData(users:users)
            //                semaphore.signal()
            //            }
            //            semaphore.wait()
            
            UserServices.shared.getUserPosts(apiKeys: user.apiToken, completon: { (base, err) in
                if let error = err {
                    SVProgressHUD.showError(withStatus: error.localizedDescription)
                    self.activeViewsIfNoData();return
                }
                group3 = base?.data ?? []
                semaphore.signal()
            })
            semaphore.wait()
            
            semaphore.signal()
            self.reloadMainData(group3: group3)
            semaphore.wait()
            
        }
    }
    
    func reloadMainData(group3:[AqarModel]?)  {
        userDefaults.set(true, forKey: UserDefaultsConstants.isAllUserPostsDetailsFetched)
        userDefaults.synchronize()
        DispatchQueue.main.async {
            //                self.user =
            
            SVProgressHUD.dismiss()
            //            UIApplication.shared.endIgnoringInteractionEvents()
            self.userPostsCollectionView.postsArray = group3 ?? []
            
            self.userPostsCollectionView.refreshControl.beginRefreshing()
            self.userPostsCollectionView.refreshControl.endRefreshing()
            
            self.userDetailsCollectionView.refreshControl.beginRefreshing()
            self.userDetailsCollectionView.refreshControl.endRefreshing()
            self.userPostsCollectionView.collectionView.reloadData()
            self.reloadData = false
            self.view.layoutIfNeeded()
        }
        
    }
    
    
    fileprivate func putUserData(users:UserModel)  {
        DispatchQueue.main.async {[unowned self] in
            self.userNameLabel.text = users.name
            let urlString = users.photoURL ; let  urlSecondString = users.coverURL
            guard let url = URL(string: urlString)  else { return  }
            self.userProfileImageView.sd_setImage(with: url,placeholderImage: #imageLiteral(resourceName: "man-user"))
            
            guard let secondUrl = URL(string: urlSecondString)  else { return  }
            self.userBackgroundImageView.sd_setImage(with: secondUrl)
            
            
        }
        
        
    }
    
    fileprivate  func setupViews()  {
        view.backgroundColor = ColorConstant.mainBackgroundColor
        view.addSubViews(views: userBackgroundImageView,mainView,bView,subViewUserImage,userNameLabel,postsDetailsView,userEditProfileImageView,userPostsCollectionView.view,userDetailsCollectionView.view)
        
        mainView.fillSuperview(padding: .init(top: fixedGeight-16, left: 0, bottom: 0, right: 0))
        userBackgroundImageView.anchor(top: view.superview?.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor)
        
        bView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: nil,padding: .init(top: 48, left: 16, bottom: 0, right: 0))
        
        //
        subViewUserImage.anchor(top: userBackgroundImageView.bottomAnchor, leading: nil, bottom: nil, trailing: nil,padding: .init(top: -60, left: 0, bottom: 0, right: 0))
        //        logoProfileImageView.anchor(top: userProfileImageView.bottomAnchor, leading: nil, bottom: nil, trailing: userProfileImageView.trailingAnchor,padding: .init(top: -40, left: 0, bottom: 0, right: -8))
        
        userNameLabel.anchor(top: subViewUserImage.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor,padding: .init(top: 8, left: 0, bottom: 0, right: 0))
        
        NSLayoutConstraint.activate([
            userProfileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
            
            postsDetailsView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
            postsDetailsView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 58)
        ])
        userEditProfileImageView.anchor(top: postsDetailsView.topAnchor, leading: postsDetailsView.trailingAnchor, bottom: nil, trailing: nil,padding: .init(top: 0, left: 0, bottom: 0, right: 0))
        
        userPostsCollectionView.view.anchor(top: postsDetailsView.bottomAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor,padding: .init(top: 16, left: 16, bottom: 0, right: 16))
        userDetailsCollectionView.view.anchor(top: postsDetailsView.bottomAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor,padding: .init(top: 16, left: 16, bottom: 0, right: 16))
        
    }
    
    func previewImage(img:UIImage)  {
        showOrHideCustomTabBar(hide: true)
        let preview = ZoomUserImageVC(img: img)
        navigationController?.pushViewController(preview, animated: true)
    }
    
    func deletePost(post:AqarModel,index:Int)  {
        guard let user = user else { return  }
        
        UIApplication.shared.beginIgnoringInteractionEvents() // disbale all events in the screen
        SVProgressHUD.setForegroundColor(UIColor.green)
        SVProgressHUD.show(withStatus: "Looding....".localized)
        PostServices.shared.deletePost(api_token: user.apiToken, post_id: post.id ) { (base, error) in
            if let error = error {
                SVProgressHUD.showError(withStatus: error.localizedDescription)
                self.activeViewsIfNoData();return
            }
            SVProgressHUD.dismiss()
            self.activeViewsIfNoData()
            self.userPostsCollectionView.postsArray.remove(at: index)
            DispatchQueue.main.async {
                SVProgressHUD.dismiss()
                
                self.userPostsCollectionView.collectionView.reloadData()
                UIApplication.shared.endIgnoringInteractionEvents()
            }
        }
    }
    
    func updatePost(aqar:AqarModel)  {
        guard let user = user else { return  }
        
        let list = ListOfPhotoMainSecVC(currentUserToken:  user.apiToken, isFromUpdatePost: true)//ListOfPhotoCollectionVC( currentUserToken: user.apiToken)
        list.aqar = aqar
        navigationController?.pushViewController(list, animated: true)
    }
    
    func displayPost(aqar: AqarModel)  {
        guard let user = user else { return  }
        
        let detailAqar = AqarDetailsInfoVC(aqar: aqar)
        //        detailAqar.aqarsArray = aqarsArray
        detailAqar.userToken = user.apiToken
        navigationController?.pushViewController(detailAqar, animated: true)
    }
    
    func makePostAlert(post:AqarModel,index:Int)  {
        let alert = UIAlertController(title: "Choose Options".localized, message: "What do you want to make?".localized, preferredStyle: .actionSheet)
        let display = UIAlertAction(title: "Display".localized, style: .default) { (_) in
            self.displayPost(aqar: post)
        }
        let edit = UIAlertAction(title: "Edit".localized, style: .default) { (_) in
            self.updatePost(aqar: post)
        }
        let delete = UIAlertAction(title: "Delete".localized, style: .destructive) { (_) in
            self.deletePost(post: post, index: index)
        }
        let cancel = UIAlertAction(title: "Cancel".localized, style: .default) { (_) in
            alert.dismiss(animated: true)
        }
        alert.addAction(display)
        alert.addAction(edit)
        alert.addAction(delete)
        alert.addAction(cancel)
        present(alert, animated: true)
    }
    
    
    //TODO:-Handle methods
    
    @objc  func handleBackPreviewImage()  {
        previewImage(img: userBackgroundImageView.image ?? UIImage())
    }
    
    @objc func handlePreviewImage()  {
        previewImage(img: userProfileImageView.image ?? #imageLiteral(resourceName: "man-user"))
    }
    
    @objc fileprivate func handleShowPosts(sender:UIButton)  {
        print(2356)
        sender.setTitleColor(.blue, for: .normal)
        postsDetailsView.detailsButton.setTitleColor(.black, for: .normal)
        userPostsCollectionView.view.isHide(false)
        userDetailsCollectionView.view.isHide(true)
    }
    
    @objc fileprivate func handleShowDetails(sender:UIButton)  {
        print(365)
        sender.setTitleColor(.blue, for: .normal)
        postsDetailsView.postsButton.setTitleColor(.black, for: .normal)
        userDetailsCollectionView.view.isHide(false)
        userPostsCollectionView.view.isHide(true)
    }
    
    @objc fileprivate func handleEditProfile()  {
        print(654)
        guard let user = user else { return  }
        
        showOrHideCustomTabBar(hide: true)
        let edit = EditProfileVC(user: user)
        edit.delgate = self
        navigationController?.pushViewController(edit, animated: true)
    }
    
    @objc fileprivate  func handleBack() {
        navigationController?.popViewController(animated: true)
    }
    
    //    required init?(coder aDecoder: NSCoder) {
    //        fatalError("init(coder:) has not been implemented")
    //    }
}

extension UserProfileVC: UserPostsCollectionVCProtocol {
    func handleTakePost(post: AqarModel,index:Int) {
        makePostAlert(post: post, index: index)
    }
    
    
}


extension UserProfileVC : EditProfileVCProtocol {
    
    func reloadUserData() {
        reloadData = true
    }
}
