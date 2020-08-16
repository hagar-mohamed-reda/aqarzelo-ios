//
//  CustomEmptyNotifyOrFavoriteView.swift
//  Aqarzelo
//
//  Created by Hossam on 8/9/20.
//  Copyright © 2020 Hossam. All rights reserved.
//


import UIKit
import Lottie

class CustomEmptyNotifyOrFavoriteView: CustomBaseView {
    
    
    lazy var problemsView:AnimationView = {
        let i = AnimationView()
        return i
    }()
    
   
    func setupAnimation(name:String)  {
        problemsView.animation = Animation.named(name)
        problemsView.play()
        problemsView.loopMode = .loop
    }
    
    override func setupViews() {
    addSubview(problemsView)
        problemsView.fillSuperview()
    }
}
