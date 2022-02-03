//
//  HomeViewController.swift
//  ServiceLevelProject
//
//  Created by meng on 2022/01/22.
//

import UIKit
import NMapsMap

final class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let naverMapView = NMFNaverMapView(frame: view.frame)
        view.addSubview(naverMapView)
    }
}
