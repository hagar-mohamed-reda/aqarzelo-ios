//
//  MainCreatePostVC.swift
//  Aqarzelo
//
//  Created by Hossam on 8/9/20.
//  Copyright © 2020 Hossam. All rights reserved.
//


import UIKit
import SVProgressHUD
import MOLH

protocol MainCreatePostVCProtocol {
    func putLabelTextInView(text:String)
}

class MainCreatePostVC: UIViewController {
    
    var aqar:AqarModel?{
        didSet {
            guard let aqar = aqar else { return  }
            nextButton.isEnabled = true
            secondSelectedTop = true
            putDefaultDatas(aqar:aqar)
            self.middleFirstPostCollection.aqar = aqar
            self.middleSecondPostCollection.aqar = aqar
            self.middleThirdPostCollection.aqar = aqar
            
            
            nextButton.backgroundColor = ColorConstant.mainBackgroundColor
            [cutomtopView.first3View,cutomtopView.firstView,cutomtopView.first2View].forEach({$0.isUserInteractionEnabled = true})
        }
    }
    
    
    fileprivate let cellId = "cellId"
    lazy var scrollView: UIScrollView = {
        let v = UIScrollView()
        v.backgroundColor = .clear
        v.showsVerticalScrollIndicator=false
        return v
    }()
    lazy var mainImage:UIImageView = {
        let i = UIImageView(image: #imageLiteral(resourceName: "Rectangle 7"))
        i.constrainHeight(constant: 800)
        i.constrainWidth(constant: view.frame.width)
        return i
    }()
    lazy var cutomtopView:CustomTopView = {
        let v = CustomTopView()
        v.constrainHeight(constant: 60)
        //        v.aqar = aqar
        v.delgate = self
        return v
    }()
    
    
    lazy var middleFirstPostCollection:CreateFirstListCollectionVC = {
        let vc = CreateFirstListCollectionVC()
        vc.view.isHide(false)
        //         vc.view.isHide(true)
        vc.handleNextVC = { [unowned self] (isOpen,title,titleAr,category_id,type,spaceNum,roomNum,bathNum,priceMeter,totalPrice) in
            isOpen ? self.makeFirstOperation(title,titleAr, category_id, type, spaceNum,roomNum, bathNum, priceMeter, totalPrice, isOpen) : self.enableButton(isOpen, .white, second: false, third: false, last: false)
        }
        return vc
    }()// first create
    
    
    lazy  var middleSecondPostCollection:CreateSecondListCollectionVC = {
        let vc =  CreateSecondListCollectionVC()
        vc.delgate = self
        vc.view.isHide(true)
        //        vc.handleOpenDropDown = {[unowned self] frame in
        //            self.handleOpenDropDown(frame)
        //        }
        vc.handleNextVC = { [unowned self] (isOpen,lat,long,city,area,address,year,floor) in
            isOpen ? self.makeSecondOperation(lat, long, city, area, address, floor, year, isOpen) : self.enableButton(isOpen, .white, second: true, third: false, last: false)
        }
        return vc
    }()// second
    lazy  var middleThirdPostCollection:CreateThirddListCollectionVC = {
        let vc = CreateThirddListCollectionVC() // third
        vc.view.isHide(true)
        vc.handleNextVC = { [unowned self] (isOpen,discribe,ownType,payment,finiashed,moreTag) in
            
            isOpen ? self.makeThirdOperation(discribe, ownType, payment, finiashed, moreTag, isOpen) : self.enableButton(isOpen, .white, second: true, third: true, last: true)
        }
        return vc
    }()
    
    fileprivate let currentUserToken:String!
    init(token:String) {
        self.currentUserToken = token
        super.init(nibName: nil, bundle: nil)
    }
    
    var postEditing:AqarModel?
    var delgate:MainCreatePostVCProtocol?
    var isPostEditing:Bool = false
    
    var mainCcreatePostVviewModel = MainCreatePostViewModel() //view model
    
    
    lazy var nextButton:UIButton = {
        let b = UIButton(title: "Next".localized, titleColor: .black, font: .systemFont(ofSize: 16), backgroundColor: .white, target: self, action: #selector(handleNext))
        b.layer.borderWidth = 2
        b.layer.borderColor = #colorLiteral(red: 0.3588023782, green: 0.7468322515, blue: 0.7661533952, alpha: 1).cgColor
        b.layer.cornerRadius = 16
        b.clipsToBounds = true
        b.isEnabled = false
        b.constrainHeight(constant: 50)
        return b
    }()
    
    var firstSelectedTop = false
    var secondSelectedTop = false
    var thirdSelectedTop = false
    var lastVC = false
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupNavigation()
        setupMainCcreatePostVviewModelObserver()
        scrollView.delegate=self
        statusBarBackgroundColor()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showOrHideCustomTabBar(hide: true)
        tabBarController?.tabBar.isHide(true)
        
        
    }
    
    //MARK:-User methods
    
    
    fileprivate func makeFirstOperation(_ title: String?,_ titleAR:String?, _ category_id: Int?, _ type: String, _ spaceNum: Int?, _ bedNum: Int?, _ bathNum: Int?, _ priceMeter: Int?, _ totalPrice: Int?, _ isOpen: Bool) {
        self.takeFirstParameters(title: title!,titleAr: titleAR!, cate: category_id!, type: type, space: spaceNum!, bedNum: bedNum!, bath: bathNum!, pricePer: priceMeter!, totalPrice: totalPrice!)
        self.enableButton(isOpen, ColorConstant.mainBackgroundColor, second: true, third: false, last: false)
        self.cutomtopView.openFirst = true
    }
    
    fileprivate func makeSecondOperation(_ lat: Double?, _ long: Double?, _ city: Int?, _ area: Int?, _ address: String?, _ floor: Int?, _ year: String?, _ isOpen: Bool) {
        self.takeSecondParameters(lat: lat!, lng: long!, city: city!, area: area!, address: address!, floorNum: floor!, date: year!)
        self.enableButton(isOpen, ColorConstant.mainBackgroundColor, second: false, third: true, last: false)
        self.cutomtopView.openSecond = true
        
    }
    
    fileprivate func makeThirdOperation(_ discribe: String?, _ ownType: String?, _ payment: String?, _ finiashed: String?, _ moreTag: Int?, _ isOpen: Bool) {
        self.takeThirdParameters(discribe: discribe!, ownertype: ownType!, payment: payment!, finished: finiashed!, moreTag: moreTag!)
        self.enableButton(isOpen, ColorConstant.mainBackgroundColor, second: false, third: false, last: true)
        self.cutomtopView.openThird = true
    }
    
    fileprivate func enableButton(_ enable: Bool, _ background: UIColor,second:Bool,third:Bool,last:Bool) {
        self.nextButton.isEnabled = enable
        self.nextButton.backgroundColor = background
        secondSelectedTop = second
        thirdSelectedTop = third
        lastVC = last
    }
    
    
    
    //TOTDO:-cutom top view
    
    func setupMainCcreatePostVviewModelObserver()  {
        mainCcreatePostVviewModel.bindableIsFormValidate.bind {  [unowned self ]  (isValid) in
            guard let isValid = isValid else {return}
            self.middleFirstPostCollection.firstCcreatePostVviewModel.bindableIsFirst.value = isValid
            self.middleSecondPostCollection.secondCcreatePostVviewModel.bindableIsSecond.value = isValid
            self.middleThirdPostCollection.thirdCcreatePostVviewModel.bindableIsThird.value = isValid
        }
    }
    
    func handleChageSecondData()  {
        cutomtopView.first2View.backgroundColor = ColorConstant.mainBackgroundColor
        cutomtopView.first3View.backgroundColor = #colorLiteral(red: 0.9283686876, green: 0.9285209179, blue: 0.9283363223, alpha: 1)
        
        cutomtopView.first21Image.image =  UIImage(named: "221")
        cutomtopView.first31Image.image =  UIImage(named: "33")
    }
    
    func handleChageThirdData()  {
        cutomtopView.first3View.backgroundColor = ColorConstant.mainBackgroundColor
        cutomtopView.first2View.backgroundColor = ColorConstant.mainBackgroundColor
        cutomtopView.first21Image.image =  UIImage(named: "221")
        cutomtopView.first31Image.image =  UIImage(named: "331")
    }
    
    fileprivate func hideMiddleCollectionViewFirst() {
        DispatchQueue.main.async {
            self.middleSecondPostCollection.view.isHide(true)
            self.middleFirstPostCollection.view.isHide(false)
            self.middleThirdPostCollection.view.isHide(true)
            self.cutomtopView.openFirst = true
        }
    }
    
    fileprivate func hideMiddleCollectionViewSecond() {
        DispatchQueue.main.async {
            self.middleSecondPostCollection.view.isHide(false)
            self.middleFirstPostCollection.view.isHide(true)
            self.middleThirdPostCollection.view.isHide(true)
            self.handleChageSecondData()
            self.cutomtopView.openSecond = true
            //            self.nextButton.isEnabled = true
        }
    }
    
    fileprivate func hideMiddleCollectionViewThird() {
        DispatchQueue.main.async {
            
            
            self.middleSecondPostCollection.view.isHide(true)
            self.middleFirstPostCollection.view.isHide(true)
            self.middleThirdPostCollection.view.isHide(false)
            self.handleChageThirdData()
            self.cutomtopView.openThird = true
            //            self.nextButton.isEnabled = true
        }
    }
    
    fileprivate func presentFirstCell()  {
        firstSelectedTop = false
        //        secondSelectedTop = true
        enableButton(true, ColorConstant.mainBackgroundColor, second: true,third: false,last: false)
        hideMiddleCollectionViewFirst()
        
    }
    
    
    
    fileprivate func presentSecondCell()  {
        if aqar != nil {
            enableButton(true, ColorConstant.mainBackgroundColor, second: false,third: true,last: false)
            secondSelectedTop = false
            thirdSelectedTop = true
        }else {
            enableButton(false, .white, second: true,third: false,last: false)
            secondSelectedTop = !secondSelectedTop
            thirdSelectedTop = !thirdSelectedTop
            //            hideMiddleCollectionViewSecond()
        }
        hideMiddleCollectionViewSecond()
    }
    
    
    
    fileprivate  func presentThirdCell()  {
        
        if aqar != nil {
            enableButton(true, ColorConstant.mainBackgroundColor, second: false,third: false,last: true)
            secondSelectedTop = false
            thirdSelectedTop = false
            lastVC = true
            nextButton.setTitle("Update Post".localized , for: .normal)
        }else {
            enableButton(false, .white, second: true,third: true,last: false)
            
            nextButton.setTitle("Make Post".localized, for: .normal)
            
            secondSelectedTop = true
            thirdSelectedTop = true
            lastVC = false
        }
        hideMiddleCollectionViewThird()
    }
    
    fileprivate func setupViews()  {
        view.backgroundColor = .white//ColorConstant.mainBackgroundColor
        
        view.addSubViews(views: cutomtopView,nextButton,middleFirstPostCollection.view,middleThirdPostCollection.view,middleSecondPostCollection.view)
        
        
        cutomtopView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor)
        
        middleFirstPostCollection.view.anchor(top: cutomtopView.bottomAnchor, leading: view.leadingAnchor, bottom: nextButton.topAnchor, trailing: view.trailingAnchor,padding: .init(top: 8, left: 8, bottom: 8, right: 8))
        middleSecondPostCollection.view.anchor(top: cutomtopView.bottomAnchor, leading: view.leadingAnchor, bottom: nextButton.topAnchor, trailing: view.trailingAnchor,padding: .init(top: 8, left: 8, bottom: 8, right: 8))
        middleThirdPostCollection.view.anchor(top: cutomtopView.bottomAnchor, leading: view.leadingAnchor, bottom: nextButton.topAnchor, trailing: view.trailingAnchor,padding: .init(top: 8, left: 8, bottom: 8, right: 8))
        
        nextButton.anchor(top: nil, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor,padding: .init(top: 0, left: 16, bottom: 16, right: 16))
        
    }
    
    //MARK:-Post take parameters
    
    fileprivate  func takeFirstParameters(title:String,titleAr:String,cate:Int,type:String,space:Int,bedNum:Int,bath:Int,pricePer:Int,totalPrice:Int) {
        mainCcreatePostVviewModel.titleAr=titleAr
        mainCcreatePostVviewModel.title = title ;mainCcreatePostVviewModel.category = String(cate);mainCcreatePostVviewModel.sell = type
        mainCcreatePostVviewModel.space = String(space);mainCcreatePostVviewModel.roomNum=String(bedNum)
        mainCcreatePostVviewModel.bathsNum = String(bath);mainCcreatePostVviewModel.pricePer=String(pricePer);mainCcreatePostVviewModel.totalPrice=String(totalPrice)
        
    }
    
    fileprivate  func takeSecondParameters(lat:Double,lng:Double,city:Int,area:Int,address:String,floorNum:Int,date:String) {
        
        mainCcreatePostVviewModel.buildDate = date
        mainCcreatePostVviewModel.lat = String(lat);mainCcreatePostVviewModel.lng=String(lng)
        mainCcreatePostVviewModel.city = String(city);mainCcreatePostVviewModel.area=String(area);mainCcreatePostVviewModel.fllorNum=String(floorNum)
    }
    
    fileprivate  func takeThirdParameters(discribe:String,ownertype:String,payment:String,finished:String,moreTag:Int) {
        
        mainCcreatePostVviewModel.describe = discribe ;mainCcreatePostVviewModel.more = String(moreTag);mainCcreatePostVviewModel.ownerType = ownertype
        mainCcreatePostVviewModel.payment =  payment; mainCcreatePostVviewModel.finshed = finished
        
    }
    
    fileprivate  func setupNavigation()  {
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        
        navigationItem.title = "Create Post".localized
        let img:UIImage = (MOLHLanguage.isRTLLanguage() ?  UIImage(named:"back button-2") : #imageLiteral(resourceName: "back button-2")) ?? #imageLiteral(resourceName: "back button-2")
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: img.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleBack))
        //        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "back button-2").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleBack))
    }
    
    func putDefaultDatas(aqar:AqarModel)  {
        mainCcreatePostVviewModel.title = aqar.title; mainCcreatePostVviewModel.category = String(aqar.categoryID); mainCcreatePostVviewModel.sell = aqar.type;mainCcreatePostVviewModel.space = aqar.space; mainCcreatePostVviewModel.roomNum = aqar.bedroomNumber; mainCcreatePostVviewModel.bathsNum = aqar.bathroomNumber; mainCcreatePostVviewModel.pricePer = aqar.pricePerMeter;  mainCcreatePostVviewModel.totalPrice = String(aqar.price)
        
        mainCcreatePostVviewModel.lat = aqar.lat;mainCcreatePostVviewModel.lng = aqar.lng; mainCcreatePostVviewModel.city = String(aqar.cityID); mainCcreatePostVviewModel.area = String(aqar.areaID); mainCcreatePostVviewModel.buildDate = aqar.buildDate
        mainCcreatePostVviewModel.fllorNum = aqar.floorNumber
        
        mainCcreatePostVviewModel.describe = aqar.datumDescription; mainCcreatePostVviewModel.ownerType = aqar.ownerType;
        mainCcreatePostVviewModel.payment = aqar.paymentMethod; mainCcreatePostVviewModel.finshed = aqar.finishingType;
        
        let moreFurn = aqar.furnished
        let moreGarden = aqar.hasGarden
        let moreParking = aqar.hasParking
        
        mainCcreatePostVviewModel.more = moreFurn == 1 ? String(0) : moreGarden == 1 ? String(1) : moreParking == 1 ? String(2) : String(0)
        print(321)
        print(965)
    }
    
    fileprivate func makeOperationAfterPostMade(isUpdate:Bool,_ err: Error?) {
        if let err=err {
            SVProgressHUD.showError(withStatus: err.localizedDescription)
            self.activeViewsIfNoData();return
        }
        if isUpdate {
            userDefaults.set(true, forKey: UserDefaultsConstants.isPostUpdated)
            userDefaults.set(false, forKey: UserDefaultsConstants.isNextButtonPostUpdated)
            userDefaults.synchronize()
        }else {
            userDefaults.set(true, forKey: UserDefaultsConstants.isPostMaded)
            userDefaults.set(false, forKey: UserDefaultsConstants.isNextButtonPostMaded)
            userDefaults.set(false, forKey: UserDefaultsConstants.isNextButtonPostUpdated)
            userDefaults.synchronize()
        }
        SVProgressHUD.dismiss()
        //        self.navigationController?.popToRootViewController(animated: true)
        DispatchQueue.main.async {
            
            UIApplication.shared.endIgnoringInteractionEvents()
            //            self.goToHomeTabe()
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    func goToHomeTabe()  {
        if let home = UIWindow.key?.rootViewController as? HomeTabBarVC {
            home.selectedIndex = 0
            present(home, animated: true)
        }
    }
    
    func updatePost()  {
        if let aqar = aqar {
            if let p = aqar.datumDescription,let f = aqar.lat.toDouble(),let g = aqar.lng.toDouble(),let s = Double(aqar.space),let r = Double(aqar.pricePerMeter),let cc = aqar.bedroomNumber.toInt(),let rr = aqar.bathroomNumber.toInt(),let xx = aqar.floorNumber.toInt(){
                
                let more = mainCcreatePostVviewModel.more?.toInt()
                let rrr = Double(aqar.price)
                let moreFurn = more == 0 ? 1 : 0
                let moreGarden = more == 2 ? 1 : 0
                let moreParking = more == 1 ? 1 : 0
                
//                UIApplication.shared.beginIgnoringInteractionEvents() // disbale all events in the screen
                SVProgressHUD.setForegroundColor(UIColor.green)
                SVProgressHUD.show(withStatus: "Please Wait......".localized)
                
                PostServices.shared.updatePost(api_token: currentUserToken, title: aqar.title,titleAR:aqar.titleAr, description: p, category_id: aqar.categoryID, city_id: aqar.cityID, area_id: aqar.areaID, type: aqar.type, lat:  f, lng:  g, owner_type: aqar.ownerType, space: s, price_per_meter: r, price: rrr, payment_method: aqar.paymentMethod, finishing_type: aqar.finishingType, bedroom_number: cc, bathroom_number: rr, floor_number: xx, has_garden: moreGarden, has_parking: moreParking, has_furnished: moreFurn, build_date:aqar.buildDate ?? "" ,totalPrice:Double(aqar.price),postId: aqar.id) {[unowned self] (base, err) in
                    
                    self.makeOperationAfterPostMade(isUpdate: true, err)
                }
            }
        }
    }
    
    fileprivate func goToNextVC()  {
        
        aqar != nil ? updatePost() : makeNewPost()
        
        
    }
    
    
    
    func makeNewPost()  {
        
        guard let postDiscribe = mainCcreatePostVviewModel.describe, let postOwnerType = mainCcreatePostVviewModel.ownerType,
            let postPayment = mainCcreatePostVviewModel.payment,  let postFiniashed = mainCcreatePostVviewModel.finshed,
            let postYear = mainCcreatePostVviewModel.buildDate,
            let postType = mainCcreatePostVviewModel.sell,
            
            let postTitle = mainCcreatePostVviewModel.title,let postTitleAr = mainCcreatePostVviewModel.titleAr,
            
            
            //Int or double
            let postCity_id = Int(mainCcreatePostVviewModel.city ?? "1"),  let postArea_id = Int(mainCcreatePostVviewModel.area ?? "1"),
            let postCategory_id = Int(mainCcreatePostVviewModel.category ?? "1"),  let postSpaceNum = Int(mainCcreatePostVviewModel.space ?? "1"),
            let postBathNum = Int(mainCcreatePostVviewModel.bathsNum ?? "1"),  let postPriceMeter = Int(mainCcreatePostVviewModel.pricePer ?? "1"),let rrr=Int(mainCcreatePostVviewModel.totalPrice ?? "1"),
            let postBedNum = Int(mainCcreatePostVviewModel.roomNum ?? "1"),  let postTotalPrice = Int(mainCcreatePostVviewModel.totalPrice ?? "1"),
            let postFloor = Int(mainCcreatePostVviewModel.fllorNum ?? "1"), let postMoreTag = Int(mainCcreatePostVviewModel.more ?? "0"), let postLat = Double(mainCcreatePostVviewModel.lat ?? "0.0"), let postLng = Double(mainCcreatePostVviewModel.lng ?? "0.0") else { return  }
        
        
        let moreFurn = postMoreTag == 0 ? 1 : 0
        let moreGarden = postMoreTag == 2 ? 1 : 0
        let moreParking = postMoreTag == 1 ? 1 : 0
        
//        UIApplication.shared.beginIgnoringInteractionEvents() // disbale all events in the screen
        SVProgressHUD.setForegroundColor(UIColor.green)
        SVProgressHUD.show(withStatus: "Please Wait......".localized)
        
        PostServices.shared.addTotalPost(api_token: currentUserToken, title: postTitle, titleAR: postTitleAr , description: postDiscribe, category_id: postCategory_id, city_id: postCity_id, area_id: postArea_id, type: postType , lat:  postLat , lng:  postLng, owner_type: postOwnerType, space: Double(postSpaceNum), price_per_meter: postPriceMeter, price: rrr, payment_method: postPayment, finishing_type: postFiniashed, bedroom_number: postBedNum, bathroom_number: postBathNum, floor_number: postFloor, has_garden: moreGarden, has_parking: moreParking, has_furnished: moreFurn, build_date: postYear,totalPrice:postTotalPrice) { (base, err) in
            
            self.makeOperationAfterPostMade(isUpdate: false, err)
        }
        
    }
    //TODO:-Handle methods
    
    @objc fileprivate func handleNext(sender:UIButton)  {
        if firstSelectedTop {
            presentFirstCell()
            
        }else if secondSelectedTop  {
            presentSecondCell()
            //            secondSelectedTop = !secondSelectedTop
        }else if  thirdSelectedTop  {
            presentThirdCell()
            //            thirdSelectedTop = !thirdSelectedTop
        }else {
            goToNextVC()
        }
    }
    
    @objc fileprivate  func  handleBack()  {
        navigationController?.popViewController(animated: true)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK:- extension

extension MainCreatePostVC :CreateSecondListCollectionVCProtocol{
    
    func openMaps() {
        let choose = ChooseLocationVC()
        choose.delgate = self
        let nav = UINavigationController(rootViewController: choose)
        
        self.present(nav, animated: true)
        
    }
    
    
}

extension MainCreatePostVC: ChooseLocationVCProtocol {
    
    func getLatAndLong(lat: Double, long: Double) {
        if let cell =   middleSecondPostCollection.collectionView.cellForItem(at: IndexPath(item: 0, section: 0)) as? SecondCreateLocationCell {
            cell.handlerNext?(lat,long, true)
            cell.mapButton.backgroundColor = ColorConstant.mainBackgroundColor
        }
    }
    
    
    
}


extension MainCreatePostVC:CustomTopViewProtocolol {
    
    func openOne() {
        DispatchQueue.main.async {
            self.firstSelectedTop = true
            self.secondSelectedTop = false
            self.thirdSelectedTop = false
            self.nextButton.isEnabled = true
            self.nextButton.setTitle("Next".localized, for: .normal)
            self.handleNext(sender:self.nextButton)
        }
    }
    
    func openSecond() {
        DispatchQueue.main.async {
            self.firstSelectedTop = false
            self.secondSelectedTop = true
            self.thirdSelectedTop = false
            self.nextButton.isEnabled = true
            self.nextButton.setTitle("Next".localized, for: .normal)
            self.handleNext(sender:self.nextButton)
        }
        
        
    }
    
    func openThird() {
        DispatchQueue.main.async {
            self.firstSelectedTop = false
            self.secondSelectedTop = false
            self.thirdSelectedTop = true
            self.nextButton.isEnabled = true
            self.nextButton.setTitle(self.aqar != nil ?  "Update Post".localized : "Make Post".localized, for: .normal)
            self.handleNext(sender:self.nextButton)
            self.thirdSelectedTop = false
        }
    }
    
    
    
}

extension MainCreatePostVC:UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let x = scrollView.contentOffset.y
        self.scrollView.isScrollEnabled = x < -60 ? false : true
        
    }
}




//import UIKit
//import SVProgressHUD
//import MOLH
//
//protocol MainCreatePostVCProtocol {
//    func putLabelTextInView(text:String)
//}
//
//class MainCreatePostVC: UIViewController {
//
//    var aqar:AqarModel?{
//        didSet {
//            guard let aqar = aqar else { return  }
//            nextButton.isEnabled = true
//            secondSelectedTop = true
//            putDefaultDatas(aqar:aqar)
//            self.middleFirstPostCollection.aqar = aqar
//            self.middleSecondPostCollection.aqar = aqar
//            self.middleThirdPostCollection.aqar = aqar
//
//
//            nextButton.backgroundColor = ColorConstant.mainBackgroundColor
//            [cutomtopView.first3View,cutomtopView.firstView,cutomtopView.first2View].forEach({$0.isUserInteractionEnabled = true})
//        }
//    }
//
//
//    fileprivate let cellId = "cellId"
//    lazy var scrollView: UIScrollView = {
//        let v = UIScrollView()
//        v.backgroundColor = .clear
//        v.showsVerticalScrollIndicator=false
//        return v
//    }()
//    lazy var mainImage:UIImageView = {
//        let i = UIImageView(image: #imageLiteral(resourceName: "Rectangle 7"))
//        i.constrainHeight(constant: 800)
//        i.constrainWidth(constant: view.frame.width)
//        return i
//    }()
//    lazy var cutomtopView:CustomTopView = {
//        let v = CustomTopView()
//        v.constrainHeight(constant: 60)
//        //        v.aqar = aqar
//        v.delgate = self
//        return v
//    }()
//
//
//    lazy var middleFirstPostCollection:CreateFirstListCollectionVC = {
//        let vc = CreateFirstListCollectionVC()
//        vc.view.isHide(false)
//        //         vc.view.isHide(true)
//        vc.handleNextVC = { [unowned self] (isOpen,title,category_id,type,spaceNum,roomNum,bathNum,priceMeter,totalPrice) in
//            isOpen ? self.makeFirstOperation(title, category_id, type, spaceNum,roomNum, bathNum, priceMeter, totalPrice, isOpen) : self.enableButton(isOpen, .white, second: false, third: false, last: false)
//        }
//        return vc
//    }()// first create
//
//
//    lazy  var middleSecondPostCollection:CreateSecondListCollectionVC = {
//        let vc =  CreateSecondListCollectionVC()
//        vc.delgate = self
//        vc.view.isHide(true)
//        //        vc.handleOpenDropDown = {[unowned self] frame in
//        //            self.handleOpenDropDown(frame)
//        //        }
//        vc.handleNextVC = { [unowned self] (isOpen,lat,long,city,area,address,year,floor) in
//            isOpen ? self.makeSecondOperation(lat, long, city, area, address, floor, year, isOpen) : self.enableButton(isOpen, .white, second: true, third: false, last: false)
//        }
//        return vc
//    }()// second
//    lazy  var middleThirdPostCollection:CreateThirddListCollectionVC = {
//        let vc = CreateThirddListCollectionVC() // third
//        vc.view.isHide(true)
//        vc.handleNextVC = { [unowned self] (isOpen,discribe,ownType,payment,finiashed,moreTag) in
//
//            isOpen ? self.makeThirdOperation(discribe, ownType, payment, finiashed, moreTag, isOpen) : self.enableButton(isOpen, .white, second: true, third: true, last: true)
//        }
//        return vc
//    }()
//
//    fileprivate let currentUserToken:String!
//    init(token:String) {
//        self.currentUserToken = token
//        super.init(nibName: nil, bundle: nil)
//    }
//
//    var postEditing:AqarModel?
//    var delgate:MainCreatePostVCProtocol?
//    var isPostEditing:Bool = false
//
//    var mainCcreatePostVviewModel = MainCreatePostViewModel() //view model
//
//
//    lazy var nextButton:UIButton = {
//        let b = UIButton(title: "Next".localized, titleColor: .black, font: .systemFont(ofSize: 16), backgroundColor: .white, target: self, action: #selector(handleNext))
//        b.layer.borderWidth = 2
//        b.layer.borderColor = #colorLiteral(red: 0.3588023782, green: 0.7468322515, blue: 0.7661533952, alpha: 1).cgColor
//        b.layer.cornerRadius = 16
//        b.clipsToBounds = true
//        b.isEnabled = false
//        b.constrainHeight(constant: 50)
//        return b
//    }()
//
//    var firstSelectedTop = false
//    var secondSelectedTop = false
//    var thirdSelectedTop = false
//    var lastVC = false
//
//
//
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupViews()
//        setupNavigation()
//        setupMainCcreatePostVviewModelObserver()
//        scrollView.delegate=self
//        statusBarBackgroundColor()
//    }
//
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        showOrHideCustomTabBar(hide: true)
//        tabBarController?.tabBar.isHide(true)
//
//
//    }
//
//    //MARK:-User methods
//
//
//    fileprivate func makeFirstOperation(_ title: String?, _ category_id: Int?, _ type: String, _ spaceNum: Int?, _ bedNum: Int?, _ bathNum: Int?, _ priceMeter: Int?, _ totalPrice: Int?, _ isOpen: Bool) {
//        self.takeFirstParameters(title: title!, cate: category_id!, type: type, space: spaceNum!, bedNum: bedNum!, bath: bathNum!, pricePer: priceMeter!, totalPrice: totalPrice!)
//        self.enableButton(isOpen, ColorConstant.mainBackgroundColor, second: true, third: false, last: false)
//        self.cutomtopView.openFirst = true
//    }
//
//    fileprivate func makeSecondOperation(_ lat: Double?, _ long: Double?, _ city: Int?, _ area: Int?, _ address: String?, _ floor: Int?, _ year: String?, _ isOpen: Bool) {
//        self.takeSecondParameters(lat: lat!, lng: long!, city: city!, area: area!, address: address!, floorNum: floor!, date: year!)
//        self.enableButton(isOpen, ColorConstant.mainBackgroundColor, second: false, third: true, last: false)
//        self.cutomtopView.openSecond = true
//
//    }
//
//    fileprivate func makeThirdOperation(_ discribe: String?, _ ownType: String?, _ payment: String?, _ finiashed: String?, _ moreTag: Int?, _ isOpen: Bool) {
//        self.takeThirdParameters(discribe: discribe!, ownertype: ownType!, payment: payment!, finished: finiashed!, moreTag: moreTag!)
//        self.enableButton(isOpen, ColorConstant.mainBackgroundColor, second: false, third: false, last: true)
//        self.cutomtopView.openThird = true
//    }
//
//    fileprivate func enableButton(_ enable: Bool, _ background: UIColor,second:Bool,third:Bool,last:Bool) {
//        self.nextButton.isEnabled = enable
//        self.nextButton.backgroundColor = background
//        secondSelectedTop = second
//        thirdSelectedTop = third
//        lastVC = last
//    }
//
//
//
//    //TOTDO:-cutom top view
//
//    func setupMainCcreatePostVviewModelObserver()  {
//        mainCcreatePostVviewModel.bindableIsFormValidate.bind {  [unowned self ]  (isValid) in
//            guard let isValid = isValid else {return}
//            self.middleFirstPostCollection.firstCcreatePostVviewModel.bindableIsFirst.value = isValid
//            self.middleSecondPostCollection.secondCcreatePostVviewModel.bindableIsSecond.value = isValid
//            self.middleThirdPostCollection.thirdCcreatePostVviewModel.bindableIsThird.value = isValid
//        }
//    }
//
//    func handleChageSecondData()  {
//        cutomtopView.first2View.backgroundColor = ColorConstant.mainBackgroundColor
//        cutomtopView.first3View.backgroundColor = #colorLiteral(red: 0.9283686876, green: 0.9285209179, blue: 0.9283363223, alpha: 1)
//
//        cutomtopView.first21Image.image =  UIImage(named: "221")
//        cutomtopView.first31Image.image =  UIImage(named: "33")
//    }
//
//    func handleChageThirdData()  {
//        cutomtopView.first3View.backgroundColor = ColorConstant.mainBackgroundColor
//        cutomtopView.first2View.backgroundColor = ColorConstant.mainBackgroundColor
//        cutomtopView.first21Image.image =  UIImage(named: "221")
//        cutomtopView.first31Image.image =  UIImage(named: "331")
//    }
//
//    fileprivate func hideMiddleCollectionViewFirst() {
//        DispatchQueue.main.async {
//            self.middleSecondPostCollection.view.isHide(true)
//            self.middleFirstPostCollection.view.isHide(false)
//            self.middleThirdPostCollection.view.isHide(true)
//            self.cutomtopView.openFirst = true
//        }
//    }
//
//    fileprivate func hideMiddleCollectionViewSecond() {
//        DispatchQueue.main.async {
//            self.middleSecondPostCollection.view.isHide(false)
//            self.middleFirstPostCollection.view.isHide(true)
//            self.middleThirdPostCollection.view.isHide(true)
//            self.handleChageSecondData()
//            self.cutomtopView.openSecond = true
//            //            self.nextButton.isEnabled = true
//        }
//    }
//
//    fileprivate func hideMiddleCollectionViewThird() {
//        DispatchQueue.main.async {
//
//
//            self.middleSecondPostCollection.view.isHide(true)
//            self.middleFirstPostCollection.view.isHide(true)
//            self.middleThirdPostCollection.view.isHide(false)
//            self.handleChageThirdData()
//            self.cutomtopView.openThird = true
//            //            self.nextButton.isEnabled = true
//        }
//    }
//
//    fileprivate func presentFirstCell()  {
//        firstSelectedTop = false
//        //        secondSelectedTop = true
//        enableButton(true, ColorConstant.mainBackgroundColor, second: true,third: false,last: false)
//        hideMiddleCollectionViewFirst()
//
//    }
//
//
//
//    fileprivate func presentSecondCell()  {
//        if aqar != nil {
//            enableButton(true, ColorConstant.mainBackgroundColor, second: false,third: true,last: false)
//            secondSelectedTop = false
//            thirdSelectedTop = true
//        }else {
//            enableButton(false, .white, second: true,third: false,last: false)
//            secondSelectedTop = !secondSelectedTop
//            thirdSelectedTop = !thirdSelectedTop
//            //            hideMiddleCollectionViewSecond()
//        }
//        hideMiddleCollectionViewSecond()
//    }
//
//
//
//    fileprivate  func presentThirdCell()  {
//
//        if aqar != nil {
//            enableButton(true, ColorConstant.mainBackgroundColor, second: false,third: false,last: true)
//            secondSelectedTop = false
//            thirdSelectedTop = false
//            lastVC = true
//            nextButton.setTitle("Update Post".localized , for: .normal)
//        }else {
//            enableButton(false, .white, second: true,third: true,last: false)
//
//            nextButton.setTitle("Make Post".localized, for: .normal)
//
//            secondSelectedTop = true
//            thirdSelectedTop = true
//            lastVC = false
//        }
//        hideMiddleCollectionViewThird()
//    }
//
//    fileprivate func setupViews()  {
//        view.backgroundColor = .white//ColorConstant.mainBackgroundColor
//
//        view.addSubViews(views: cutomtopView,nextButton,middleFirstPostCollection.view,middleThirdPostCollection.view,middleSecondPostCollection.view)
//
//
//        cutomtopView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor)
//
//        middleFirstPostCollection.view.anchor(top: cutomtopView.bottomAnchor, leading: view.leadingAnchor, bottom: nextButton.topAnchor, trailing: view.trailingAnchor,padding: .init(top: 8, left: 8, bottom: 8, right: 8))
//        middleSecondPostCollection.view.anchor(top: cutomtopView.bottomAnchor, leading: view.leadingAnchor, bottom: nextButton.topAnchor, trailing: view.trailingAnchor,padding: .init(top: 8, left: 8, bottom: 8, right: 8))
//        middleThirdPostCollection.view.anchor(top: cutomtopView.bottomAnchor, leading: view.leadingAnchor, bottom: nextButton.topAnchor, trailing: view.trailingAnchor,padding: .init(top: 8, left: 8, bottom: 8, right: 8))
//
//        nextButton.anchor(top: nil, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor,padding: .init(top: 0, left: 16, bottom: 16, right: 16))
//
//    }
//
//    //MARK:-Post take parameters
//
//    fileprivate  func takeFirstParameters(title:String,cate:Int,type:String,space:Int,bedNum:Int,bath:Int,pricePer:Int,totalPrice:Int) {
//
//        mainCcreatePostVviewModel.title = title ;mainCcreatePostVviewModel.category = String(cate);mainCcreatePostVviewModel.sell = type
//        mainCcreatePostVviewModel.space = String(space);mainCcreatePostVviewModel.roomNum=String(bedNum)
//        mainCcreatePostVviewModel.bathsNum = String(bath);mainCcreatePostVviewModel.pricePer=String(pricePer);mainCcreatePostVviewModel.totalPrice=String(totalPrice)
//
//    }
//
//    fileprivate  func takeSecondParameters(lat:Double,lng:Double,city:Int,area:Int,address:String,floorNum:Int,date:String) {
//
//        mainCcreatePostVviewModel.buildDate = date
//        mainCcreatePostVviewModel.lat = String(lat);mainCcreatePostVviewModel.lng=String(lng)
//        mainCcreatePostVviewModel.city = String(city);mainCcreatePostVviewModel.area=String(area);mainCcreatePostVviewModel.fllorNum=String(floorNum)
//    }
//
//    fileprivate  func takeThirdParameters(discribe:String,ownertype:String,payment:String,finished:String,moreTag:Int) {
//
//        mainCcreatePostVviewModel.describe = discribe ;mainCcreatePostVviewModel.more = String(moreTag);mainCcreatePostVviewModel.ownerType = ownertype
//        mainCcreatePostVviewModel.payment =  payment; mainCcreatePostVviewModel.finshed = finished
//
//    }
//
//    fileprivate  func setupNavigation()  {
//        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
//
//        navigationItem.title = "Create Post".localized
//        let img:UIImage = (MOLHLanguage.isRTLLanguage() ?  UIImage(named:"back button-2") : #imageLiteral(resourceName: "back button-2")) ?? #imageLiteral(resourceName: "back button-2")
//
//        navigationItem.leftBarButtonItem = UIBarButtonItem(image: img.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleBack))
//        //        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "back button-2").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleBack))
//    }
//
//    func putDefaultDatas(aqar:AqarModel)  {
//        mainCcreatePostVviewModel.title = aqar.title; mainCcreatePostVviewModel.category = String(aqar.categoryID); mainCcreatePostVviewModel.sell = aqar.type;mainCcreatePostVviewModel.space = aqar.space; mainCcreatePostVviewModel.roomNum = aqar.bedroomNumber; mainCcreatePostVviewModel.bathsNum = aqar.bathroomNumber; mainCcreatePostVviewModel.pricePer = aqar.pricePerMeter;  mainCcreatePostVviewModel.totalPrice = String(aqar.price)
//
//        mainCcreatePostVviewModel.lat = aqar.lat;mainCcreatePostVviewModel.lng = aqar.lng; mainCcreatePostVviewModel.city = String(aqar.cityID); mainCcreatePostVviewModel.area = String(aqar.areaID); mainCcreatePostVviewModel.buildDate = aqar.buildDate
//        mainCcreatePostVviewModel.fllorNum = aqar.floorNumber
//
//        mainCcreatePostVviewModel.describe = aqar.datumDescription; mainCcreatePostVviewModel.ownerType = aqar.ownerType;
//        mainCcreatePostVviewModel.payment = aqar.paymentMethod; mainCcreatePostVviewModel.finshed = aqar.finishingType;
//
//        let moreFurn = aqar.furnished
//        let moreGarden = aqar.hasGarden
//        let moreParking = aqar.hasParking
//
//        mainCcreatePostVviewModel.more = moreFurn == 1 ? String(0) : moreGarden == 1 ? String(1) : moreParking == 1 ? String(2) : String(0)
//        print(321)
//        print(965)
//    }
//
//    fileprivate func makeOperationAfterPostMade(isUpdate:Bool,_ err: Error?) {
//        if let err=err {
//            SVProgressHUD.showError(withStatus: err.localizedDescription)
//            self.activeViewsIfNoData();return
//        }
//        if isUpdate {
//            userDefaults.set(true, forKey: UserDefaultsConstants.isPostUpdated)
//            userDefaults.set(false, forKey: UserDefaultsConstants.isNextButtonPostUpdated)
//            var ss = cacheFavoriteAqarsCodabe.storedValue
//            //            let dd = ss.
//            ss?.removeAll(where: {$0.id == aqar?.id })
//            cacheFavoriteAqarsCodabe.save(ss!)
//            //            ss?.remove(at:
//
//            userDefaults.synchronize()
//        }else {
//            userDefaults.set(true, forKey: UserDefaultsConstants.isPostMaded)
//            userDefaults.set(false, forKey: UserDefaultsConstants.isNextButtonPostMaded)
//            userDefaults.set(false, forKey: UserDefaultsConstants.isNextButtonPostUpdated)
//
//            userDefaults.synchronize()
//        }
//        SVProgressHUD.dismiss()
//        //        self.navigationController?.popToRootViewController(animated: true)
//        DispatchQueue.main.async {
//
//            UIApplication.shared.endIgnoringInteractionEvents()
//            //            self.goToHomeTabe()
//            self.navigationController?.popToRootViewController(animated: true)
//        }
//    }
//
//    func goToHomeTabe()  {
//        if let home = UIWindow.key?.rootViewController as? HomeTabBarVC {
//            home.selectedIndex = 0
//            present(home, animated: true)
//        }
//    }
//
//    func updatePost()  {
//        if let aqar = aqar {
//            if let p = aqar.datumDescription,let f = aqar.lat.toDouble(),let g = aqar.lng.toDouble(),let s = Double(aqar.space),let r = Double(aqar.pricePerMeter),let cc = aqar.bedroomNumber.toInt(),let rr = aqar.bathroomNumber.toInt(),let xx = aqar.floorNumber.toInt(){
//
//                let more = mainCcreatePostVviewModel.more?.toInt()
//
//                let moreFurn = more == 0 ? 1 : 0
//                let moreGarden = more == 2 ? 1 : 0
//                let moreParking = more == 1 ? 1 : 0
//
//                //                UIApplication.shared.beginIgnoringInteractionEvents() // disbale all events in the screen
//                SVProgressHUD.setForegroundColor(UIColor.green)
//                SVProgressHUD.show(withStatus: "Please Wait......".localized)
//
//                PostServices.shared.updatePost(api_token: currentUserToken, title: aqar.title, description: p, category_id: aqar.categoryID, city_id: aqar.cityID, area_id: aqar.areaID, type: aqar.type, lat:  f, lng:  g, owner_type: aqar.ownerType, space: s, price_per_meter: r, payment_method: aqar.paymentMethod, finishing_type: aqar.finishingType, bedroom_number: cc, bathroom_number: rr, floor_number: xx, has_garden: moreGarden, has_parking: moreParking, has_furnished: moreFurn, build_date:aqar.buildDate ?? "" ,totalPrice:Double(aqar.price),postId: aqar.id) {[unowned self] (base, err) in
//
//                    self.makeOperationAfterPostMade(isUpdate: true, err)
//                }
//            }
//        }
//    }
//
//    fileprivate func goToNextVC()  {
//
//        aqar != nil ? updatePost() : makeNewPost()
//
//
//    }
//
//
//
//    func makeNewPost()  {
//
//        guard let postDiscribe = mainCcreatePostVviewModel.describe, let postOwnerType = mainCcreatePostVviewModel.ownerType,
//            let postPayment = mainCcreatePostVviewModel.payment,  let postFiniashed = mainCcreatePostVviewModel.finshed,
//            let postYear = mainCcreatePostVviewModel.buildDate,
//            let postType = mainCcreatePostVviewModel.sell,
//
//            let postTitle = mainCcreatePostVviewModel.title,
//
//
//            //Int or double
//            let postCity_id = Int(mainCcreatePostVviewModel.city ?? "1"),  let postArea_id = Int(mainCcreatePostVviewModel.area ?? "1"),
//            let postCategory_id = Int(mainCcreatePostVviewModel.category ?? "1"),  let postSpaceNum = Int(mainCcreatePostVviewModel.space ?? "1"),
//            let postBathNum = Int(mainCcreatePostVviewModel.bathsNum ?? "1"),  let postPriceMeter = Int(mainCcreatePostVviewModel.pricePer ?? "1"),
//            let postBedNum = Int(mainCcreatePostVviewModel.roomNum ?? "1"),  let postTotalPrice = Int(mainCcreatePostVviewModel.totalPrice ?? "1"),
//            let postFloor = Int(mainCcreatePostVviewModel.fllorNum ?? "1"), let postMoreTag = Int(mainCcreatePostVviewModel.more ?? "0"), let postLat = Double(mainCcreatePostVviewModel.lat ?? "0.0"), let postLng = Double(mainCcreatePostVviewModel.lng ?? "0.0") else { return  }
//
//
//        let moreFurn = postMoreTag == 0 ? 1 : 0
//        let moreGarden = postMoreTag == 2 ? 1 : 0
//        let moreParking = postMoreTag == 1 ? 1 : 0
//
//        //        UIApplication.shared.beginIgnoringInteractionEvents() // disbale all events in the screen
//        SVProgressHUD.setForegroundColor(UIColor.green)
//        SVProgressHUD.show(withStatus: "Please Wait......".localized)
//
//        PostServices.shared.addTotalPost(api_token: currentUserToken, title: postTitle , description: postDiscribe, category_id: postCategory_id, city_id: postCity_id, area_id: postArea_id, type: postType , lat:  postLat , lng:  postLng, owner_type: postOwnerType, space: Double(postSpaceNum), price_per_meter: postPriceMeter, payment_method: postPayment, finishing_type: postFiniashed, bedroom_number: postBedNum, bathroom_number: postBathNum, floor_number: postFloor, has_garden: moreGarden, has_parking: moreParking, has_furnished: moreFurn, build_date: postYear,totalPrice:postTotalPrice) { (base, err) in
//
//            self.makeOperationAfterPostMade(isUpdate: false, err)
//        }
//
//    }
//    //TODO:-Handle methods
//
//    @objc fileprivate func handleNext(sender:UIButton)  {
//        if firstSelectedTop {
//            presentFirstCell()
//
//        }else if secondSelectedTop  {
//            presentSecondCell()
//            //            secondSelectedTop = !secondSelectedTop
//        }else if  thirdSelectedTop  {
//            presentThirdCell()
//            //            thirdSelectedTop = !thirdSelectedTop
//        }else {
//            goToNextVC()
//        }
//    }
//
//    @objc fileprivate  func  handleBack()  {
//        navigationController?.popViewController(animated: true)
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//}
//
////MARK:- extension
//
//extension MainCreatePostVC :CreateSecondListCollectionVCProtocol{
//
//    func openMaps() {
//        let choose = ChooseLocationVC()
//        choose.delgate = self
//        let nav = UINavigationController(rootViewController: choose)
//
//        self.present(nav, animated: true)
//
//    }
//
//
//}
//
//extension MainCreatePostVC: ChooseLocationVCProtocol {
//
//    func getLatAndLong(lat: Double, long: Double) {
//        if let cell =   middleSecondPostCollection.collectionView.cellForItem(at: IndexPath(item: 0, section: 0)) as? SecondCreateLocationCell {
//            cell.handlerNext?(lat,long, true)
//            cell.mapButton.backgroundColor = ColorConstant.mainBackgroundColor
//        }
//    }
//
//
//
//}
//
//
//extension MainCreatePostVC:CustomTopViewProtocolol {
//
//    func openOne() {
//        DispatchQueue.main.async {
//            self.firstSelectedTop = true
//            self.secondSelectedTop = false
//            self.thirdSelectedTop = false
//            self.nextButton.isEnabled = true
//            self.nextButton.setTitle("Next".localized, for: .normal)
//            self.handleNext(sender:self.nextButton)
//        }
//    }
//
//    func openSecond() {
//        DispatchQueue.main.async {
//            self.firstSelectedTop = false
//            self.secondSelectedTop = true
//            self.thirdSelectedTop = false
//            self.nextButton.isEnabled = true
//            self.nextButton.setTitle("Next".localized, for: .normal)
//            self.handleNext(sender:self.nextButton)
//        }
//
//
//    }
//
//    func openThird() {
//        DispatchQueue.main.async {
//            self.firstSelectedTop = false
//            self.secondSelectedTop = false
//            self.thirdSelectedTop = true
//            self.nextButton.isEnabled = true
//            self.nextButton.setTitle(self.aqar != nil ?  "Update Post".localized : "Make Post".localized, for: .normal)
//            self.handleNext(sender:self.nextButton)
//            self.thirdSelectedTop = false
//        }
//    }
//
//
//
//}
//
//extension MainCreatePostVC:UIScrollViewDelegate {
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let x = scrollView.contentOffset.y
//        self.scrollView.isScrollEnabled = x < -60 ? false : true
//
//    }
//}
