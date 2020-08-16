//
//  AqarDetailHorizentalVC.swift
//  Aqarzelo
//
//  Created by Hossam on 8/9/20.
//  Copyright © 2020 Hossam. All rights reserved.
//

import UIKit

class AqarDetailHorizentalVC:     UICollectionViewController, UICollectionViewDelegateFlowLayout{
    
    
    
    lazy var pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.translatesAutoresizingMaskIntoConstraints = false
        pc.currentPage = 0
        pc.numberOfPages = mainAqar.images.count
        pc.currentPageIndicatorTintColor = #colorLiteral(red: 0.1985675395, green: 0.6542165279, blue: 0.5319386125, alpha: 1)
        pc.pageIndicatorTintColor = #colorLiteral(red: 0.8274509804, green: 0.8274509804, blue: 0.8274509804, alpha: 1)
        pc.addTarget(self, action: #selector(pageControlSelectionAction(_:)), for: .touchUpInside)
        return pc
    }()
    
    fileprivate var timer = Timer()
    fileprivate let cellID = "cellID"
    var mainAqar:AqarModel!
    var handleRatesAction:((AqarModel)->Void)?
    var handleShowImages:(([ImageModel])->Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupCollections()
        setuptimer()
        statusBarBackgroundColor()
    }
    
    
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        collectionView.noDataFound(mainAqar.images.count, text: "No Data Added Yet".localized)
        
        return mainAqar.images.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! AqarDetailCell
        let image = mainAqar.images[indexPath.item]
        
        cell.aqar = mainAqar
        cell.rateButton.addTarget(self, action: #selector(handleRatePost), for: .touchUpInside)
        cell.img = image
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width, height: view.frame.height )
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let images = mainAqar.images
        handleShowImages?(images)
        
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let x = targetContentOffset.pointee.x
        
        pageControl.currentPage = Int(x / view.frame.width)
        
        
        
    }
    
    //MARK:-User methods
    
    
    
    fileprivate func setuptimer() {
        timer = Timer.scheduledTimer(timeInterval: 10, target: self , selector:
            #selector(startScrolling), userInfo: nil, repeats: true)
        
    }
    
    
    
    fileprivate func setupViews()  {
        view.addSubViews(views: pageControl)
        
        pageControl.anchor(top: nil, leading: nil, bottom: view.bottomAnchor, trailing: nil,padding: .init(top: 0, left: 0, bottom: 32, right: 0))
        pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    
    
    fileprivate  func setupCollections() {
        
        if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
        }
        collectionView.backgroundColor = .white
        collectionView.register(AqarDetailCell.self, forCellWithReuseIdentifier: cellID)
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator=false
    }
    
    //TODO:-Handle methods
    
    @objc func pageControlSelectionAction(_ sender: UIPageControl) {
        //move page to wanted page
        let page = sender.currentPage
        self.pageControl.currentPage = page
        collectionView.scrollToItem(at: IndexPath(row: pageControl.currentPage, section: 0), at: .right, animated: true)
        
        //        self.pageViewController?.setViewControllers([[orderedViewControllers[page!]]], direction: .forword, animated: true, completion: nil)
    }
    
    @objc  func handleRatePost()  {
        handleRatesAction?(mainAqar)
    }
    
    @objc func startScrolling() {
        
        if pageControl.currentPage == pageControl.numberOfPages - 1 {
            pageControl.currentPage = 0
        } else {
            pageControl.currentPage += 1
        }
        collectionView.scrollToItem(at: IndexPath(row: pageControl.currentPage, section: 0), at: .right, animated: true)
    }
    
    init() {
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
