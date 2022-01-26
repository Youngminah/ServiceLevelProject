//
//  UIViewController.swift
//  ServiceLevelProject
//
//  Created by meng on 2022/01/20.
//

import UIKit
import Toast

extension UIViewController {

    func makeToastStyle() {
        var style = ToastStyle()
        style.messageFont = .body4R12
        style.messageColor = .white
        style.backgroundColor = .black
        style.titleAlignment = .center
        ToastManager.shared.style = style
    }
}
