//
//  HomeViewController.swift
//  ServiceLevelProject
//
//  Created by meng on 2022/01/22.
//

import UIKit
import CoreLocation

import NMapsMap
import SnapKit
import RxSwift
import RxCocoa

final class HomeViewController: UIViewController {

    private let mapView = NMFMapView()
    private let genderFilterView = GenderFilterView()
    private let myLocationButton = UIButton()
    private let mapStatusButton = MapStatusButton(status: .search)
    private let centerMarkerImageView = UIImageView(image: Asset.marker.image)
    private let locationManager = CLLocationManager()

    //private var centerCoordinator = NMGLatLng(lat: 37.482733, lng: 126.92983)

    private lazy var input = HomeViewModel.Input(
        genderFilterInfo: genderFilterView.genderRelay.asObservable(),
        requestOnqueueInfo: requestOnqueueInfo.asObservable(),
        myLocationButtonTap: myLocationButton.rx.tap.asSignal(),
        isAutorizedLocation: isAutorizedLocation.asSignal(),
        mapStatusButtonTap: mapStatusButton.rx.tap.asSignal()
    )
    private lazy var output = viewModel.transform(input: input)
    private let viewModel: HomeViewModel
    private let disposdBag = DisposeBag()

    private let isAutorizedLocation = PublishRelay<Bool>()
    private let requestOnqueueInfo = PublishRelay<Coordinate>()

    private var markers = [NMFMarker]()

    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("HomeViewController: fatal error")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        setViews()
        setConstraints()
        setConfigurations()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        let centerCoordi = mapView.cameraPosition.target
        requestOnqueueInfo.accept(Coordinate(latitude: centerCoordi.lat, longitude: centerCoordi.lng))
    }

    private func bind() {
        output.confirmAuthorizedLocation
            .emit(onNext: { [weak self] _ in
                let auth = self?.locationManager.authorizationStatus
                let status = auth == .authorizedAlways || auth == .authorizedWhenInUse
                self?.isAutorizedLocation.accept(status)
            })
            .disposed(by: disposdBag)

        output.updateLocationAction
            .emit(onNext: { [weak self] _ in
                self?.locationManager.startUpdatingLocation()
            })
            .disposed(by: disposdBag)

        output.unAutorizedLocationAlert
            .emit(onNext: { [weak self] (title, message) in
                guard let self = self else { return }
                let alert = AlertView.init(title: title, message: message) {
                    self.moveToPhoneSetting()
                }
                alert.showAlert()
            })
            .disposed(by: disposdBag)

        output.onqueueList
            .emit(onNext: { [weak self] sesacs in
                guard let self = self else { return }
                self.removeMarkers()
                sesacs.forEach { sesac in
                    self.setSesacFriendMarker(sesac: sesac)
                }
            })
            .disposed(by: disposdBag)
    }

    private func setViews() {
        mapView.frame = view.frame
        view.addSubview(mapView)
        view.addSubview(genderFilterView)
        view.addSubview(myLocationButton)
        view.addSubview(mapStatusButton)
        view.addSubview(centerMarkerImageView)
    }

    private func setConstraints() {
        genderFilterView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.width.equalTo(48)
            make.height.equalTo(144)
            make.top.equalToSuperview().offset(96)
        }
        myLocationButton.snp.makeConstraints { make in
            make.top.equalTo(genderFilterView.snp.bottom).offset(16)
            make.left.equalToSuperview().offset(16)
            make.width.height.equalTo(48)
        }
        mapStatusButton.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-16)
            make.width.height.equalTo(64)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-16)
        }
        centerMarkerImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.snp.centerY)
            make.width.equalTo(40)
            make.height.equalTo(42)
        }
    }

    private func setConfigurations() {
        setMapView()
        navigationItem.backButtonTitle = ""
        myLocationButton.setImage(Asset.location.image, for: .normal)
        myLocationButton.backgroundColor = .white
        myLocationButton.layer.cornerRadius = 8
        myLocationButton.addShadow(radius: 3)
    }

    private func setMapView() {
        mapView.addCameraDelegate(delegate: self)
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        updateMyLocation()
    }

    private func updateMyLocation() {
        let authorization = self.locationManager.authorizationStatus
        if authorization == .authorizedAlways || authorization == .authorizedWhenInUse {
            self.isAutorizedLocation.accept(true)
            locationManager.startUpdatingLocation()
        } 
    }

    private func moveToPhoneSetting() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }

    private func removeMarkers() {
        self.markers.forEach { $0.mapView = nil }
        self.markers = []
    }

    private func setSesacFriendMarker(sesac: SesacDB) {
        let marker = NMFMarker()
        markers.append(marker)
        marker.iconImage = NMFOverlayImage(image: sesac.sesac.image)
        marker.position = NMGLatLng(lat: sesac.coordinator.latitude, lng: sesac.coordinator.longitude)
        marker.width = 80
        marker.height = 80
        marker.mapView = mapView
    }
}

extension HomeViewController: NMFMapViewCameraDelegate {

    func mapViewCameraIdle(_ mapView: NMFMapView) {
        print("mapViewCameraIdle-->")
        print("가운데 좌표 :", mapView.cameraPosition.target)
        let centerCoordi = mapView.cameraPosition.target
        requestOnqueueInfo.accept(Coordinate(latitude: centerCoordi.lat, longitude: centerCoordi.lng))
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
        let coordi = NMGLatLng(lat: latitude, lng: longtitude)
        let cameraUpdate = NMFCameraUpdate(scrollTo: coordi)
        cameraUpdate.animation = .easeIn
        mapView.moveCamera(cameraUpdate)
        locationManager.stopUpdatingLocation()
    }
}
