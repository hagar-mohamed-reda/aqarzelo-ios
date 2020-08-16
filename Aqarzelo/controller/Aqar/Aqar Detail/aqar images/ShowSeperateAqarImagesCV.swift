//
//  ShowSeperateAqarImagesCV.swift
//  Aqarzelo
//
//  Created by Hossam on 8/9/20.
//  Copyright © 2020 Hossam. All rights reserved.
//

import UIKit
import MOLH
//import CTPanoramaView

class ShowSeperateAqarImagesCV:   UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    fileprivate let cellID = "cellID"
    
    lazy var pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.translatesAutoresizingMaskIntoConstraints = false
        pc.currentPage = 0
        pc.numberOfPages = images.count
        pc.currentPageIndicatorTintColor = #colorLiteral(red: 0.1985675395, green: 0.6542165279, blue: 0.5319386125, alpha: 1)
        pc.pageIndicatorTintColor = #colorLiteral(red: 0.8274509804, green: 0.8274509804, blue: 0.8274509804, alpha: 1)
        pc.addTarget(self, action: #selector(handleNextPage), for: .touchUpInside)
        return pc
    }()
    
    fileprivate let images:[ImageModel]!
    init(images:[ImageModel]) {
        self.images = images
        //       super.init()
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupCollections()
        setupNavigations()
        statusBarBackgroundColor()
        //        setuptimer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHide(true)
        navigationController?.navigationBar.isHide(false)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        collectionView.noDataFound(images.count, text: "No Data Added Yet".localized)
        
        return images.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! ShowSeperateAqarCell
        let image = images[indexPath.item]
        cell.img = image
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width, height: view.frame.height )
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    //MARK:-User methods
    
    
    
    fileprivate func setupViews()  {
        view.addSubViews(views: pageControl)
        
        pageControl.anchor(top: nil, leading: nil, bottom: view.bottomAnchor, trailing: nil,padding: .init(top: 0, left: 0, bottom: 32, right: 0))
        pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let x = targetContentOffset.pointee.x
        
        pageControl.currentPage = Int(x / view.frame.width)
        
        
        
    }
    
    func setupCollections() {
        
        if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
        }
        collectionView.backgroundColor = .white
        collectionView.register(ShowSeperateAqarCell.self, forCellWithReuseIdentifier: cellID)
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator=false
        
    }
    
    func setupNavigations() {
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        
        let img:UIImage = (MOLHLanguage.isRTLLanguage() ?  UIImage(named:"back button-2") : #imageLiteral(resourceName: "back button-2")) ?? #imageLiteral(resourceName: "back button-2")
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: img.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleBack))
        //        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "back button-2").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleBack))
    }
    
    //TODO:-Handle methods
    
    @objc fileprivate  func handleBack()  {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func startScrolling() {
        
        if pageControl.currentPage == pageControl.numberOfPages - 1 {
            pageControl.currentPage = 0
        } else {
            pageControl.currentPage += 1
        }
        collectionView.scrollToItem(at: IndexPath(row: pageControl.currentPage, section: 0), at: .right, animated: true)
    }
    
    @objc func handleNextPage(sender:UIPageControl)  {
        
        let page: Int? = sender.currentPage
        var frame: CGRect = self.collectionView.frame
        frame.origin.x = frame.size.width * CGFloat(page ?? 0)
        frame.origin.y = 0
        self.collectionView.scrollRectToVisible(frame, animated: true)
        //    let nextIndex = min(pageControl.currentPage + 1, images.count - 1)
        //
        //
        //    let indexPath = IndexPath(item: nextIndex, section: 0)
        //    pageControl.currentPage = nextIndex
        //    collectionView?.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    
    //    init() {
    //        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    //    }
    
    //    init() {
    //        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    //    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
