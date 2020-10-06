//
//  CreateSecondListCollectionVC.swift
//  Aqarzelo
//
//  Created by Hossam on 8/9/20.
//  Copyright © 2020 Hossam. All rights reserved.
//

import UIKit
import MOLH

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
    
    var is1CellIsOpen = false
    var is2CellIsOpen = false
    var is3CellIsOpen = false
    var is4CellIsOpen = false
    var is5CellIsOpen = false
    var is6CellIsOpen = false
    var is7CellIsOpen = false
    
    var is1CellIError = false
    var is2CellIsError = false
    var is3CellIsError = false
    var is4CellIsError = false
    var is5CellIsError = false
    var is6CellIsError = false
    var is7CellIsError = false
    
    var aqar:AqarModel? {
        didSet{
            guard let aqar = aqar else { return  }
            
            secondCcreatePostVviewModel.lat = aqar.lat
            secondCcreatePostVviewModel.area = "\(aqar.areaID)"
            secondCcreatePostVviewModel.lng = aqar.lng
            secondCcreatePostVviewModel.buildDate = aqar.buildDate
            secondCcreatePostVviewModel.city = "\(aqar.cityID)"
            secondCcreatePostVviewModel.fllorNum = aqar.floorNumber
            secondCcreatePostVviewModel.address = aqar.address ?? ""
            
            //            let city = getCityFromIndex(cc)
            //                       let area = getAreassFromIndex( aa)
            //                       areaDrop.text = area
            //                       areaDrop.selectedIndex = cc-1
            //                       cityDrop.selectedIndex = aa-1
            //                       cityDrop.text = city
            
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
    
    var category_id:Int?  {
        didSet{
            guard let category_id = category_id else { return  }
            let ss = category_id == 4 || category_id == 2 || category_id == 6 || category_id == 7 ? true : false
            let ff = category_id == 4  ? true : false

            isFloorNumberHiddern = ss
            isYearOfBuilidingHiddern=ff
        }
    }
    
    var cityId:Int? {
        didSet {
            guard let cityId = cityId else { return  }
            getAreaLists(index: cityId)
//             self.getAreasUsingAPI(index:cityId)
        }
    }
    var isFloorNumberHiddern = false
    var isYearOfBuilidingHiddern = false

    var finalFilteredAreaNames = [String]()
    var allAreasSelectedArray = [Int]()
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
            cell.createSecondListCollectionVC=self
            cell.handlerChooseLocation = {[unowned self] in
                self.delgate?.openMaps()
            }
            cell.handlerNext = {[unowned self] (lat,long,openNext) in
                //                self.lat = lat
                //                self.long = long
                self.secondCcreatePostVviewModel.lat = openNext ? String(lat) : String()
                self.secondCcreatePostVviewModel.lng = openNext ? String(long) : String()
                self.enableFirstttCell(openNext, index: 1)
            }
            
            return cell
        }else if indexPath.item == 1 {
            let  cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellAddressId, for: indexPath) as! SecondCreateCountryCell
            cell.aqar = aqar
            cell.createSecondListCollectionVC=self
            cell.index = 1
            cell.handleHidePreviousCell = {[unowned self] (index) in
                
                self.handleHidedViews(index: 1)
            }
            
            cell.handleTextContents = {[unowned self] (tx,openNext) in
                self.cityId = tx
                self.secondCcreatePostVviewModel.city = openNext ? String(tx ?? 1) : String()
                self.enableFirstCell(openNext, index: 2)
            }
            return cell
        } else if indexPath.item == 2 {
            let  cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellCityId, for: indexPath) as! SecondCreateCityCell
            cell.aqar = aqar
            cell.createSecondListCollectionVC=self
            cell.index = 1
            cell.handleHidePreviousCell = {[unowned self] (index) in
                
                self.handleHidedViews(index: 2)
            }
            
            cell.handleTextContents = {[unowned self] (tx,openNext) in
                self.cityId = tx
                self.secondCcreatePostVviewModel.city = openNext ? String(tx ?? 1) : String()
                self.enableSecondCell(openNext, index: 3)
            }
            return cell
        } else if indexPath.item == 3 {
            let  cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellAreaId, for: indexPath) as! SecondCreateAreaCell
            cell.aqar = aqar
            cell.createSecondListCollectionVC=self
            cell.index = 2
            cell.categroy_id=category_id
            cell.finalFilteredAreaNames=finalFilteredAreaNames
            cell.allAreasSelectedArray=allAreasSelectedArray
//            cell.cityId = cityId
            cell.handleHidePreviousCell = {[unowned self] (index) in
                self.handleHidedViews(index: index+1)
            }
            
            cell.handleTextContents = {[unowned self] (tx,openNext) in
                //                self.area_id = tx
                self.secondCcreatePostVviewModel.area = openNext ? String(tx ?? 1) : String()
//                self.enableThirdCell(openNext, index: 3)
                self.secondCcreatePostVviewModel.address = String()
                self.enableForthCell(openNext, index: 4)
                self.hideCells(self.category_id ?? 0)
            }
            return cell
        }
//        else if indexPath.item == 3 {
//            let  cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellAddressId, for: indexPath) as! SecondCreateAddressCell
//            cell.aqar = aqar
//            cell.categroy_id=category_id
//            cell.createSecondListCollectionVC=self
//            cell.index = 3
//            cell.handleHidePreviousCell = {[unowned self] (index) in
//                self.handleHidedViews(index: index)
//            }
//
//            cell.handleTextContents = {[unowned self] (tx,openNext) in
//                //                self.address = tx
//                self.secondCcreatePostVviewModel.address = openNext ? tx : String()
//                self.enableForthCell(openNext, index: 4)
//
//                self.hideCells(self.category_id ?? 0)
//            }
//            return cell
//        }
        else if indexPath.item == 4 {
            let  cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellBuildDateId, for: indexPath) as! SecondCreateBuildDateCell
            cell.categroy_id=category_id
            cell.index = 4
            cell.createSecondListCollectionVC=self
            cell.aqar = aqar
            cell.handleHidePreviousCell = {[unowned self] (index) in
                self.handleHidedViews(index: 4) //index
            }
            
            cell.handleTextContents = {[unowned self] (tx,openNext) in
                //                self.buildDate = tx
                self.secondCcreatePostVviewModel.buildDate = openNext ? tx : String()
                self.enableFifthCell(openNext, index: 5)
                self.hideLastCells(self.category_id ?? 0)
            }
            return cell
        }
        
        let  cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellFloorNumberId, for: indexPath) as! SecondCreateFloorNumberCell
        cell.index = 5
        cell.createSecondListCollectionVC=self
        cell.aqar = aqar
        cell.handleHidePreviousCell = {[unowned self] (index) in
            self.handleHidedViews(index: 5)
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
        
//        if indexPath.item == 3 {
//            if let cell = collectionView.cellForItem(at: IndexPath(item: 3, section: 0))  as? SecondCreateAddressCell{
//
//                firstHeight = cell.textView.text.estimateFrameForText(cell.textView.text).height
//            }
//        }
        
        switch indexPath.item {
        case 0:
            height = !is1CellIsOpen ? 80 : 150
        case 1:
            height = !is2CellIsOpen ? 80 : 150
        case 2:
            height = !is3CellIsOpen ? 80 : 150
        case 3:
            height =  !is4CellIsOpen ? 80 : 150
        case 4:
            height = isYearOfBuilidingHiddern ? 0 :  !is5CellIsOpen ? 80 : 150
            
        default:
            height = isFloorNumberHiddern ? 0 :  !is6CellIsOpen ? 80 : 150
        }
        
        //        height = indexPath.item == 3 ? 160  : indexPath.item == 3 ? firstHeight+150 : 150
        //        height = 100
        
        return .init(width: view.frame.width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
    func increaseAndDereaseCellSize(current : inout Bool,previous:inout Bool)  {
        current=true
        previous=false
        self.collectionView.reloadData()
    }
    
    func hideCells(_ id:Int)  {
        let x = id == 4 || id == 2 ||  id == 6 || id == 7 ? "0" : nil
        
        secondCcreatePostVviewModel.buildDate = id == 4 ? "0" : nil
        secondCcreatePostVviewModel.fllorNum = x
        collectionView.reloadData()
    }
    
    func hideLastCells(_ id:Int)  {
        let x =  id == 2 ||  id == 6 || id == 7 ? "0" : nil
        
        secondCcreatePostVviewModel.fllorNum = x
        collectionView.reloadData()
    }
    
    fileprivate func getAreaLists(index:Int) {
        
        let ss = cacheAreaInCodabe.storedValue
        let ff = ss??.filter({$0.cityID == index})
        let indexs = ff?.map{  $0.id}
        
        let names = MOLHLanguage.isRTLLanguage() ?  ff?.map{  $0.nameAr} : ff?.map{  $0.nameEn}
        self.finalFilteredAreaNames=names ?? []
        self.allAreasSelectedArray=indexs ?? []
        
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    func getAreasUsingAPI(index:Int )  {
           
           FilterServices.shared.getAreaAccordingToCity(id: index) { (base, err) in
               self.putThese(base)
              
           }
       }
       
       func putThese(_ d:BaseAqarAreaModel?)  {
           guard let ss =  d?.data  else {return}
           let dd = ss.map({MOLHLanguage.isRTLLanguage() ?  $0.nameAr : $0.nameEn}); let aa = ss.map({$0.id})
           finalFilteredAreaNames.removeAll()
           allAreasSelectedArray.removeAll()
           
           allAreasSelectedArray = aa
                      finalFilteredAreaNames =  dd
        
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
       }
    
    
    fileprivate func setupSecondCcreatePostVviewModelObserver ()  {
        secondCcreatePostVviewModel.bindableIsFormValidate.bind {  [unowned self ]  (isValid) in
            guard let isValid = isValid else {return}
            guard let l = self.secondCcreatePostVviewModel.lat?.toDouble(),let lg = self.secondCcreatePostVviewModel.lng?.toDouble(), let ct = self.secondCcreatePostVviewModel.city?.toInt() , let area = self.secondCcreatePostVviewModel.area?.toInt(), let add = self.secondCcreatePostVviewModel.address,let bd = self.secondCcreatePostVviewModel.buildDate, let f = self.secondCcreatePostVviewModel.fllorNum?.toInt() else {return }
            isValid ? self.handleNextVC?(isValid, l,lg,ct ,area,add,bd,f) : self.handleNextVC?(isValid, l,lg,ct ,area,add,bd,f)
        }
    }
    
//    fileprivate func enableThirdCell(_ openNext: Bool,index:Int) {
//        if let cell = collectionView.cellForItem(at: IndexPath(item: index, section: 0)) as? SecondCreateAddressCell  {
//            //            cell.iconImageView.isUserInteractionEnabled = openNext
//            self.is3CellIsError=openNext
//        }
//    }
    
    fileprivate func enableFirstttCell(_ openNext: Bool,index:Int) {
        if let cell = collectionView.cellForItem(at: IndexPath(item: index, section: 0)) as? SecondCreateCountryCell  {
            //            cell.iconImageView.isUserInteractionEnabled = openNext
            self.is1CellIError=openNext
        }
    }
    
    fileprivate func enableFirstCell(_ openNext: Bool,index:Int) {
        if let cell = collectionView.cellForItem(at: IndexPath(item: index, section: 0)) as? SecondCreateCityCell  {
            //            cell.iconImageView.isUserInteractionEnabled = openNext
            self.is2CellIsError=openNext
        }
    }
    
    fileprivate func enableSecondCell(_ openNext: Bool,index:Int) {
        if let cell = collectionView.cellForItem(at: IndexPath(item: index, section: 0)) as? SecondCreateAreaCell  {
            //            cell.iconImageView.isUserInteractionEnabled = openNext
            self.is3CellIsError=openNext
//            cell.cityId = cityId
        }
    }
    
    
    fileprivate func enableForthCell(_ openNext: Bool,index:Int) {
        if let cell = collectionView.cellForItem(at: IndexPath(item: index, section: 0)) as? SecondCreateBuildDateCell  {
            //            cell.iconImageView.isUserInteractionEnabled = openNext
            self.is4CellIsError=openNext
        }
    }
    
    fileprivate func enableFifthCell(_ openNext: Bool,index:Int) {
        if let cell = collectionView.cellForItem(at: IndexPath(item: index, section: 0)) as? SecondCreateFloorNumberCell  {
            //            cell.iconImageView.isUserInteractionEnabled = openNext
            is5CellIsError=openNext
        }
    }
    
    
    func handleHidedViews(index:Int)  {
        switch index {
            
        case 1:
            if let cell = collectionView.cellForItem(at: IndexPath(item: index-1, section: 0)) as? SecondCreateLocationCell {
                cell.hideViewsAgain(views: cell.mapButton,cell.categoryQuestionLabel)
                increaseAndDereaseCellSize(current: &is2CellIsOpen, previous: &is1CellIsOpen)
            }
        case 2:
            if let cell = collectionView.cellForItem(at: IndexPath(item: index-1, section: 0)) as? SecondCreateCountryCell {
                cell.hideViewsAgain(views: cell.categoryQuestionLabel,cell.mainDrop1View)
                increaseAndDereaseCellSize(current: &is3CellIsOpen, previous: &is2CellIsOpen)
            }
        case 3:
            if let cell = collectionView.cellForItem(at: IndexPath(item: index-1, section: 0)) as? SecondCreateCityCell {
                cell.hideViewsAgain(views: cell.categoryQuestionLabel,cell.mainDrop1View)
                increaseAndDereaseCellSize(current: &is4CellIsOpen, previous: &is3CellIsOpen)
            }
            
        case 4:
            if isYearOfBuilidingHiddern {
                if let cell = collectionView.cellForItem(at: IndexPath(item: index-1, section: 0)) as? SecondCreateAreaCell {
                    cell.hideViewsAgain(views: cell.categoryQuestionLabel,cell.mainDrop1View)
                    increaseAndDereaseCellSize(current: &is6CellIsOpen, previous: &is5CellIsOpen)
                }}else {
                
            if let cell = collectionView.cellForItem(at: IndexPath(item: index-1, section: 0)) as? SecondCreateAreaCell {
                cell.hideViewsAgain(views: cell.categoryQuestionLabel,cell.mainDrop1View)
//                increaseAndDereaseCellSize(current: &is4CellIsOpen, previous: &is3CellIsOpen)
//                increaseAndDereaseCellSize(current: &is5CellIsOpen, previous: &is4CellIsOpen)
                
                increaseAndDereaseCellSize(current: &is5CellIsOpen, previous: &is4CellIsOpen)
//                increaseAndDereaseCellSize(current: &is6CellIsOpen, previous: &is5CellIsOpen)
            }}
//        case 4:
//            if isYearOfBuilidingHiddern {
//                if let cell = collectionView.cellForItem(at: IndexPath(item: 3, section: 0)) as? SecondCreateAddressCell {
//                    cell.hideViewsAgain(views: cell.counttitleLabel,cell.textView,cell.counttitleLabel,cell.categoryQuestionLabel)
//                increaseAndDereaseCellSize(current: &is6CellIsOpen, previous: &is5CellIsOpen)
//                }
//            }else {
//            if let cell = collectionView.cellForItem(at: IndexPath(item: index-1, section: 0)) as? SecondCreateAddressCell {
//                cell.hideViewsAgain(views: cell.counttitleLabel,cell.textView,cell.counttitleLabel,cell.categoryQuestionLabel)
//                increaseAndDereaseCellSize(current: &is5CellIsOpen, previous: &is4CellIsOpen)
//            } }
        case 5:
            
                if let cell = collectionView.cellForItem(at: IndexPath(item: index-1, section: 0)) as? SecondCreateBuildDateCell {
                    cell.hideViewsAgain(views: cell.questionLabel,cell.dateTextField,cell.mainView)
                    increaseAndDereaseCellSize(current: &is6CellIsOpen, previous: &is5CellIsOpen)
            }
            
        case 6:
            if let cell = collectionView.cellForItem(at: IndexPath(item: index-1, section: 0)) as? SecondCreateFloorNumberCell {
                cell.hideViewsAgain(views: cell.customAddMinusView,cell.questionLabel)
                increaseAndDereaseCellSize(current: &is7CellIsOpen, previous: &is6CellIsOpen)
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
        collectionView.register(SecondCreateCountryCell.self, forCellWithReuseIdentifier: cellAddressId)
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
