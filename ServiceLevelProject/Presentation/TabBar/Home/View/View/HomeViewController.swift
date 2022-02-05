//
//  HomeViewController.swift
//  ServiceLevelProject
//
//  Created by meng on 2022/01/22.
//

import UIKit
import CoreLocation
import NMapsMap

final class HomeViewController: UIViewController {

    private let mapView = NMFMapView()
    private let marker = NMFMarker()
    private let genderFilterView = GenderFilterView()
    private let locationButton = UIButton()
    private let mapStatusButton = MapStatusButton(status: .search)

    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        setViews()
        setConstraints()
        setConfigurations()
    }

    private func bind() {
    }

    private func setViews() {
        mapView.frame = view.frame
        view.addSubview(mapView)
        view.addSubview(genderFilterView)
        view.addSubview(locationButton)
        view.addSubview(mapStatusButton)
    }

    private func setConstraints() {
        genderFilterView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.width.equalTo(48)
            make.height.equalTo(144)
            make.top.equalToSuperview().offset(96)
        }
        locationButton.snp.makeConstraints { make in
            make.top.equalTo(genderFilterView.snp.bottom).offset(16)
            make.left.equalToSuperview().offset(16)
            make.width.height.equalTo(48)
        }
        mapStatusButton.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-16)
            make.width.height.equalTo(64)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-16)
        }
    }

    private func setConfigurations() {
        setMapView()
        locationButton.setImage(Asset.location.image, for: .normal)
        locationButton.backgroundColor = .white
        locationButton.layer.cornerRadius = 8
        locationButton.addShadow(radius: 3)
    }

    private func setMapView() {
        mapView.addCameraDelegate(delegate: self)
        let cameraPosition = mapView.cameraPosition
        marker.position = cameraPosition.target
        marker.iconImage = NMFOverlayImage(image: Asset.marker.image)
        marker.mapView = mapView

        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        if CLLocationManager.locationServicesEnabled() { //위치 켰을 때.
            locationManager.startUpdatingLocation()
        } else { //위치 껏을 때.

        }
    }
}

extension HomeViewController: NMFMapViewCameraDelegate {

    func mapView(_ mapView: NMFMapView, cameraDidChangeByReason reason: Int, animated: Bool) {
        let cameraPosition = mapView.cameraPosition
        marker.position = cameraPosition.target
    }

//    func mapView(_ mapView: NMFMapView, cameraIsChangingByReason reason: Int) {
//        print("cameraIsChangingByReason")
//    }
//
//    func mapView(_ mapView: NMFMapView, cameraWillChangeByReason reason: Int, animated: Bool) {
//        print("cameraWillChangeByReason")
//    }

    func mapViewCameraIdle(_ mapView: NMFMapView) {
        //카메라 멈추면 호출됨
        
    }
}

extension HomeViewController: CLLocationManagerDelegate {

    func getLocationUsagePermission() {
        self.locationManager.requestWhenInUseAuthorization()
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            print("GPS 권한 설정됨")
        case .restricted, .notDetermined:
            print("GPS 권한 설정되지 않음")
            getLocationUsagePermission()
        case .denied:
            print("GPS 권한 요청 거부됨")
            getLocationUsagePermission()
        default:
            print("GPS: Default")
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations[locations.count - 1]
        let longtitude: CLLocationDegrees = location.coordinate.longitude
        let latitude: CLLocationDegrees = location.coordinate.latitude
        let coord = NMGLatLng(lat: latitude, lng: longtitude)
        let cameraUpdate = NMFCameraUpdate(scrollTo: coord)
        cameraUpdate.animation = .easeIn
        mapView.moveCamera(cameraUpdate)
    }
}
