//
//  CreateSecondListCollectionVC.swift
//  Aqarzelo
//
//  Created by Hossam on 8/9/20.
//  Copyright © 2020 Hossam. All rights reserved.
//

import UIKit

protocol CreateSecondListCollectionVCProtocol {
    func openMaps()
}

class CreateSecondListCollectionVC: UICollectionViewController,UICollectionViewDelegateFlowLayout {
    
    fileprivate let cellLocationId = "cellLocationId"
    fileprivate let cellCityId = "cellCityId"
    fileprivate let cellAreaId = "cellAreaId"
    fileprivate let cellAddressId = "cellAddressId"
    fileprivate let cellBildNumberId = "cellBildNumberId"
    fileprivate let cellBuildDateId = "cellBuildDateId"
    fileprivate let cellFloorNumberId = "cellFloorNumberId"
    
    var aqar:AqarModel? {
        didSet{
            guard let aqar = aqar else { return  }
            secondCcreatePostVviewModel.lat = aqar.lat
            secondCcreatePostVviewModel.area = "\(aqar.areaID)"
            secondCcreatePostVviewModel.lng = aqar.lng
            secondCcreatePostVviewModel.buildDate = aqar.buildDate
            secondCcreatePostVviewModel.city = "\(aqar.cityID)"
            secondCcreatePostVviewModel.fllorNum = aqar.floorNumber
            secondCcreatePostVviewModel.address = ""
        }
    }
    
    var nextVC:Bool = false
    var handleOpenMaps:(()->Void)?
    var delgate:CreateSecondListCollectionVCProtocol?
    var secondCcreatePostVviewModel = SecondCcreatePostVviewModel() //view model
//    var handleOpenDropDown:((CGRect)->Void)?
    
    var handleNextVC:((Bool,Double?,Double?,Int?, Int?,String?,String?,Int?)->Void)?
    //    var area_id,buildNum,floorNum:Int?
    //    var lat,long:Double?
    //    var buildDate,address:String?
    
    
    var cityId:Int? = 0
    
    var isPostEditing:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollections()
        setupSecondCcreatePostVviewModelObserver()
        statusBarBackgroundColor()
    }
    
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    lazy var containerView:UIView = {
        let v = UIView(backgroundColor: .white)
        
        return v
    }()
    
    fileprivate func presentView() {
        let choose = ChooseLocationSecondPostVC()
        containerView.addSubview(choose.view)
        
        self.view.addSubview(containerView)
        view.bringSubviewToFront(containerView)
        
        containerView.anchor(top: view.superview?.topAnchor, leading: view.leadingAnchor, bottom: view.superview?.bottomAnchor, trailing: view.trailingAnchor,padding: .init(top: -120, left: -16, bottom: 0, right: -16))
        choose.view.fillSuperview()
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.item == 0 {
            let  cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellLocationId, for: indexPath) as! SecondCreateLocationCell
            cell.aqar = aqar
            cell.handlerChooseLocation = {[unowned self] in
                self.delgate?.openMaps()
            }
            cell.handlerNext = {[unowned self] (lat,long,openNext) in
                //                self.lat = lat
                //                self.long = long
                self.secondCcreatePostVviewModel.lat = openNext ? String(lat) : String()
                self.secondCcreatePostVviewModel.lng = openNext ? String(long) : String()
                self.enableFirstCell(openNext, index: 1)
            }
            
            return cell
        } else if indexPath.item == 1 {
            let  cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellCityId, for: indexPath) as! SecondCreateCityCell
            cell.aqar = aqar
            cell.index = 1
            cell.handleHidePreviousCell = {[unowned self] (index) in
                
                self.handleHidedViews(index: index)
            }
            
            cell.handleTextContents = {[unowned self] (tx,openNext) in
                self.cityId = tx
                self.secondCcreatePostVviewModel.city = openNext ? String(tx ?? 1) : String()
                self.enableSecondCell(openNext, index: 2)
            }
//            cell.handleOpenDropDown = {[unowned self] frame in
//                self.handleOpenDropDown?(frame)
//            }
            return cell
        } else if indexPath.item == 2 {
            let  cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellAreaId, for: indexPath) as! SecondCreateAreaCell
            cell.aqar = aqar
            cell.index = 2
            cell.cityId = cityId
            cell.handleHidePreviousCell = {[unowned self] (index) in
                self.handleHidedViews(index: index)
            }
            
            cell.handleTextContents = {[unowned self] (tx,openNext) in
                //                self.area_id = tx
                self.secondCcreatePostVviewModel.area = openNext ? String(tx ?? 1) : String()
                self.enableThirdCell(openNext, index: 3)
            }
            return cell
        } else if indexPath.item == 3 {
            let  cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellAddressId, for: indexPath) as! SecondCreateAddressCell
            cell.aqar = aqar
            cell.index = 3
            cell.handleHidePreviousCell = {[unowned self] (index) in
                self.handleHidedViews(index: index)
            }
            
            cell.handleTextContents = {[unowned self] (tx,openNext) in
                //                self.address = tx
                self.secondCcreatePostVviewModel.address = openNext ? tx : String()
                self.enableForthCell(openNext, index: 4)
            }
            return cell
        }
        else if indexPath.item == 4 {
            let  cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellBuildDateId, for: indexPath) as! SecondCreateBuildDateCell
            cell.index = 4
            cell.aqar = aqar
            cell.handleHidePreviousCell = {[unowned self] (index) in
                self.handleHidedViews(index: index)
            }
            
            cell.handleTextContents = {[unowned self] (tx,openNext) in
                //                self.buildDate = tx
                self.secondCcreatePostVviewModel.buildDate = openNext ? tx : String()
                self.enableFifthCell(openNext, index: 5)
            }
            return cell
        }
        
        let  cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellFloorNumberId, for: indexPath) as! SecondCreateFloorNumberCell
        cell.index = 5
        cell.aqar = aqar
        cell.handleHidePreviousCell = {[unowned self] (index) in
            self.handleHidedViews(index: index)
        }
        //
        cell.handleTextContents = {[unowned self] (tx,openNext) in
            //            self.floorNum = tx
            self.secondCcreatePostVviewModel.fllorNum = openNext ? String(tx ) : String()
        }
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height:CGFloat
        var firstHeight:CGFloat = 0.0
        //        if indexPath.item == 4 || indexPath.item == 5 {
        //            height = 10
        //        }
        
        if indexPath.item == 3 {
            if let cell = collectionView.cellForItem(at: IndexPath(item: 3, section: 0))  as? SecondCreateAddressCell{
                
                firstHeight = cell.textView.text.estimateFrameForText(cell.textView.text).height
            }
        }
        height = indexPath.item == 3 ? 160  : indexPath.item == 3 ? firstHeight+150 : 150
        //        height = 100
        
        return .init(width: view.frame.width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    fileprivate func setupSecondCcreatePostVviewModelObserver ()  {
        secondCcreatePostVviewModel.bindableIsFormValidate.bind {  [unowned self ]  (isValid) in
            guard let isValid = isValid else {return}
            guard let l = self.secondCcreatePostVviewModel.lat?.toDouble(),let lg = self.secondCcreatePostVviewModel.lng?.toDouble(), let ct = self.secondCcreatePostVviewModel.city?.toInt() , let area = self.secondCcreatePostVviewModel.area?.toInt(), let add = self.secondCcreatePostVviewModel.address,let bd = self.secondCcreatePostVviewModel.buildDate, let f = self.secondCcreatePostVviewModel.fllorNum?.toInt() else {return }
            isValid ? self.handleNextVC?(isValid, l,lg,ct ,area,add,bd,f) : self.handleNextVC?(isValid, l,lg,ct ,area,add,bd,f)
        }
    }
    
    fileprivate func enableThirdCell(_ openNext: Bool,index:Int) {
        if let cell = collectionView.cellForItem(at: IndexPath(item: index, section: 0)) as? SecondCreateAddressCell  {
            cell.iconImageView.isUserInteractionEnabled = openNext
            
        }
    }
    
    fileprivate func enableFirstCell(_ openNext: Bool,index:Int) {
        if let cell = collectionView.cellForItem(at: IndexPath(item: index, section: 0)) as? SecondCreateCityCell  {
            cell.iconImageView.isUserInteractionEnabled = openNext
        }
    }
    
    fileprivate func enableSecondCell(_ openNext: Bool,index:Int) {
        if let cell = collectionView.cellForItem(at: IndexPath(item: index, section: 0)) as? SecondCreateAreaCell  {
            cell.iconImageView.isUserInteractionEnabled = openNext
            cell.cityId = cityId
        }
    }
    
    
    fileprivate func enableForthCell(_ openNext: Bool,index:Int) {
        if let cell = collectionView.cellForItem(at: IndexPath(item: index, section: 0)) as? SecondCreateBuildDateCell  {
            cell.iconImageView.isUserInteractionEnabled = openNext
        }
    }
    
    fileprivate func enableFifthCell(_ openNext: Bool,index:Int) {
        if let cell = collectionView.cellForItem(at: IndexPath(item: index, section: 0)) as? SecondCreateFloorNumberCell  {
            cell.iconImageView.isUserInteractionEnabled = openNext
        }
    }
    
    
    func handleHidedViews(index:Int)  {
        switch index {
            
        case 1:
            if let cell = collectionView.cellForItem(at: IndexPath(item: index-1, section: 0)) as? SecondCreateLocationCell {
                cell.hideViewsAgain(views: cell.mapButton,cell.categoryQuestionLabel)
            }
        case 2:
            if let cell = collectionView.cellForItem(at: IndexPath(item: index-1, section: 0)) as? SecondCreateCityCell {
                cell.hideViewsAgain(views: cell.categoryQuestionLabel,cell.mainDrop1View)
            }
            
        case 3:
            if let cell = collectionView.cellForItem(at: IndexPath(item: index-1, section: 0)) as? SecondCreateAreaCell {
                cell.hideViewsAgain(views: cell.categoryQuestionLabel,cell.mainDrop1View)
            }
        case 4:
            if let cell = collectionView.cellForItem(at: IndexPath(item: index-1, section: 0)) as? SecondCreateAddressCell {
                cell.hideViewsAgain(views: cell.counttitleLabel,cell.textView,cell.counttitleLabel,cell.categoryQuestionLabel)
            }        case 5:
                if let cell = collectionView.cellForItem(at: IndexPath(item: index-1, section: 0)) as? SecondCreateBuildDateCell {
                    cell.hideViewsAgain(views: cell.questionLabel,cell.dateTextField,cell.mainView)
            }
            
        case 6:
            if let cell = collectionView.cellForItem(at: IndexPath(item: index-1, section: 0)) as? SecondCreateFloorNumberCell {
                cell.hideViewsAgain(views: cell.customAddMinusView,cell.questionLabel)
            }
        default:
            ()
        }
        
    }
    
    //MARK:-User methods
    
    func setupCollections() {
        collectionView.backgroundColor = .white
        collectionView.contentInset.top = 8
        collectionView.register(SecondCreateLocationCell.self, forCellWithReuseIdentifier: cellLocationId)
        collectionView.register(SecondCreateCityCell.self, forCellWithReuseIdentifier: cellCityId)
        collectionView.register(SecondCreateAreaCell.self, forCellWithReuseIdentifier: cellAreaId)
        collectionView.register(SecondCreateAddressCell.self, forCellWithReuseIdentifier: cellAddressId)
        collectionView.register(SecondCreateBuildDateCell.self, forCellWithReuseIdentifier: cellBuildDateId)
        collectionView.register(SecondCreateFloorNumberCell.self, forCellWithReuseIdentifier: cellFloorNumberId)
        
        
    }
    
    init() {
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
 
    
}


extension CreateSecondListCollectionVC: ChooseLocationSecondPostVCProtocol {
    
    func getLatAndLong(lat: Double, long: Double) {
        if let cell = collectionView.cellForItem(at: IndexPath(item: 0, section: 0)) as? SecondCreateLocationCell {
            cell.mapButton.backgroundColor = ColorConstant.mainBackgroundColor
            cell.handlerNext?(lat,long,true)
        }
    }
    
    
    
}
