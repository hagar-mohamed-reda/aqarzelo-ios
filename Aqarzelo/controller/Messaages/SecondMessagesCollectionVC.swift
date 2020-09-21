//
//  SecondMessagesCollectionVC.swift
//  Aqarzelo
//
//  Created by Hossam on 8/9/20.
//  Copyright © 2020 Hossam. All rights reserved.
//


import UIKit
import SVProgressHUD
import MOLH

class SecondMessagesCollectionVC: BaseCollectionVC {
    
    
    
    //    lazy var mainView:UIView = {
    //        let i = UIView(backgroundColor: .white)
    //        i.layer.cornerRadius = 16
    //        i.clipsToBounds = true
    //        return i
    //    }()
    lazy var refreshControl:UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.backgroundColor = UIColor.white
        refreshControl.tintColor = UIColor.black
        refreshControl.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
        
        return refreshControl
        
    }()
    lazy var customErrorView:CustomErrorView = {
           let v = CustomErrorView()
           v.setupAnimation(name: "4970-unapproved-cross")
           v.okButton.addTarget(self, action: #selector(handleDoneError), for: .touchUpInside)
           return v
       }()
    lazy var customSearchMessageView:CustomSearchMessageView = {
        let v = CustomSearchMessageView()
        if let frame = navigationController?.navigationBar.frame {
            //        v.constrainHeight(constant: frame.height-16 )
            v.constrainWidth(constant: frame.width-94 )
            v.constrainHeight(constant: 50)
            //        v.isHide(true)
            v.searchImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleRemoveTitleView)))
        }
        v.textView.delegate = self
        return v
    }()
    lazy var customMainAlertVC:CustomMainAlertVC = {
        let t = CustomMainAlertVC()
        t.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
        t.modalTransitionStyle = .crossDissolve
        t.modalPresentationStyle = .overCurrentContext
        return t
    }()
    lazy var customNoInternetView:CustomNoInternetView = {
        let v = CustomNoInternetView()
        v.setupAnimation(name: "4970-unapproved-cross")
        v.okButton.addTarget(self, action: #selector(handleOk), for: .touchUpInside)
        return v
    }()
    
    fileprivate let cellId = "cellId"
    fileprivate let cellHeaderId = "cellHeaderId"
    
    var isOpen:Bool = false
    //    var usersArrayIds = [UserIdsModel]()
    var filterArray = [UserIdsModel]()
    var usersArray : [UserIdsModel]? {
        didSet {
            guard let usersArray = usersArray else { return  }
        }
    }
    var dictUsers = [Int:UserIdsModel]()
    
    var currentUser:UserModel?{
        didSet{
            guard let currentUser = currentUser else { return  }
            fetchUsers()
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        statusBarBackgroundColor()
        fetchUsers()
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showOrHideCustomTabBar(hide: true)
        tabBarController?.tabBar.isHidden = true
        
        !ConnectivityInternet.isConnectedToInternet ?
            self.customMainAlertVC.addCustomViewInCenter(views: customNoInternetView, height: 150) : ()
        self.present(customMainAlertVC, animated: true)
        
        if userDefaults.bool(forKey: UserDefaultsConstants.isUserLogined) && currentUser == nil {
            self.currentUser=cacheCurrentUserCodabe.storedValue
        }
        if userDefaults.bool(forKey: UserDefaultsConstants.isSecondMessagedCached) {
            usersArray = cacheMessagesUserCodabe.storedValue
        }
        
        if !userDefaults.bool(forKey: UserDefaultsConstants.isSecondMessagedCached) {
            usersArray = nil
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isOpen {
            collectionView.noDataFound(filterArray.count, text: "No Data Added Yet".localized)
            return  filterArray.count
        }else {
            guard let usersArray = usersArray else { return 0 }
            
            collectionView.noDataFound(usersArray.count, text: "No Data Added Yet".localized)
            return  usersArray.count
        }
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        // Define the initial state (Before the animation)
        cell.alpha = 0
        
        // Define the final state (After the animation)
        UIView.animate(withDuration: 0.5, animations: { cell.alpha = 1 })
        
        
        //        // Define the initial state (Before the animation)
        //        let rotationAngleInRadians = 90.0 * CGFloat(Double.pi/180.0)
        //        let rotationTransform = CATransform3DMakeRotation(rotationAngleInRadians, 0, 0, 1)
        //        cell.layer.transform = rotationTransform
        //
        //        // Define the final state (After the animation)
        //        UIView.animate(withDuration: 1.0, animations: { cell.layer.transform = CATransform3DIdentity })
        
        
        //        let rotationTransform = CATransform3DTranslate(CATransform3DIdentity, -500, 100, 0)
        //        UIView.animate(withDuration: 0.5, animations: { cell.layer.transform = rotationTransform })
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! MessageCollectionCell
        guard let usersArray = usersArray else { return UICollectionViewCell() }
        
        let user = isOpen ? filterArray[indexPath.item] : usersArray[indexPath.item]
        //        let message = messagesArray[indexPath.item]
        
        cell.user = user
        return cell
    }
    
    override  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let currentUser = currentUser,let usersArray = usersArray else { return  }
        let user =  isOpen ?  filterArray[indexPath.item] :  usersArray[indexPath.item]
        
        let chatLog = ChatLogCollectionVC(userId: user.id, token: currentUser.apiToken)
        chatLog.targetUesrName  = user.name
        chatLog.targetUesrPhotoUrl = user.photoURL
        navigationController?.pushViewController(chatLog, animated: true)
        //        showOrHideCustomTabBar(hide: true)
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: cellHeaderId, for: indexPath) as! MessageHeaderView
        
        return header
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        .init(width: view.frame.width, height: 70)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width, height: 100)
    }
    
    override func setupCollection() {
        view.backgroundColor = #colorLiteral(red: 0.3416801989, green: 0.7294322848, blue: 0.6897809505, alpha: 1)
        collectionView.backgroundColor = .white
        collectionView.register(MessageHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: cellHeaderId)
        collectionView.register(MessageCollectionCell.self, forCellWithReuseIdentifier: cellId)
        //        collectionView.alwaysBounceHorizontal=true
        collectionView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
        collectionView.layer.cornerRadius = 24
        collectionView.clipsToBounds = true
    }
    
    func fetchUsers()  {
        guard let currentUser = currentUser else { return  }
        
        progressHudProperties()
        
        MessagesServices.shared.getUsersIds(api_token: currentUser.apiToken) { (users,keys, err) in
            if let error = err {
                DispatchQueue.main.async {
                    SVProgressHUD.dismiss()
                    self.callMainError(err: error.localizedDescription, vc: self.customMainAlertVC, views: self.customErrorView)
                }
                self.activeViewsIfNoData();return
            }
            SVProgressHUD.dismiss()
            guard let keys = keys,let users = users else {return}
            
            keys.forEach({ (i) in
                
                self.dictUsers[i] = users.first(where: {$0.id == i})
                
            })
            self.reloadDatas()
            
        }
        
    }
    
    func reloadDatas()  {
        
        usersArray = Array(dictUsers.values)
        usersArray = usersArray?.sorted(by: {$0.name > $1.name})
        cacheMessagesUserCodabe.save(usersArray!)
        userDefaults.set(true, forKey: UserDefaultsConstants.isSecondMessagedCached)
        userDefaults.synchronize()
        DispatchQueue.main.async {
            SVProgressHUD.dismiss()
            self.collectionView.refreshControl?.beginRefreshing()
            self.collectionView.refreshControl?.endRefreshing()
            //            self.refreshControl.beginRefreshing()
            //            self.refreshControl.endRefreshing()
            self.collectionView.reloadData()
            //            self.collectionView.collectionViewLayout.invalidateLayout()
            
        }
    }
    
    //MARK:-User methods
    
    override func setupNavigation()  {
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        
        navigationItem.rightBarButtonItem =  UIBarButtonItem(image: #imageLiteral(resourceName: "icons-search").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleSearch))
        
        navigationItem.title = "Messages".localized
        //         navigationItem.titleView = customSearchMessageView
        let img:UIImage = (MOLHLanguage.isRTLLanguage() ?  UIImage(named:"back button-2") : #imageLiteral(resourceName: "back button-2")) ?? #imageLiteral(resourceName: "back button-2")
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: img.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleBack))
        
    }
    
    //TODO:-Handle methods
    
    //remove popup view
    @objc func handleDismiss()  {
        dismiss(animated: true, completion: nil)
    }
    
    @objc fileprivate func handleSearch()  {
        isOpen = !isOpen
        navigationItem.titleView = customSearchMessageView
        navigationItem.rightBarButtonItem = nil
    }
    
    @objc  fileprivate func handleBack()  {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func handleDoneError()  {
           removeViewWithAnimation(vvv: customErrorView)
           customMainAlertVC.dismiss(animated: true)
       }
    
    @objc  func didPullToRefresh()  {
        fetchUsers()
    }
    
    @objc  func handleRemoveTitleView()  {
        
        filterUsers(text: customSearchMessageView.textView.text)
        DispatchQueue.main.async {
            
            
            self.navigationItem.rightBarButtonItem =  UIBarButtonItem(image: #imageLiteral(resourceName: "icons-search").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(self.handleSearch))
            //
            //    navigationItem.title = "Messages".localized
            self.navigationItem.titleView = nil
            self.collectionView.reloadData()
        }
        isOpen = !isOpen
        self.customSearchMessageView.textView.text = ""
        self.customSearchMessageView.handleTextChanged()
        //        self.customSearchMessageView.textViewDidChange(self.customSearchMessageView.textView )
    }
    
    @objc func handleOk()  {
        
        removeViewWithAnimation(vvv: customNoInternetView)
        customMainAlertVC.dismiss(animated: true)
    }
}

//MARK:-EXtensions




extension SecondMessagesCollectionVC: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let spacing = CharacterSet.whitespacesAndNewlines
        if !customSearchMessageView.textView.text.trimmingCharacters(in: spacing).isEmpty {
            let text = customSearchMessageView.textView.text!.lowercased()
            filterUsers(text: text)
        }else {
            view.endEditing(true)
            filterArray.removeAll()
        }
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
        
    }
    
    func filterUsers(text:String)  {
        guard let usersArray = usersArray else { return () }
        
        let tst = text.lowercased()
        filterArray = usersArray.filter({$0.name.lowercased().range(of: tst )  != nil}).sorted(by: {$0.name.compare($1.name) == .orderedAscending})
        
    }
}

class MessageHeaderView: UICollectionReusableView {
    lazy var headerLabel = UILabel(text: "Friends".localized, font: .systemFont(ofSize: 30), textColor: .black, textAlignment: MOLHLanguage.isRTLLanguage() ? .right : .left, numberOfLines: 1)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews()  {
        hstack(headerLabel).withMargins(.allSides(16))
    }
}
