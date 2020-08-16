//
//  ChatLogCollectionVC.swift
//  Aqarzelo
//
//  Created by Hossam on 8/9/20.
//  Copyright © 2020 Hossam. All rights reserved.
//


import UIKit
import SVProgressHUD
import MOLH

class ChatLogCollectionVC: BaseViewController {
    
    fileprivate let cellId = "cellId"
    
    lazy var mainImage:UIView = {
        let i = UIView(backgroundColor: .white)
        i.layer.cornerRadius = 16
        i.clipsToBounds = true
        return i
    }()
    lazy var collectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = UICollectionView.ScrollDirection.vertical
        let c = UICollectionView(frame: .zero, collectionViewLayout: layout)
        c.delegate = self
        c.dataSource = self
        c.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        c.backgroundColor = .white
        c.register(ChatMessageCell.self, forCellWithReuseIdentifier: cellId)
        c.keyboardDismissMode = .interactive
        c.alwaysBounceVertical = true
        return c
    }()
    lazy var customTopView:ChatLogHeaderCell = {
        let v = ChatLogHeaderCell()
        v.targetName = targetUesrName
        v.targutUrl = targetUesrPhotoUrl
        v.constrainHeight(constant: 60)
        return v
    }()
    lazy var sendChatView:CustomSendView = {
        let v = CustomSendView()
        v.sendButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        //        v.constrainHeight(constant: 50)
        return v
    }()
    var messagesArray = [MessageModel]()
    var targetUesrName:String?
    var targetUesrPhotoUrl:String?
    
    fileprivate let userId:Int!
    fileprivate let userToken:String!
    init(userId:Int,token:String){
        self.userId = userId
        self.userToken = token
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        statusBarBackgroundColor()
        
        //        loadMessages()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showOrHideCustomTabBar(hide: true)
        tabBarController?.tabBar.isHidden = true
        navigationController?.navigationBar.isHide(false)
        loadMessages()
    }
    
    //MARK:-User methods
    
    fileprivate func loadMessages()  {
        messagesArray.removeAll()
        SVProgressHUD.setForegroundColor(UIColor.green)
        SVProgressHUD.show(withStatus: "Looding....".localized)
        MessagesServices.shared.getMessages(api_token: userToken, user_to: userId) { [unowned self] (base, err) in
            if let error = err {
                SVProgressHUD.showError(withStatus: error.localizedDescription)
            }
            SVProgressHUD.dismiss()
            guard let messages = base?.data else {return}
            self.messagesArray = messages
            self.reloadData()
        }
        
        
        
    }
    
    func loadNewerMessages()  {
        messagesArray.removeAll()
        MessagesServices.shared.getMessages(api_token: userToken, user_to: userId) { [unowned self] (base, err) in
            if let error = err {
                SVProgressHUD.showError(withStatus: error.localizedDescription)
            }
            guard let messages = base?.data else {return}
            self.messagesArray = messages
            self.goToLastIndex()
        }
    }
    
    func reloadData()  {
        //        messagesArray = messagesArray.uniques
        messagesArray = messagesArray.sorted(by: {$0.updatedAt < $1.updatedAt})
        DispatchQueue.main.async {
            SVProgressHUD.dismiss()
            self.goToLastIndex()
            self.collectionView.reloadData()
            
        }
    }
    
    fileprivate func goToLastIndex() {
        
        if messagesArray.count > 0 {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                //go to last message
                let index = IndexPath(item: self.messagesArray.count - 1 , section: 0)
                self.collectionView.scrollToItem(at: index, at: .bottom, animated: true)
            }
        }else {return}
    }
    
    override func setupViews() {
        view.backgroundColor = ColorConstant.mainBackgroundColor
        view.addSubViews(views: mainImage,customTopView,collectionView,sendChatView)
        
        mainImage.fillSuperview(padding: .init(top: 0, left: 0, bottom: -16, right: 0))
        customTopView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor)
        collectionView.anchor(top: customTopView.bottomAnchor, leading: view.leadingAnchor, bottom: sendChatView.topAnchor, trailing: view.trailingAnchor,padding: .init(top: 16, left: 16, bottom: 16, right: 16))
        sendChatView.anchor(top: nil, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor,padding: .init(top: 16, left: 16, bottom: 16, right: 16))
    }
    
    override func setupNavigation() {
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")

        navigationItem.title = "Messages".localized
        let img:UIImage = (MOLHLanguage.isRTLLanguage() ?  UIImage(named:"back button-2") : #imageLiteral(resourceName: "back button-2")) ?? #imageLiteral(resourceName: "back button-2")
             
             navigationItem.leftBarButtonItem = UIBarButtonItem(image: img.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleBack))
//        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "back button-2").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleBack))
        
    }
    
    //TODO:-Handle methods
    
    @objc  fileprivate func handleBack()  {
        navigationController?.popViewController(animated: true)
    }
    
    @objc fileprivate func handleNext()  {
        print(653)
    }
    
    fileprivate func resetAllData() {
        self.sendChatView.textView.text = ""
        self.sendChatView.handleTextChanged()
        self.sendChatView.textViewDidChange(self.sendChatView.textView )
    }
    
    @objc  func handleSend()  {
        guard let message = sendChatView.textView.text else { return  }
        
        MessagesServices.shared.sendMessage(message: message, token: userToken, toUser:String(describing: userId! )) {[unowned self] (base, err) in
            if let err=err{
                SVProgressHUD.showError(withStatus: err.localizedDescription)
                self.resetAllData()
            }
            self.loadNewerMessages()
        }
        resetAllData()
    }
}

//MARK:-Extensions

extension ChatLogCollectionVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messagesArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ChatMessageCell
        let message = messagesArray[indexPath.item]
        
        cell.configureData(index: userId, message: message)
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let message = messagesArray[indexPath.item]
        
        let height = message.message.getFrameForText(text: message.message)
        
        
        return .init(width: view.frame.width-32, height: height.height+60)
    }
    
}
