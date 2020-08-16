//
//  CustomEmptyNoDataView.swift
//  Aqarzelo
//
//  Created by Hossam on 8/9/20.
//  Copyright © 2020 Hossam. All rights reserved.
//

import Lottie

class CustomEmptyNoDataView: CustomBaseView {


lazy var problemsView:AnimationView = {
      let i = AnimationView()
      i.contentMode = .scaleAspectFit
      return i
  }()

    func setupAnimation(name:String)  {
          problemsView.animation = Animation.named(name)
          problemsView.play()
          problemsView.loopMode = .loop
      }
      
    
    override func setupViews() {
        addSubview(problemsView)
        problemsView.centerInSuperview(size: .init(width: frame.width, height: 150))
}
}
