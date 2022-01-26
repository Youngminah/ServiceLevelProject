//
//  UIButton.swift
//  ServiceLevelProject
//
//  Created by meng on 2022/01/19.
//

import UIKit.UIButton

@available(iOS 15.0, *)
extension UIButton.Configuration {

    static func genderStyle(title: String, imageName: String) -> UIButton.Configuration {
        var configuration = UIButton.Configuration.filled()
        configuration.title = title
        configuration.titleAlignment = .center
        configuration.image = UIImage(named: imageName)
        configuration.baseForegroundColor = .black
        configuration.baseBackgroundColor = .white
        configuration.imagePadding = 8
        configuration.imagePlacement = .top
        configuration.background.cornerRadius = 7
        configuration.cornerStyle = .fixed
        return configuration
    }
}
