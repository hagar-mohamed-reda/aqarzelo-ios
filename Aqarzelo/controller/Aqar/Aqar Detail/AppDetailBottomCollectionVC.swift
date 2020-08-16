//
//  AppDetailBottomCollectionVC.swift
//  Aqarzelo
//
//  Created by Hossam on 8/9/20.
//  Copyright © 2020 Hossam. All rights reserved.
//

import UIKit
import SVProgressHUD
import MOLH

class AppDetailBottomCollectionVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    //    lazy var customHighlightedCollectionView:CustomHighlightedCollectionView = {
    //        let v = CustomHighlightedCollectionView()
    //        v.constrainHeight(constant: 220)
    //        return v
    //    }()
    
    fileprivate let cellDiscriptionId = "cellDiscriptionId"
    fileprivate let cellInfoId = "cellInfoId"
    fileprivate let cellId = "cellId"
    fileprivate let cellAvgId = "cellAvgId"
    fileprivate let cellMapId = "cellMapId"
    fileprivate let cellchartsId = "cellchartsId"
    fileprivate let cellRecommendId = "cellRecommendId"
    fileprivate let cellHeaderId = "cellHeaderId"
    let titleNamesArray = ["","Description".localized,"","Related posts".localized,"Analysis".localized,"Avg Prices".localized]
    
    var handleShowHoghlightedView:((Bool)->Void)?
    
    fileprivate let aqarsArray:[AqarModel]!
    fileprivate let aqarModel:AqarModel!
    init(aqar:AqarModel,aqars:[AqarModel]) {
        self.aqarModel = aqar
        self.aqarsArray = aqars
        //        super.init()
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    var hideCollection = true
    var handleSelectedAqar:((AqarModel)->Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollections()
        statusBarBackgroundColor()
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return  6
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return section == 5 ? aqarModel.chartData.x.count : 1
    }
    
    
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellInfoId, for: indexPath) as! AqarDetailInfoCell
            cell.aqarDetailInfoView.aqar = aqarModel
            return cell
        } else if indexPath.section == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellDiscriptionId, for: indexPath) as! AqarDetailDiscriptionCell
            cell.aqar = aqarModel
            return cell
        } else if indexPath.section == 2 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellMapId, for: indexPath) as! AqarDetailMapCell
            cell.aqar = aqarModel
            return cell
        }    else if indexPath.section == 3 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellRecommendId, for: indexPath) as! AppDetailReccomendCell
            //            cell.isHidden = aqarsArray.count <= 0 ? true : false
            cell.appDetailRecommendHorizentalVC.collectionView.showsHorizontalScrollIndicator = false
            cell.appDetailRecommendHorizentalVC.aqarsArray = aqarsArray
            cell.appDetailRecommendHorizentalVC.collectionView.reloadData()
            cell.appDetailRecommendHorizentalVC.handleSelectedAqar = {[unowned self ] aqar in
                self.handleSelectedAqar?(aqar)
            }
            return cell
        } else if indexPath.section == 4 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellchartsId, for: indexPath) as! AqarDetailChartsCell
            cell.postId = aqarModel.id
            return cell
        } else if indexPath.section == 5 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellAvgId, for: indexPath) as! AqarDetailAveragePriceCell
            let xString = aqarModel.chartData.x[indexPath.item]
            let zValue = aqarModel.chartData.y[indexPath.item]
            
            cell.chart = xString
            cell.chartValue = zValue
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
        
        cell.backgroundColor = .red
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.section == 2 {
            hideCollection = !hideCollection
        }
    }
    
    
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    
        let phone = userDefaults.bool(forKey: UserDefaultsConstants.isUserLogined) ? aqarModel.phone : starifyNumber(number: aqarModel.phone)
        
        
        let title = titleNamesArray[indexPath.section]
        
        let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: cellHeaderId, for: indexPath) as! AqarDetailHeaderCell
        sectionHeader.index = indexPath.section
        sectionHeader.aqar = aqarModel
        sectionHeader.titleLabel.isHidden = indexPath.section == 0 ? true : false
        sectionHeader.sendButton.isHidden = indexPath.section == 2 ? false : true
        sectionHeader.titleLabel.text = indexPath.section == 2 ? phone  : title
        sectionHeader.titleLabel.textAlignment = MOLHLanguage.isRTLLanguage() ? .right : .left
        sectionHeader.handleMakeContactUser = { [unowned self] contact in
            self.dialNumber(number: contact)
        }
        return sectionHeader
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .init(width: view.frame.width, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height:CGFloat
        
        let hh = aqarModel.datumDescription?.getFrameForText(text: aqarModel.datumDescription ?? "")
        
        height = indexPath.section == 0 ? 150 : indexPath.section == 1 ? hh?.height ?? 1: indexPath.section == 2 ? 150 :  indexPath.section == 5 ? 40 : 150
        let width = indexPath.section == 5 ? view.frame.width - 16 : view.frame.width
        
        return .init(width:width , height: height)
    }
    
    //MARK:-User methods
    
    func starifyNumber(number: String) -> String {
        let intLetters = number.prefix(3)
        let endLetters = number.suffix(2)
        let numberOfStars = number.count - (intLetters.count + endLetters.count)
        var starString = ""
        for _ in 1...numberOfStars {
            starString += "*"
        }
        let finalNumberToShow: String = intLetters + starString + endLetters
        return finalNumberToShow
    }
    
    fileprivate func dialNumber(number : String) {
        
        if let url = URL(string: "tel://\(number)"),
            UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:], completionHandler:nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        } else {
            SVProgressHUD.showError(withStatus: "Unavaible".localized)
        }
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if aqarsArray.isEmpty {
            handleShowHoghlightedView?(true);return
        }
        
        
        if (100...200).contains(scrollView.contentOffset.y){
            handleShowHoghlightedView?(false)
        }else if (201...300).contains(scrollView.contentOffset.y){
            handleShowHoghlightedView?(true)
        }else if (301...400).contains(scrollView.contentOffset.y){
            handleShowHoghlightedView?(false)
        }else if (401...500).contains(scrollView.contentOffset.y){
            handleShowHoghlightedView?(true)
        }else if (501...600).contains(scrollView.contentOffset.y){
            handleShowHoghlightedView?(false)
        }else if (601...700).contains(scrollView.contentOffset.y){
            handleShowHoghlightedView?(true)
        }else {
            handleShowHoghlightedView?(true)
        }
        
    }
    
    func setupCollections() {
        collectionView.backgroundColor = #colorLiteral(red: 0.9523469806, green: 0.9524837136, blue: 0.9523171782, alpha: 1)
        collectionView.contentInset = .init(top: -16, left: 0, bottom: 0, right: 0)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.register(AqarDetailAveragePriceCell.self, forCellWithReuseIdentifier: cellAvgId)
        collectionView.register(AppDetailReccomendCell.self, forCellWithReuseIdentifier: cellRecommendId)
        collectionView.register(AqarDetailDiscriptionCell.self, forCellWithReuseIdentifier: cellDiscriptionId)
        collectionView.register(AqarDetailInfoCell.self, forCellWithReuseIdentifier: cellInfoId)
        collectionView.register(AqarDetailMapCell.self, forCellWithReuseIdentifier: cellMapId)
        collectionView.register(AqarDetailChartsCell.self, forCellWithReuseIdentifier:cellchartsId )
        
        collectionView.register(AqarDetailHeaderCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: cellHeaderId)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
