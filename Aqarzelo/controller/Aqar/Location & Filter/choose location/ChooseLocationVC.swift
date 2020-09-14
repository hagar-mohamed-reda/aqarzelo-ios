//
//  ChooseLocationVC.swift
//  Aqarzelo
//
//  Created by Hossam on 8/9/20.
//  Copyright © 2020 Hossam. All rights reserved.
//

import UIKit
import SVProgressHUD
import GoogleMaps

protocol ChooseLocationVCProtocol {
    func getLatAndLong(lat:Double,long:Double)
}

class ChooseLocationVC: UIViewController {
    
    lazy var customChooseUserLocationView:CustomChooseUserLocationView = {
        let v = CustomChooseUserLocationView()
        v.mapView.delegate = self
        v.mapView.isMyLocationEnabled = true
        v.mapView.settings.myLocationButton = true
        v.infoImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleInfo)))
        v.doneButton.addTarget(self, action: #selector(handleDone), for: .touchUpInside)
        //        i.
        return v
    }()
    
    private let locationManager = CLLocationManager()
    var delgate: ChooseLocationVCProtocol?
    var currentLat:Double?
    var currentLong:Double?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getUserLocation()
        setupViews()
        setupNavigation()
        statusBarBackgroundColor()
    }
    
    //MARK:-User methods
    
    fileprivate  func setupViews()  {
        view.backgroundColor = .white
        view.addSubview(customChooseUserLocationView)
        customChooseUserLocationView.fillSuperview()
    }
    
    fileprivate func setupNavigation()  {
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        
        let label = UILabel(text: "Location Picker".localized, font: .systemFont(ofSize: 20), textColor: .white)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: label)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "×-2").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleDismss))
    }
    
    fileprivate func getUserLocation()  {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        
    }
    
    //TODO:-Handle methods
    
    
    
    @objc fileprivate func handleInfo()  {
        SVProgressHUD.setForegroundColor(UIColor.green)
        SVProgressHUD.showInfo(withStatus: "Please press long to pick up location".localized)
    }
    
    @objc fileprivate func handleDismss()  {
        dismiss(animated: true){[unowned self] in
            self.delgate?.getLatAndLong(lat: self.currentLat ?? 0.0, long: self.currentLong ?? 0.0)
        }
    }
    
    @objc func handleDone()  {
        dismiss(animated: true) {[unowned self] in
            self.delgate?.getLatAndLong(lat: self.currentLat ?? 0.0, long: self.currentLong ?? 0.0)
        }
    }
    
}

//MARK:-Extensions

extension ChooseLocationVC : GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, didLongPressAt coordinate: CLLocationCoordinate2D) {
        customChooseUserLocationView.mapView.clear()
        let camera = GMSCameraPosition.camera(withLatitude: coordinate.latitude, longitude: coordinate.longitude, zoom: 13.0)
        currentLat = coordinate.latitude
        currentLong = coordinate.longitude
        customChooseUserLocationView.mapView.camera = camera
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
        marker.map = customChooseUserLocationView.mapView
    }
}

//MARK:-Extensions

extension ChooseLocationVC: CLLocationManagerDelegate{
    
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation = locations.last
        currentLat = userLocation?.coordinate.latitude
        currentLong = userLocation?.coordinate.longitude
        
        let camera = GMSCameraPosition.camera(withLatitude: userLocation!.coordinate.latitude,
                                              longitude: userLocation!.coordinate.longitude, zoom: 13.0)
        customChooseUserLocationView.mapView.camera = camera
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: userLocation!.coordinate.latitude, longitude: userLocation!.coordinate.longitude)
        marker.map = customChooseUserLocationView.mapView
        
        locationManager.stopUpdatingLocation()
    }
}
