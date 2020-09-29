//
//  CreateThirddListCollectionVC.swift
//  Aqarzelo
//
//  Created by Hossam on 8/9/20.
//  Copyright © 2020 Hossam. All rights reserved.
//

import UIKit


class CreateThirddListCollectionVC: BaseCollectionVC {
    
    fileprivate let cellDescribeId = "cellDescribeId"
    fileprivate let cellTypeId = "cellTypeId"
    fileprivate let cellPaymentId = "cellPaymentId"
    fileprivate let cellFinishedId = "cellFinishedId"
    fileprivate let cellMoreId = "cellMoreId"
    
    var is1CellIsOpen = false
    var is2CellIsOpen = false
    var is3CellIsOpen = false
    var is4CellIsOpen = false
    var is5CellIsOpen = false
    
    
    var is1CellIError = false
    var is2CellIsError = false
    var is3CellIsError = false
    var is4CellIsError = false
    var is5CellIsError = false
    
    var isFinsihedHidden = false
    
    
    var handleNextVC:((Bool,String?,String?,String?, String?,Int?)->Void)?
    var thirdCcreatePostVviewModel = ThirdCcreatePostVviewModel() //view model
    //    var moreSelected:Int?
    //    var discribe,ownerType,payment,finishedType:String?
    
    var aqar:AqarModel? {
        didSet{
            guard let aqar = aqar else { return  }
            thirdCcreatePostVviewModel.describe = aqar.datumDescription
            thirdCcreatePostVviewModel.ownerType = "\(aqar.ownerType)"
            thirdCcreatePostVviewModel.payment = aqar.paymentMethod
            thirdCcreatePostVviewModel.finshed = aqar.finishingType
            //            thirdCcreatePostVviewModel.city = "\(aqar.cityID)"
            //            thirdCcreatePostVviewModel.fllorNum = aqar.floorNumber
            //            thirdCcreatePostVviewModel.address = ""
        }
    }
    
    var nextVC:Bool = false
    
    var isPostEditing:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupThirdCcreatePostVviewModelObserver()
        statusBarBackgroundColor()
    }
    
    //MARK:-collectionView methods
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.item == 0 {
            let  cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellDescribeId, for: indexPath) as! ThirdCreateDescribeCell
            cell.index = 0
            cell.aqar = aqar
            cell.createThirddListCollectionVC=self
            cell.handleTextContents = { [unowned self] (details,openNext) in
                //                self.discribe = details
                self.thirdCcreatePostVviewModel.describe = openNext ? details : String()
                self.enableSecondsCell(openNext, index: 1  )
            }
            
            return cell
        } else if indexPath.item == 1 {
            let  cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellTypeId, for: indexPath) as! ThirdCreateOwnerTypeCell
            cell.index = 1
            cell.aqar = aqar
            cell.createThirddListCollectionVC=self
            cell.handleHidePreviousCell = {[unowned self] (index) in
                self.handleHidedViews(index: index)
            }
            
            cell.handleTextContents = {[unowned self] (tx,openNext) in
                //                self.ownerType = tx
                self.thirdCcreatePostVviewModel.ownerType = openNext ? tx : String()
                self.enableThirdsCell(openNext, index: 2)
            }
            return cell
        }  else if indexPath.item == 2 {
            let  cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellPaymentId, for: indexPath) as! ThirdCreatePaymentMethodCell
            cell.index = 2
            cell.aqar = aqar
            cell.createThirddListCollectionVC=self
            cell.handleHidePreviousCell = {[unowned self] (index) in
                self.handleHidedViews(index: index)
            }
            
            cell.handleTextContents = {[unowned self] (tx,openNext) in
                //                self.payment = tx
                self.thirdCcreatePostVviewModel.payment = openNext ? tx : String()
                self.enableForthsCell(openNext, index: 3)
            }
            return cell
        }else if indexPath.item == 3 {
            let  cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellFinishedId, for: indexPath) as! ThirdCreateFinishedMethodCell
            cell.index = 3
            cell.aqar = aqar
            cell.createThirddListCollectionVC=self
            cell.handleHidePreviousCell = {[unowned self] (index) in
                self.handleHidedViews(index: index)
            }
            cell.handleTextssContentsSecondChange = {[unowned self ] (index,openNext) in
                self.thirdCcreatePostVviewModel.finshed = openNext ? self.getNameAccordingToTag(tag: index) : String()
                self.enableFifthsCell(openNext, index: 4)
            }
            return cell
        }
        
        let  cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellMoreId, for: indexPath) as! ThirdCreateMoreCell
        cell.index = 4
        cell.aqar = aqar
        cell.createThirddListCollectionVC=self
        cell.handleHidePreviousCell = {[unowned self] (index) in
            self.handleHidedViews(index: 4)
        }
        
        cell.handleTextContents = { [unowned self] (tag,openNext) in
            print(tag)
            //            self.moreSelected = tag
            self.thirdCcreatePostVviewModel.more = openNext ? String(tag) : String()
        }
        return cell
    }
    
    func getNameAccordingToTag(tag:Int) -> String  {
        switch tag {
        case 1:
            return FinishedTypeEnum.semi_finished.rawValue
        case 2:
            return FinishedTypeEnum.lux.rawValue
        case 3:
            return FinishedTypeEnum.super_lux.rawValue
        case 4:
            return FinishedTypeEnum.extra_super_lux.rawValue
            
        default:
            return FinishedTypeEnum.without_finished.rawValue
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height:CGFloat
        var firstHeight:CGFloat = 0.0
        
        if indexPath.item == 0 {
            if let cell = collectionView.cellForItem(at: IndexPath(item: 0, section: 0))  as? ThirdCreateDescribeCell{
                
                firstHeight = cell.textView.text.estimateFrameForText(cell.textView.text).height
            }
        }
        
        switch indexPath.item {
        case 0:
            height = !is1CellIsOpen ? 80 : firstHeight+150+60
        case 1:
            height = !is2CellIsOpen ? 80 : 120
        case 2:
            height = !is3CellIsOpen ? 80 : 120
        case 3:
            height = isFinsihedHidden ? 0 : !is4CellIsOpen ? 80 : 300
        default:
            height = !is5CellIsOpen ? 80 : 120
        }
        
        //        height = indexPath.row == 0 ? firstHeight+150+60 : indexPath.item == 3 ? 300 :  120
        
        return .init(width: view.frame.width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    //MARK:-User methods
    
    fileprivate func setupThirdCcreatePostVviewModelObserver()  {
        thirdCcreatePostVviewModel.bindableIsFormValidate.bind {  [unowned self ]  (isValid) in
            guard let isValid = isValid else {return}
            guard let d = self.thirdCcreatePostVviewModel.describe, let ow = self.thirdCcreatePostVviewModel.ownerType, let pa = self.thirdCcreatePostVviewModel.payment, let fit = self.thirdCcreatePostVviewModel.finshed , let more = self.thirdCcreatePostVviewModel.more else {return}
            //        guard let d = self.discribe, let ow = self.ownerType, let pa = self.payment, let fit = self.finishedType , let more = self.moreSelected else {return}
            isValid ?   self.handleNextVC?(isValid,d,ow,pa,fit,Int(more)) : self.handleNextVC?(isValid,d,ow,pa,fit,Int(more))
            //        guard let l = self.lat,let lg = self.long, let ct = self.cityId , let area = self.area_id, let add = self.address,let bd = self.buildDate, let f = self.floorNum else {return }
            //        isValid ? self.handleNextVC?(isValid, l,lg,ct ,area,add,bd,f) : self.handleNextVC?(isValid, l,lg,ct ,area,add,bd,f)
        }
        
    }
    
    fileprivate func enableSecondsCell(_ openNext: Bool,index:Int) {
        if let cell = collectionView.cellForItem(at: IndexPath(item: index, section: 0)) as? ThirdCreateOwnerTypeCell  {
            //            cell.iconImageView.isUserInteractionEnabled = openNext
            self.is1CellIError=openNext
        }
    }
    
    fileprivate func enableForthsCell(_ openNext: Bool,index:Int) {
        if let cell = collectionView.cellForItem(at: IndexPath(item: index, section: 0)) as? ThirdCreateFinishedMethodCell  {
            //            cell.iconImageView.isUserInteractionEnabled = openNext
            self.is3CellIsError=openNext
        }
    }
    
    fileprivate func enableFifthsCell(_ openNext: Bool,index:Int) {
        if let cell = collectionView.cellForItem(at: IndexPath(item: index, section: 0)) as? ThirdCreateMoreCell  {
            //            cell.iconImageView.isUserInteractionEnabled = openNext
            self.is4CellIsError=openNext
        }
    }
    
    fileprivate func enableThirdsCell(_ openNext: Bool,index:Int) {
        if let cell = collectionView.cellForItem(at: IndexPath(item: index, section: 0)) as? ThirdCreatePaymentMethodCell  {
            //            cell.iconImageView.isUserInteractionEnabled = openNext
            self.is2CellIsError=openNext
        }
    }
    
    func increaseAndDereaseCellSize(current : inout Bool,previous:inout Bool)  {
        current=true
        previous=false
        self.collectionView.reloadData()
    }
    
    fileprivate func handleHidedViews(index:Int)  {
        switch index {
        case 1:
            if let cell = collectionView.cellForItem(at: IndexPath(item: index-1, section: 0)) as? ThirdCreateDescribeCell {
                cell.hideViewsAgain(views: cell.mainView,cell.counttitleLabel)
                increaseAndDereaseCellSize(current: &is2CellIsOpen, previous: &is1CellIsOpen)
            }
            
        case 2:
            if let cell = collectionView.cellForItem(at: IndexPath(item: index-1, section: 0)) as? ThirdCreateOwnerTypeCell {
                cell.hideViewsAgain(views: cell.categoryQuestionLabel,cell.buttonStack)
                increaseAndDereaseCellSize(current: &is3CellIsOpen, previous: &is2CellIsOpen)
            }
        case 3:
            if let cell = collectionView.cellForItem(at: IndexPath(item: index-1, section: 0)) as? ThirdCreatePaymentMethodCell {
                cell.hideViewsAgain(views: cell.categoryQuestionLabel,cell.buttonStack)
                increaseAndDereaseCellSize(current: &is4CellIsOpen, previous: &is3CellIsOpen)
            }
        case 4:
            if let cell = collectionView.cellForItem(at: IndexPath(item: index-1, section: 0)) as? ThirdCreateFinishedMethodCell {
                cell.hideViewsAgain(views: cell.totalFirstStackFinished,cell.categoryQuestionLabel,cell.totalStackFinished)
                increaseAndDereaseCellSize(current: &is5CellIsOpen, previous: &is4CellIsOpen)
            }
            
        default:
            ()
        }
        
    }
    
    override func setupCollection() {
        collectionView.showsVerticalScrollIndicator=false
        
        collectionView.backgroundColor = .white
        collectionView.contentInset.top = 8
        collectionView.register(ThirdCreateDescribeCell.self, forCellWithReuseIdentifier: cellDescribeId)
        collectionView.register(ThirdCreateOwnerTypeCell.self, forCellWithReuseIdentifier: cellTypeId)
        collectionView.register(ThirdCreatePaymentMethodCell.self, forCellWithReuseIdentifier: cellPaymentId)
        collectionView.register(ThirdCreateFinishedMethodCell.self, forCellWithReuseIdentifier: cellFinishedId)
        collectionView.register(ThirdCreateMoreCell.self, forCellWithReuseIdentifier: cellMoreId)
        
        
    }
    
}
