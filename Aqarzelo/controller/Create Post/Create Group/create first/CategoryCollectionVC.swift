//
//  CategoryCollectionVC.swift
//  Aqarzelo
//
//  Created by Hossam on 9/29/20.
//  Copyright © 2020 Hossam. All rights reserved.
//

import UIKit

class CategoryCollectionVC: BaseCollectionVC {
    
    var categoryNames = [String]()
    var categoryIds = [Int]()
    fileprivate let cellTitleId = "cellTitleId"
    var handleChossenCategory:((Int)->())?

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryNames.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellTitleId, for: indexPath) as! CategoryCollectionCell
        cell.ids=categoryIds[indexPath.item]
        cell.name=categoryNames[indexPath.item]
        cell.index = indexPath.item
        cell.handleChossenCategory = {[unowned self ] ids,index in
            self.colorButton(index: index)
            self.handleChossenCategory?(ids)
        }
        return cell
    }
    
    
    func colorButton(index:Int)  {
        collectionView.visibleCells.forEach { (cell) in
            if let celll = cell as? CategoryCollectionCell{
            celll.landButton.setTitleColor(.black, for: .normal)
            celll.landButton.backgroundColor = .white
        }
        }
            if let cell = collectionView.cellForItem(at: IndexPath(item: index, section: 0) ) as? CategoryCollectionCell{
                cell.landButton.setTitleColor(.white, for: .normal)
                cell.landButton.backgroundColor = ColorConstant.mainBackgroundColor
            }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width-3*8) / 3
        return .init(width: width, height: 30)
    }
    
     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    
    
    override func setupCollection() {
        collectionView.backgroundColor = .white
        collectionView.register(CategoryCollectionCell.self, forCellWithReuseIdentifier: cellTitleId)
    }
    
    
    
}

class CategoryCollectionCell: BaseCollectionCell {
    
    override var isSelected: Bool {
        didSet {
             landButton.setTitleColor(isSelected ? ColorConstant.mainBackgroundColor : .black, for: .normal)
            landButton.backgroundColor =  isSelected ? .black : .white
        }
    }
    
    var name:String? {
        didSet{
            guard let name = name else { return  }
            landButton.setTitle(name, for: .normal)
        }
    }
    var ids:Int? {
        didSet{
            guard let ids = ids else { return  }
            landButton.tag = ids
        }
    }
    var index:Int? {
        
        didSet{
            guard let ids = index else { return  }
            
        }
    }
    
    var handleChossenCategory:((Int,Int)->())?
    
    lazy var landButton = createButtons(title: "   Land    ".localized,tag: 3 )

    
    override func setupViews() {
        backgroundColor = .clear
        stack(landButton)
    }
    
    func createButtons(title:String,tag:Int) -> UIButton {
        let b = UIButton(title: title, titleColor: .black, font: .systemFont(ofSize: 14), backgroundColor: .white, target: self, action: #selector(handleChoosedButton))
        b.layer.cornerRadius = 16
        b.clipsToBounds = true
        b.layer.borderWidth = 1
        b.layer.borderColor = #colorLiteral(red: 0.1809101701, green: 0.6703525782, blue: 0.6941398382, alpha: 1).cgColor
//        b.tag = tag
        return b
    }
    
   @objc func handleChoosedButton()  {
    guard let ids = ids,let index = index else { return  }
       handleChossenCategory?(ids,index)
    }
}
