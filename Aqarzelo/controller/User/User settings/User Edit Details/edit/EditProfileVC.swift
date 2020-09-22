//
//  EditProfileVC.swift
//  Aqarzelo
//
//  Created by Hossam on 8/9/20.
//  Copyright © 2020 Hossam. All rights reserved.
//

import UIKit
import SDWebImage
import SVProgressHUD
import MOLH

protocol EditProfileVCProtocol {
    func reloadUserData()
}

class EditProfileVC: UIViewController {
    
    lazy var customErrorView:CustomErrorView = {
        let v = CustomErrorView()
        v.setupAnimation(name: "4970-unapproved-cross")
        v.okButton.addTarget(self, action: #selector(handleDoneError), for: .touchUpInside)
        return v
    }()
    lazy var customUpadteUserVview:CustomUpdateSserProfileView = {
        let v = CustomUpdateSserProfileView()
        v.setupAnimation(name: "15179-confirm-popup")
        v.okButton.addTarget(self, action: #selector(handleUpdate), for: .touchUpInside)
        v.cancelButton.addTarget(self, action: #selector(handleCancel), for: .touchUpInside)
        return v
    }()
    lazy var customMainAlertVC:CustomMainAlertVC = {
        let t = CustomMainAlertVC()
        t.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
        t.modalTransitionStyle = .crossDissolve
        t.modalPresentationStyle = .overCurrentContext
        return t
    }()
    
    var delgate:EditProfileVCProtocol?
    
    fileprivate var currentUser:UserModel!
    init(user:UserModel) {
        self.currentUser = user
        super.init(nibName: nil, bundle: nil)
    }
    
    
    
    fileprivate let cellPictureId = "cellPictureId"
    fileprivate let cellBackgroundId = "cellBackgroundId"
    fileprivate let cellId = "cellId"
    
    var textsArray = ["Email address".localized,"Phone number".localized,"Facebook","Address".localized,"Website".localized]
    var imagePicked = 0
    var imageProfileView = UIImageView()
    var imageBackgroundView = UIImageView()
    
    
    var finalEmail,phone,facebook,address,website:String?
    
    
    
    
    lazy var mainView:UIView = {
        let v = UIView(backgroundColor: .white)
        v.layer.cornerRadius = 16
        v.clipsToBounds = true
        return v
    }()
    
    lazy var tableView:UITableView = {
        let t = UITableView(backgroundColor: .white)
        t.delegate = self
        t.dataSource = self
        t.tableFooterView = UIView()
        t.register(UserEditPictureTableCell.self, forCellReuseIdentifier: cellPictureId)
        t.register(UserEditingBackgroundTableCell.self, forCellReuseIdentifier: cellBackgroundId)
        t.register(UserEditingInfoTableCell.self, forCellReuseIdentifier: cellId)
        t.showsVerticalScrollIndicator = false
        return t
    }()
    lazy var nextButton:UIButton = {
        let b = UIButton(title: "Save".localized, titleColor: .white, font: .systemFont(ofSize: 16), backgroundColor: #colorLiteral(red: 0.2100089788, green: 0.8682586551, blue: 0.7271742225, alpha: 1), target: self, action: #selector(handleNext))
        b.constrainHeight(constant: 50)
        b.layer.borderWidth = 4
        b.layer.borderColor = #colorLiteral(red: 0.2100089788, green: 0.8682586551, blue: 0.7271742225, alpha: 1).cgColor
        b.layer.cornerRadius = 16
        b.clipsToBounds = true
        return b
    }()
    
    fileprivate let imagePickeruser = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupNavigation()
        statusBarBackgroundColor()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadUserData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        SVProgressHUD.dismiss()
    }
    
    func loadUserData()  {
        finalEmail = currentUser.email
        phone = currentUser.phone
        facebook = currentUser.facebook
        website = currentUser.website
        address = currentUser.address
        
    }
    
    func setupViews()  {
        view.backgroundColor = #colorLiteral(red: 0.3416801989, green: 0.7294322848, blue: 0.6897809505, alpha: 1) //ColorConstant.mainBackgroundColor
        
        view.addSubViews(views: mainView,tableView,nextButton)
        
        mainView.fillSuperview(padding: .init(top: 16, left: 0, bottom: -20, right: 0))
        
        tableView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nextButton.topAnchor, trailing: view.trailingAnchor,padding: .init(top: 16, left: 16, bottom: 16, right: 16))
        nextButton.anchor(top: nil, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor,padding: .init(top: 0, left: 32, bottom: 32, right: 32))
    }
    
    func setupNavigation()  {
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        
        navigationItem.title = "Edit Profile".localized
        let img:UIImage = (MOLHLanguage.isRTLLanguage() ?  UIImage(named:"back button-2") : #imageLiteral(resourceName: "back button-2")) ?? #imageLiteral(resourceName: "back button-2")
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: img.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleBack))
        //        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "back button-2").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleBack))
    }
    
    func changeButtonState(sender:UIButton)  {
        sender.backgroundColor = #colorLiteral(red: 0.4301581085, green: 0.8535569906, blue: 0.6972886324, alpha: 1)//ColorConstant.mainBackgroundColor
        sender.setTitleColor(.white, for: .normal)
        customUpadteUserVview.cancelButton.backgroundColor = .white
        customUpadteUserVview.cancelButton.setTitleColor(.black, for: .normal)
    }
    
    
    
    @objc  func handleBack()  {
        navigationController?.popViewController(animated: true)
    }
    
    
    
    @objc func handleCancel(sender:UIButton)  {
        print(99999)
        changeButtonsPropertyWhenSelected(sender,vv:customUpadteUserVview.okButton)
        removeViewWithAnimation(vvv: sender)
        customMainAlertVC.dismiss(animated: true)
        
    }
    
    fileprivate func updateUserDataWithoutImages() {
        UserServices.shared.updateProfileUser(token: currentUser.apiToken, website: website ?? ""  , phone: phone ?? currentUser.phone ?? "", email: finalEmail ?? currentUser.email, address: address ?? "", facebook: facebook ?? "") { (user, err) in
            
            if let err=err{
                DispatchQueue.main.async {
                    SVProgressHUD.dismiss()
                    self.callMainError(err: err.localizedDescription, vc: self.customMainAlertVC, views: self.customErrorView)
                }
                self.activeViewsIfNoData();return
            }
            SVProgressHUD.dismiss()
            guard let user=user?.data else{return}
            self.currentUser = user
            
            DispatchQueue.main.async {
                userDefaults.set(true, forKey: UserDefaultsConstants.isUserEditProfile)
                userDefaults.synchronize()
                SVProgressHUD.dismiss()
                UIApplication.shared.endIgnoringInteractionEvents()
                self.tableView.reloadData()
            }
        }
    }
    
    fileprivate func updateUserProfiles() {
        //        UIApplication.shared.beginIgnoringInteractionEvents() // disbale all events in the screen
        
        progressHudProperties()
        
        UserServices.shared.updateProfileUser(token: currentUser.apiToken, coverImage: imageBackgroundView.image, photoImage: imageProfileView.image, website: website ?? ""  , phone: phone ?? currentUser.phone ?? "", email: finalEmail ?? currentUser.email, address: address ?? "", facebook: facebook ?? "") { (users, err) in
            
            if let err=err{
                DispatchQueue.main.async {
                    SVProgressHUD.dismiss()
                    self.callMainError(err: err.localizedDescription, vc: self.customMainAlertVC, views: self.customErrorView)
                }
                self.activeViewsIfNoData();return
            }
            SVProgressHUD.dismiss()
            self.activeViewsIfNoData()
            guard let user=users?.data else{return}
            cacheCurrentUserCodabe.save(user) //cache user model
            self.currentUser = user
            SVProgressHUD.showSuccess(withStatus: MOLHLanguage.isRTLLanguage() ? users?.messageAr :  users?.messageEn)
            DispatchQueue.main.async {
                userDefaults.set(true, forKey: UserDefaultsConstants.isUserEditProfile)
                userDefaults.synchronize()
                
                self.delgate?.reloadUserData()
                UIApplication.shared.endIgnoringInteractionEvents()
                self.tableView.reloadData()
            }
        }
    }
    
    //TODO: -Hnalde Methods
    
    //remove popup view
    @objc func handleDismiss()  {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleDoneError()  {
        removeViewWithAnimation(vvv: customErrorView)
        customMainAlertVC.dismiss(animated: true)
    }
    
    @objc func handleNext()  {
        customMainAlertVC.addCustomViewInCenter(views: customUpadteUserVview, height: 220)
        self.customUpadteUserVview.problemsView.play()
        
        customUpadteUserVview.problemsView.loopMode = .loop
        self.present(self.customMainAlertVC, animated: true)
    }
    
    @objc func handleUpdate(sender:UIButton)  {
        changeButtonsPropertyWhenSelected(sender,vv:customUpadteUserVview.cancelButton)
        removeViewWithAnimation(vvv: customUpadteUserVview)
        customMainAlertVC.dismiss(animated: true)
        updateUserProfiles()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension EditProfileVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = indexPath.row
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellPictureId, for: indexPath) as! UserEditPictureTableCell
            cell.index = index
            cell.user = currentUser
            //            imageProfileView = cell.profileImageView
            //            cell.profileImageView=imageProfileView ?? UIImageView()
            
            cell.handleEditUsingIndex = { [unowned self] (index,cell,tag,img) in // tag == 0 change profile picture
                self.imagePicked = tag
                self.imageProfileView.image = img
                self.setupImagePickerProfile()
            }
            
            cell.handleImageScalling = { img in
                let zoomImage = ZoomUserImageVC(img:img)
                self.navigationController?.pushViewController(zoomImage, animated: true)
            }
            
            return cell
        }else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellBackgroundId, for: indexPath) as! UserEditingBackgroundTableCell
            cell.index = index
            cell.user = currentUser
            //            imageBackgroundView = cell.backgroundImageView
            //            cell.backgroundImageView=imageBackgroundView ?? UIImageView()
            
            cell.handleEditUsingIndex = {[unowned self] (index,cell,tag,img) in
                self.imagePicked = tag
                self.imageBackgroundView.image = img
                self.setupImagePickerProfile()
            }
            
            cell.handleImageScalling = { img in
                let zoomImage = ZoomUserImageVC(img:img)
                self.navigationController?.pushViewController(zoomImage, animated: true)
            }
            
            
            
            return cell
        }else  {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! UserEditingInfoTableCell
            cell.index = index
            cell.editingTextField.text = index == 2 ? finalEmail : index == 3 ? phone : index == 4 ? facebook : index == 5 ? address : website
            let labelText = textsArray[indexPath.row-2]
            cell.profilePictureLabel.text = labelText
            //            cell.handleEditUsingIndex = { [unowned self] (index,cell) in
            //                self.handleEditData(cell: cell, index: index)
            //            }
            handleEditData(cell: cell, index: index)
            cell.handleGetTextValue = {[unowned self] (indexx,text) in
                self.giveTextToValues(index: indexx, text: text)
            }
            
            
            return cell
        }
        
    }
    
    func giveTextToValues(index:Int,text:String?)  {
        switch index {
            
        case 2:
            finalEmail =  text
        case 3:
            phone =  text
        case 4:
            facebook = text
        case 5:
            address = text
        default:
            website = text
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.row == 1 ? 180 : 120
    }
    
    //    func handleEditData(cell:UserEditingInfoTableCell,index:Int)  {
    //
    //        cell.mainView.isUserInteractionEnabled = true
    //        cell.mainView.layer.borderColor = UIColor.black.cgColor
    //    }
    
    func handleEditData(cell:UserEditingInfoTableCell,index:Int)  {
        if currentUser?.isExternal == 0 {
            cell.mainView.isUserInteractionEnabled = false
            cell.mainView.layer.borderColor = UIColor.lightGray.cgColor
        }else {
            cell.mainView.isUserInteractionEnabled = true
            cell.mainView.layer.borderColor = UIColor.black.cgColor
        }
    }
    
    func setupImagePickerProfile() {
        imagePickeruser.delegate = self
        imagePickeruser.sourceType = .photoLibrary
        imagePickeruser.allowsEditing = false
        present(imagePickeruser, animated: true, completion: nil)
    }
    
    
    
}

//MARK:-Extension

extension EditProfileVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController (_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        if let img = info[.originalImage]  as? UIImage   {
            if imagePicked == 0 {
                imageProfileView.image = img
                let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! UserEditPictureTableCell
                cell.profileImageView.image = img
            }else {
                imageBackgroundView.image = img
                let cell = tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as! UserEditingBackgroundTableCell
                cell.backgroundImageView.image = img
            }
        }
        
        
        dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
    
    
}
