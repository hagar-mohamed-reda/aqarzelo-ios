//
//  CreateFirstListCollectionVC.swift
//  Aqarzelo
//
//  Created by Hossam on 8/9/20.
//  Copyright © 2020 Hossam. All rights reserved.
//

import UIKit

class CreateFirstListCollectionVC:   UICollectionViewController, UICollectionViewDelegateFlowLayout  {
    
    fileprivate let cellTitleId = "cellTitleId"
    fileprivate let cellTitleARId = "cellTitleARId"
    fileprivate let cellCategoryId = "cellCategoryId"
    fileprivate let cellSallId = "cellSallId"
    fileprivate let cellSpaceId = "cellSpaceId"
    fileprivate let cellRoomsId = "cellRoomsId"
    fileprivate let cellBathsId = "cellBathsId"
    fileprivate let cellPricesId = "cellPricesId"
    fileprivate let cellTotalPricesId = "cellTotalPricesId"
    
    var aqar:AqarModel? {
        didSet{
            guard let aqar = aqar else { return  }
            firstCcreatePostVviewModel.bathsNum = aqar.bathroomNumber
            firstCcreatePostVviewModel.category = "\(aqar.categoryID)"
            firstCcreatePostVviewModel.roomNum = aqar.bedroomNumber
            firstCcreatePostVviewModel.pricePer = aqar.pricePerMeter
            firstCcreatePostVviewModel.totalPrice = "\(aqar.price)"
            firstCcreatePostVviewModel.space = "\(aqar.space)"
            firstCcreatePostVviewModel.title = aqar.title
            firstCcreatePostVviewModel.titleAR = aqar.titleAr
            firstCcreatePostVviewModel.sell = aqar.type
        }
    }
    
    
    
    var nextVC:Bool = false
    var handleNextVC:((Bool,String?,String?,Int?, String,Int?,Int?,Int?,Int?,Int?)->Void)?
    var firstCcreatePostVviewModel = FirstCcreatePostVviewModel() //view model
    
    
    
    var firstPostData = [String]()
    
    var isPostEditing:Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollections()
        setupFirstCcreatePostVviewModelObserver()
        statusBarBackgroundColor()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 9
    }
    
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.item == 0 {
            let  cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellTitleId, for: indexPath) as! FirstCreatePostCell
            cell.aqar = aqar
            cell.handleTextContents = {[unowned self] (tx,openNext) in
                //                self.titles = tx
                self.firstCcreatePostVviewModel.title = openNext ?  tx : String()
                self.enableFirstTitleCell(openNext,index: 1)
                //                self.checks1 = openNext
            }
            
            return cell
        }else  if indexPath.item == 1 {
            let  cell = collectionView.dequeueReusableCell(withReuseIdentifier:cellTitleARId, for: indexPath) as! FirstCreateTitleArPostCell
            cell.aqar = aqar
            cell.index = 1
            cell.handleHidePreviousCell = {[unowned self] (index) in
                self.handleHidedViews(index: 0)
                
            }
            cell.handleTextContents = {[unowned self] (tx,openNext) in
                //                self.titles = tx
                self.firstCcreatePostVviewModel.titleAR = openNext ?  tx : String()
                self.enableFirstCell(openNext,index: 1)
                //                self.checks1 = openNext
                
            }
            
            return cell
        }
        else if indexPath.item == 2 {
            let  cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellCategoryId, for: indexPath) as! FirstCreatePostCategoryCell
            cell.aqar = aqar
            cell.index = 1
            cell.handleHidePreviousCell = {[unowned self] (index) in
                self.handleHidedViews(index: index)
                
            }
            cell.handleTextContents = {[unowned self] (index,openNext) in
                //                self.category = index
                self.firstCcreatePostVviewModel.category = openNext ? String(index) : String()
                self.enableSecondCell(openNext, index: 3)
                //                self.checks2 = openNext
            }
            return cell
        }else if indexPath.item == 3 {
            let  cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellSallId, for: indexPath) as! FirstCreateSellOrRentCell
            cell.aqar = aqar
            cell.index = 2
            cell.handleHidePreviousCell = {[unowned self] (index) in
                self.handleHidedViews(index: index)
            }
            cell.handleTextContents = {[unowned self] (tx,openNext) in
                //                self.type = tx
                self.firstCcreatePostVviewModel.sell = openNext ?  tx : String()
                self.enableThirdCell(openNext, index: 4)
                //                self.checks3 = openNext
            }
            return cell
        }else if indexPath.item == 4 {
            let  cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellSpaceId, for: indexPath) as! FirstCreateSpaceCell
            cell.aqar = aqar
            cell.index = 3
            cell.handleHidePreviousCell = {[unowned self] (index) in
                self.handleHidedViews(index: index)
            }
            cell.handleTextContents = { [unowned self] (space,openNext) in
                //                self.spaceMeter = space
                self.firstCcreatePostVviewModel.space  = openNext ? String(space) : String()
                self.enableForthCell(openNext, index: 5)
                //                self.checks4 = openNext
            }
            
            return cell
        }else if indexPath.item == 5 {
            let  cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellRoomsId, for: indexPath) as! FirstCreateRoomsNumberCell
            cell.aqar = aqar
            cell.index = 4
            cell.handleHidePreviousCell = {[unowned self] (index) in
                self.handleHidedViews(index: index)
            }
            cell.handleTextContents = { [unowned self] (number,openNext) in
                //                self.roomNumber = number
                self.firstCcreatePostVviewModel.roomNum = openNext ? String(number) : String()
                self.enableFifthCell(openNext, index: 6)
                //                self.checks5 = openNext
            }
            return cell
        }else if indexPath.item == 6 {
            let  cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellBathsId, for: indexPath) as! FirstCreateBathsNumberCell
            cell.aqar = aqar
            cell.index = 5
            cell.handleHidePreviousCell = {[unowned self] (index) in
                self.handleHidedViews(index: index)
            }
            cell.handleTextContents = { [unowned self] (number,openNext) in
                //                self.bathNumber = number
                self.firstCcreatePostVviewModel.bathsNum = openNext ? String(number) : String()
                self.enableSixthCell(openNext, index: 7)
                //                self.checks6 = openNext
            }
            return cell
        }else if indexPath.item == 7 {
            let  cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellPricesId, for: indexPath) as! FirstCreatePriceCell
            cell.aqar = aqar
            cell.index = 6
            cell.handleHidePreviousCell = {[unowned self] (index) in
                self.handleHidedViews(index: index)
            }
            cell.handleTextContents = { [unowned self] (price,openNext) in
                //                self.priceMeter = price
                self.firstCcreatePostVviewModel.pricePer = openNext ? String(price) : String()
                self.enableSeventhCell(openNext, index: 8)
                //                self.checks7 = openNext
            }
            return cell
        }
        
        
        
        
        
        let  cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellTotalPricesId, for: indexPath) as! FirstCreateTotalPriceCell
        cell.aqar = aqar
        cell.index = 7
        cell.handleHidePreviousCell = {[unowned self] (index) in
            self.handleHidedViews(index: index)
        }
        cell.handleTextContents = { [unowned self] (price,openNext) in
            //            self.totalPrice = price
            self.firstCcreatePostVviewModel.totalPrice = openNext ? String(price) : String()
            
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height:CGFloat
        var firstHeight:CGFloat = 0.0
        if indexPath.item == 0 {
            if let cell = collectionView.cellForItem(at: IndexPath(item: 0, section: 0))  as? FirstCreatePostCell{
                
                firstHeight = cell.textView.text.estimateFrameForText(cell.textView.text).height
            }
        }
        
        height = indexPath.item == 7 ? 150 : indexPath.item == 2 ? 150 : indexPath.item == 8 ? 150 : indexPath.item == 0 || indexPath.item == 1 ? firstHeight+150 :  120
        
        return .init(width: view.frame.width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    
    //MARK:-User methods
    
    fileprivate func bindableFirstWithoutAqar() {
        firstCcreatePostVviewModel.bindableIsFormValidate.bind {  [unowned self ]  (isValid) in
            guard let isValid = isValid else {return}
            //            guard let t = self.titles,let ca = self.category, let ty = self.type , let space = self.spaceMeter, let room = self.roomNumber,let bath = self.bathNumber ,let price = self.priceMeter, let total = self.totalPrice else {return }
            
            guard let t = self.firstCcreatePostVviewModel.title,let ar=self.firstCcreatePostVviewModel.titleAR,let ca = self.firstCcreatePostVviewModel.category?.toInt(), let ty = self.firstCcreatePostVviewModel.sell , let space = self.firstCcreatePostVviewModel.space?.toInt(), let room = self.firstCcreatePostVviewModel.roomNum?.toInt(),let bath = self.firstCcreatePostVviewModel.bathsNum?.toInt() ,let price = self.firstCcreatePostVviewModel.pricePer?.toInt(), let total = self.firstCcreatePostVviewModel.totalPrice?.toInt() else {return }
            
            isValid ? self.handleNextVC?(isValid, t,ar,ca,ty ,space,room,bath,price,total) : self.handleNextVC?(isValid, t,ar,ca,ty ,space,room,bath,price,total)
            
        }
    }
    
    fileprivate func bindableFirstAqar(aqar:AqarModel) {
        firstCcreatePostVviewModel.bindableIsFormValidate.bind {  [unowned self ]  (isValid) in
            guard let isValid = isValid else {return}
            
            guard  let t = self.firstCcreatePostVviewModel.title,let ar = self.firstCcreatePostVviewModel.titleAR,let ca = self.firstCcreatePostVviewModel.category?.toInt(), let ty = self.firstCcreatePostVviewModel.sell
                , let space = self.firstCcreatePostVviewModel.space?.toInt(), let room = self.firstCcreatePostVviewModel.roomNum?.toInt(), let bath = self.firstCcreatePostVviewModel.bathsNum?.toInt(), let price = self.firstCcreatePostVviewModel.pricePer?.toInt(), let total = self.firstCcreatePostVviewModel.totalPrice?.toInt() else {return}
            
            
            isValid ? self.handleNextVC?(isValid, t,ar,ca,ty  ,space ,room ,bath ,price,total) : self.handleNextVC?(isValid, t,ar,ca,ty  ,space,room,bath,price,total)
            
        }
    }
    
    fileprivate func setupFirstCcreatePostVviewModelObserver()  {
        if let aqar = aqar {
            bindableFirstAqar(aqar: aqar)
        }else {
            bindableFirstWithoutAqar()
        }
    }
    
    
    fileprivate func enableThirdCell(_ openNext: Bool,index:Int) {
        if let cell = collectionView.cellForItem(at: IndexPath(item: index, section: 0)) as? FirstCreateSpaceCell  {
            cell.iconImageView.isUserInteractionEnabled = openNext
        }
    }
    
    fileprivate func enableFirstCell(_ openNext: Bool,index:Int) {
        if let cell = collectionView.cellForItem(at: IndexPath(item: index+1, section: 0)) as? FirstCreatePostCategoryCell  {
            cell.iconImageView.isUserInteractionEnabled = openNext
        }
    }
    
    fileprivate func enableFirstTitleCell(_ openNext: Bool,index:Int) {
        if let cell = collectionView.cellForItem(at: IndexPath(item: index, section: 0)) as? FirstCreateTitleArPostCell  {
            cell.iconImageView.isUserInteractionEnabled = openNext
        }
    }
    
    fileprivate func enableSecondCell(_ openNext: Bool,index:Int) {
        if let cell = collectionView.cellForItem(at: IndexPath(item: index, section: 0)) as? FirstCreateSellOrRentCell  {
            cell.iconImageView.isUserInteractionEnabled = openNext
        }
    }
    
    
    fileprivate func enableForthCell(_ openNext: Bool,index:Int) {
        if let cell = collectionView.cellForItem(at: IndexPath(item: index, section: 0)) as? FirstCreateRoomsNumberCell  {
            cell.iconImageView.isUserInteractionEnabled = openNext
        }
    }
    
    fileprivate func enableFifthCell(_ openNext: Bool,index:Int) {
        if let cell = collectionView.cellForItem(at: IndexPath(item: index, section: 0)) as? FirstCreateBathsNumberCell  {
            cell.iconImageView.isUserInteractionEnabled = openNext
        }
    }
    
    fileprivate func enableSixthCell(_ openNext: Bool,index:Int) {
        if let cell = collectionView.cellForItem(at: IndexPath(item: index, section: 0)) as? FirstCreatePriceCell  {
            cell.iconImageView.isUserInteractionEnabled = openNext
        }
    }
    
    fileprivate func enableSeventhCell(_ openNext: Bool,index:Int) {
        if let cell = collectionView.cellForItem(at: IndexPath(item: index, section: 0)) as? FirstCreateTotalPriceCell   {
            cell.iconImageView.isUserInteractionEnabled = openNext
        }
    }
    
    
    fileprivate  func handleHidedViews(index:Int)  {
        switch index {
        case 0:
            if let cell = collectionView.cellForItem(at: IndexPath(item: index, section: 0)) as? FirstCreatePostCell {
                cell.hideViewsAgain(views: cell.counttitleLabel,cell.mainView)
            }
        case 1:
            if let cell = collectionView.cellForItem(at: IndexPath(item: index, section: 0)) as? FirstCreateTitleArPostCell {
                cell.hideViewsAgain(views: cell.counttitleLabel,cell.mainView)
            }
            
        case 2:
            if let cell = collectionView.cellForItem(at: IndexPath(item: index, section: 0)) as? FirstCreatePostCategoryCell {
                cell.hideViewsAgain(views: cell.buttonStack,cell.categoryQuestionLabel)
            }
        case 3:
            if let cell = collectionView.cellForItem(at: IndexPath(item: index, section: 0)) as? FirstCreateSellOrRentCell {
                cell.hideViewsAgain(views: cell.buttonStack,cell.categoryQuestionLabel)
            }
        case 4:
            if let cell = collectionView.cellForItem(at: IndexPath(item: index, section: 0)) as? FirstCreateSpaceCell {
                cell.hideViewsAgain(views: cell.mainView,cell.priceLabel)
            }
        case 5:
            if let cell = collectionView.cellForItem(at: IndexPath(item: index, section: 0)) as? FirstCreateRoomsNumberCell {
                cell.hideViewsAgain(views: cell.customAddMinusView,cell.questionLabel)
            }
        case 6:
            if let cell = collectionView.cellForItem(at: IndexPath(item: index, section: 0)) as? FirstCreateBathsNumberCell {
                cell.hideViewsAgain(views: cell.customAddMinusView,cell.questionLabel)
            }
        case 7:
            if let cell = collectionView.cellForItem(at: IndexPath(item: index, section: 0)) as? FirstCreatePriceCell {
                cell.hideViewsAgain(views: cell.mainView,cell.priceLabel)
            }
        default:
            ()
        }
        
    }
    
    func setupCollections() {
        collectionView.backgroundColor = .white
        collectionView.contentInset.top = 8
        collectionView.register(FirstCreatePostCell.self, forCellWithReuseIdentifier: cellTitleId)
        collectionView.register(FirstCreateTitleArPostCell.self, forCellWithReuseIdentifier: cellTitleARId)
        collectionView.register(FirstCreatePostCategoryCell.self, forCellWithReuseIdentifier: cellCategoryId)
        collectionView.register(FirstCreateSellOrRentCell.self, forCellWithReuseIdentifier: cellSallId)
        collectionView.register(FirstCreateSpaceCell.self, forCellWithReuseIdentifier: cellSpaceId)
        collectionView.register(FirstCreateRoomsNumberCell.self, forCellWithReuseIdentifier: cellRoomsId)
        collectionView.register(FirstCreateBathsNumberCell.self, forCellWithReuseIdentifier: cellBathsId)
        collectionView.register(FirstCreatePriceCell.self, forCellWithReuseIdentifier: cellPricesId)
        collectionView.register(FirstCreateTotalPriceCell.self, forCellWithReuseIdentifier: cellTotalPricesId)
        
    }
    
    init() {
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
