//
//  ViewController.swift
//  GCD
//
//  Created by littlema on 2019/8/22.
//  Copyright © 2019 littema. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController {
    
    var mapView: MKMapView!
    
    let locationManager = CLLocationManager()

    let speedMeasuringApparatusProvider = SpeedMeasuringApparatusProvider()
    
    let groupButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("GroupButton", for: .normal)
        button.backgroundColor = .gray
        button.addTarget(self, action: #selector(clickGroupButton(_:)), for: .touchUpInside)
        return button
    }()
    
    let semaphoreButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("SemaphoreButton", for: .normal)
        button.backgroundColor = .darkGray
        button.addTarget(self, action: #selector(clickSemaphoreButton(_:)), for: .touchUpInside)
        return button
    }()
    
    var currentRegion: MKCoordinateRegion?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupButton()

        setupMap()

        view.bringSubviewToFront(groupButton)
        view.bringSubviewToFront(semaphoreButton)
    }
    
    func setupButton() {
        view.addSubview(semaphoreButton)
        view.addSubview(groupButton)
        
        semaphoreButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        semaphoreButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        semaphoreButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
        semaphoreButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10).isActive = true
        
        groupButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        groupButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        groupButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
        groupButton.bottomAnchor.constraint(equalTo: semaphoreButton.topAnchor, constant: -16).isActive = true
    
    }
    
    func setupMap() {
        mapView = MKMapView(frame: UIScreen.main.bounds)
        
        locationManager.delegate = self
        locationManager.distanceFilter = kCLLocationAccuracyNearestTenMeters
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        
        let latDelta = 0.25
        let longDelta = 0.25
        let currentLocationSpan = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: longDelta)
        
        let center = CLLocation(latitude: 25.047342, longitude: 121.549285)
        let currentRegion = MKCoordinateRegion(center: center.coordinate, span: currentLocationSpan)
        self.currentRegion = currentRegion
        mapView.setRegion(currentRegion, animated: true)
        
        view.addSubview(mapView)
    }
    
    @objc func clickGroupButton(_ button: UIButton) {

        removeAllAnnotation()
        
        var annotations = [MKPointAnnotation(),MKPointAnnotation(), MKPointAnnotation()]
        
        let group = DispatchGroup()
        
        let queue1 = DispatchQueue(label: "queue1", attributes: .concurrent)
        
        for index in 0...2 {
            group.enter()
            queue1.async(group: group) { [weak self] in
                print("getData")
                self?.getData(offset: index * 5, completion: { (address, speedLimit) in
                    print("getPosition")
                    self?.getPosition(text: address) { placemark in
                        let annotation = MKPointAnnotation()
                        annotation.title = speedLimit
                        annotation.subtitle = placemark.name
                        if let location = placemark.location {
                            annotation.coordinate = location.coordinate
                            annotations[index] = annotation
                            group.leave()
                        }
                    }
                })
            }
        }
        
        group.notify(queue: DispatchQueue.main) { [weak self] in

            self?.mapView.showAnnotations(annotations, animated: true)
            
        }
        
    }
    
    @objc func clickSemaphoreButton(_ button: UIButton) {
        
        removeAllAnnotation()
        
        let semaphore = DispatchSemaphore(value: 1)
        let queue2 = DispatchQueue(label: "queue2", attributes: .concurrent)
        
        for index in 0...2 {
            queue2.async {
                print("getData")
                self.getData(offset: index * 5, completion: { [weak self] (address, speedLimit) in
                    print("getPosition")
                    self?.getPosition(text: address) { placemark in
                        // if semaphore.wait(timeout: .distantFuture) == .success { ... }
                        semaphore.wait()
                        let annotation = MKPointAnnotation()
                        annotation.title = speedLimit
                        annotation.subtitle = placemark.name
                        if let location = placemark.location {
                            annotation.coordinate = location.coordinate
                            self?.mapView.addAnnotation(annotation)
                            semaphore.signal()
                        }
                    }
                })
            }
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if CLLocationManager.authorizationStatus()
            == .notDetermined {
            // 取得定位服務授權
            locationManager.requestWhenInUseAuthorization()
            
            // 開始定位自身位置
            locationManager.startUpdatingLocation()
        }
            // 使用者已經拒絕定位自身位置權限
        else if CLLocationManager.authorizationStatus()
            == .denied {
            // 提示可至[設定]中開啟權限
            let alertController = UIAlertController(
                title: "定位權限已關閉",
                message:
                "如要變更權限，請至 設定 > 隱私權 > 定位服務 開啟",
                preferredStyle: .alert)
            let okAction = UIAlertAction(
                title: "確認", style: .default, handler:nil)
            alertController.addAction(okAction)
            self.present(
                alertController,
                animated: true, completion: nil)
        }
            // 使用者已經同意定位自身位置權限
        else if CLLocationManager.authorizationStatus()
            == .authorizedWhenInUse {
            // 開始定位自身位置
            locationManager.startUpdatingLocation()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        // 停止定位自身位置
        locationManager.stopUpdatingLocation()
    }
    
    func getPosition(text: String, completion: @escaping (CLPlacemark) -> Void) {
        let geofenceRegion = CLCircularRegion(center: currentRegion!.center, radius: 400, identifier: "PlayaGrande")
        CLGeocoder().geocodeAddressString(text, in: geofenceRegion, completionHandler: { placemarks, error in
            print("CLGeocoder")
            
            if (error != nil) {
                print(error)
                return
            }
            
            //print("placemarks \(placemarks)")
            
            if let placemark = placemarks?[0]  {
                print(placemark.name)
                completion(placemark)
            }
        })
        
    }
    
    func getData(offset: Int, completion: @escaping (String, String) -> Void) {
        speedMeasuringApparatusProvider.fetchData(limit: 1, offset: offset) { result in
            switch result {
            case .success(let speedMeasuringApparatusResponse):
                let area = speedMeasuringApparatusResponse.result.results[0].area
                let road = speedMeasuringApparatusResponse.result.results[0].road
                let location = speedMeasuringApparatusResponse.result.results[0].location
                let speedLimit = speedMeasuringApparatusResponse.result.results[0].speedLimit
                print("台北市\(area)區\(road)")
                completion("臺北市\(area)區\(road)\(location)", speedLimit)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func removeAllAnnotation() {
        for annotation in mapView.annotations {
            mapView.removeAnnotation(annotation)
        }
    }
    
}

extension ViewController: CLLocationManagerDelegate {
    
//    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//        if annotation is MKUserLocation {
//            return nil
//        }
//    }
    
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        // 印出目前所在位置座標
//        let currentLocation = locations[0] as CLLocation
//        print("\(currentLocation.coordinate.latitude), \(currentLocation.coordinate.longitude)")
//    }
    
}

extension ViewController: MKMapViewDelegate {
    
}

//        let queue2 = DispatchQueue(label: "queue2", attributes: .concurrent)
//        group.enter()
//        queue2.async(group: group) {
//            self.getPosition(text: address) { placemark in
//                let lat = String(format: "%.04f", (placemark.location?.coordinate.longitude ?? 0.0)!)
//                let lon = String(format: "%.04f", (placemark.location?.coordinate.latitude ?? 0.0)!)
//                let name = placemark.name!
//
//                let annotation = MKPointAnnotation()
//                annotation.title = name
//                //annotation.subtitle = self.restaurant.type
//                if let location = placemark.location {
//
//                    // 顯示標註
//                    annotation.coordinate = location.coordinate
//                    self?.locations.append(annotation)
//                    self?.mapView.addAnnotation(annotation)
//                    //showAnnotations(self!.locations, animated: false)
//                    //self.mapView.selectAnnotation(annotation, animated: true)
//                }
//
//                print("\(lat) \(lon) \(name) ")
//            }
//            group.leave()
//        }
