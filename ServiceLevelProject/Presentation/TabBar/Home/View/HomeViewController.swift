//
//  HomeViewController.swift
//  ServiceLevelProject
//
//  Created by meng on 2022/01/22.
//

import UIKit
import NMapsMap

final class HomeViewController: UIViewController {

    private let mapView = NMFNaverMapView()
    private let genderFilterView = GenderFilterView()
    private let mapStatusButton = UIButton()

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
        view.addSubview(mapView)
        view.addSubview(genderFilterView)
    }

    private func setConstraints() {
        genderFilterView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.width.equalTo(48)
            make.height.equalTo(144)
            make.top.equalToSuperview().offset(96)
        }
    }

    private func setConfigurations() {
        mapView.frame = view.frame
    }
}
