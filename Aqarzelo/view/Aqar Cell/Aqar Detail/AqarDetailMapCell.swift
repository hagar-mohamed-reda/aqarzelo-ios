//
//  AqarDetailMapCell.swift
//  Aqarzelo
//
//  Created by Hossam on 8/8/20.
//  Copyright © 2020 Hossam. All rights reserved.
//


import UIKit
import GoogleMaps

class AqarDetailMapCell: BaseCollectionCell {
    
    //    lazy var customLocationWithCollection:CustomAqarWithCollectionVC = {
    //       let vv =  CustomAqarWithCollectionVC()
    ////    vv.customLocationView.collectionView.isHide(true)
    //        vv.aqarsArray = aqars
    //        vv.customLocationView.collectionView.reloadData()
    //        return vv
    //    }()
    //    var aqar: AqarModel?
    //    var aqars = [AqarModel]()
    
    var aqar:AqarModel?{
        didSet {
            guard let aqar = aqar,let Latitude = aqar.lat.toDouble(), let Longitude = aqar.lng.toDouble() else { return }
            
            let camera = GMSCameraPosition.camera(withLatitude: Latitude,
                                                  longitude: Longitude, zoom: 13.0)
            mapView.camera = camera
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: Latitude, longitude: Longitude)
            marker.map = mapView
        }
    }
    
    
    
    lazy var mapView:GMSMapView = {
        let v = GMSMapView()
        v.delegate = self
        
        return v
    }()
    
    override func setupViews() {
        backgroundColor = .white
        
        stack(mapView).withMargins(.init(top: 0, left: 16, bottom: 0, right: 16))
        //        stack(customLocationWithCollection.view)
    }
}

extension AqarDetailMapCell: GMSMapViewDelegate {
    
    
}
